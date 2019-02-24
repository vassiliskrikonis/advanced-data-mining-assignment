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

import org.apache.flink.cep.scala.CEP
import org.apache.flink.cep.scala.pattern.Pattern
import org.apache.flink.streaming.api.TimeCharacteristic
import org.apache.flink.streaming.api.scala._
import org.apache.flink.streaming.api.windowing.time.Time
import org.geotools.referencing.{CRS, GeodeticCalculator}
import org.opengis.referencing.crs.CoordinateReferenceSystem
import scala.util.Try

/**
  * Skeleton for a Flink Streaming Job.
  *
  * For a tutorial how to write a Flink streaming application, check the
  * tutorials and examples on the <a href="http://flink.apache.org/docs/stable/">Flink Website</a>.
  *
  * To package your application into a JAR file for execution, run
  * 'mvn clean package' on the command line.
  *
  * If you change the name of the main class (with the public static void main(String[] args))
  * method, change the respective entry in the POM.xml file (simply search for 'mainClass').
  */

object StreamingJob {
  def main(args: Array[String]) {
    // set up the streaming execution environment
    val parallelism = 1
    val env = StreamExecutionEnvironment.createLocalEnvironment(parallelism)

    env.setStreamTimeCharacteristic(TimeCharacteristic.EventTime)

    // "id","mmsi","status","turn","speed","course","heading","lon","lat","ts","geom"
    case class AIS(mmsi: String, status: Int, lon: Float, lat: Float, ts: Long)
    case class extendedAIS(mmsi: String, status: Int, lon: Float, lat: Float, portDist: Double, ts: Long, delta: Long)
    case class Port(lon: Float, lat: Float)

    val portsCsvSource = io.Source.fromFile("data/ports.csv")
    val ports = portsCsvSource.getLines().toList
      .drop(1) // skip header line
      .map(_.replaceAll("\"", ""))
      .map(_.split(","))
      .map(arr => Port(arr(0).toFloat, arr(1).toFloat))
    portsCsvSource.close()

    val crs: CoordinateReferenceSystem = CRS.decode("EPSG:4326")

    val getPortDistance = { e: AIS =>
      val portDistances = ports.map { p: Port =>
        val gc = new GeodeticCalculator(crs)
        gc.setStartingGeographicPoint(e.lon, e.lat)
        gc.setDestinationGeographicPoint(p.lon, p.lat)
        gc.getOrthodromicDistance // in meters
      }
      //      val portDistances = ports.map { p =>
      //        Haversine.haversine(p.lat, p.lon, e.lat, e.lon)
      //      }

      portDistances.min
    }

    def parseSignal(s: String): Try[AIS] = {
      val Array(_, mmsi, status, _, _, _, _, lon, lat, ts, _) = s.split(",").map {
        _.replaceAll("\"", "")
      }
      Try(AIS(mmsi, status.toInt, lon.toFloat, lat.toFloat, ts.toLong))
    }

    val lines = env.readTextFile("data/dynamic_ships_subset-2-sorted.csv")
    val signals = lines.map(parseSignal _).filter(_.isSuccess).map(_.get).assignAscendingTimestamps(_.ts)

    val extendedSignals = signals
      .map((_, 0L, false))
      .keyBy(_._1.mmsi)
      .reduce((e1, e2) => (e2._1, e2._1.ts - e1._1.ts, e1._1.mmsi == e2._1.mmsi))
      .map { e =>
        val signal = e._1
        val delta = e._2
        extendedAIS(signal.mmsi, signal.status, signal.lon, signal.lat, getPortDistance(signal), signal.ts, delta)
      }

    val MIN_GAP_DURATION = 5 * 60 // in seconds
    val vesselFarFromPort = (s: extendedAIS) => s.portDist > 5000

    val communicationGap = Pattern.begin[extendedAIS]("gapStart")
      .where(vesselFarFromPort)
      .next("gapEnd")
      .where(vesselFarFromPort)
      .where { (e, ctx) =>
        val prevTs = ctx.getEventsForPattern("gapStart").last.ts
        e.ts - prevTs > MIN_GAP_DURATION
      }
      .within(Time.hours(12))

    val gapStream = CEP.pattern(extendedSignals.keyBy(_.mmsi), communicationGap)

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
