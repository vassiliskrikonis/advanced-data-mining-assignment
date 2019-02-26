/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.vassiliskrikonis

import com.vassiliskrikonis.Events._
import org.apache.flink.cep.scala.CEP
import org.apache.flink.streaming.api.TimeCharacteristic
import org.apache.flink.streaming.api.scala._

object StreamingJob {

  case class Port(lon: Float, lat: Float)

  def loadPorts: List[Port] = {
    val portsCsvSource = io.Source.fromFile("data/ports.csv")
    val ports = portsCsvSource.getLines().toList
      .drop(1) // skip header line
      .map(_.replaceAll("\"", ""))
      .map(_.split(","))
      .map(arr => Port(arr(0).toFloat, arr(1).toFloat))
    portsCsvSource.close()
    ports
  }

  def distanceFromPorts(ports: List[Port])(point: Point): Double = {
    val portDistances = ports.map { port =>
      Utils.distance(point, Point(port.lon, port.lat))
    }
    portDistances.min
  }

  def main(args: Array[String]) {
    // set up the streaming execution environment
    val parallelism = 1
    val env = StreamExecutionEnvironment.createLocalEnvironment(parallelism)

    env.setStreamTimeCharacteristic(TimeCharacteristic.EventTime)

    val ports = loadPorts

    val lines = env.readTextFile("data/dynamic_ships_subset-2-sorted.csv")
    val signals = lines.map(parseSignal _).filter(_.isSuccess).map(_.get).assignAscendingTimestamps(_.ts)

    val extendedSignals = signals
      .map((_, 0L, false))
      .keyBy(_._1.mmsi)
      .reduce((e1, e2) => (e2._1, e2._1.ts - e1._1.ts, e1._1.mmsi == e2._1.mmsi))
      .map { e =>
        val signal = e._1
        val delta = e._2
        extendedAIS(
          signal.mmsi,
          signal.status,
          signal.speed,
          signal.lon,
          signal.lat,
          distanceFromPorts(ports)(Point(signal.lon, signal.lat)),
          signal.ts, delta
        )
      }

    val gapStream = CEP.pattern(extendedSignals.keyBy(_.mmsi), Patterns.communicationGap)

    gapStream.select { pat =>
      val e1 = pat("gapStart").iterator.next()
      val e2 = pat("gapEnd").iterator.next()

      assert(e1.mmsi == e2.mmsi)
      (e2.mmsi, e1.lon, e1.lat, e2.lon, e2.lat, e2.ts - e1.ts)
    }.writeAsCsv("data/gap_results" + (if (parallelism == 1) ".csv" else "/"))

    // execute program
    env.execute("Flink Streaming Scala API Skeleton")
  }
}
