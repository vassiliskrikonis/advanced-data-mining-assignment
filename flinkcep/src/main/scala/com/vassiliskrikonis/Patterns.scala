package com.vassiliskrikonis

import com.vassiliskrikonis.Events.{extendedAIS, vesselFarFromPort, MIN_GAP_DURATION}
import org.apache.flink.cep.scala.pattern.Pattern
import org.apache.flink.streaming.api.windowing.time.Time

object Patterns {
  val communicationGap = Pattern.begin[extendedAIS]("gapStart")
    .where(vesselFarFromPort)
    .next("gapEnd")
    .where(vesselFarFromPort)
    .where { (e, ctx) =>
      val prevTs = ctx.getEventsForPattern("gapStart").last.ts
      e.ts - prevTs > MIN_GAP_DURATION
    }
    .within(Time.hours(12))
}
