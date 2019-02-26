package com.vassiliskrikonis

import scala.util.Try

object Events {
  type Mmsi = String

  object Thresholds {
    val MIN_GAP_DURATION: Int = 5 * 60 // in seconds
    val FAR_FROM_PORT: Double = 5000 // in meters
    val LOW_SPEED: Float = 1 // in knots
  }

  case class AIS(mmsi: Mmsi, status: Int, speed: Float, lon: Float, lat: Float, ts: Long)
  case class extendedAIS(mmsi: Mmsi, status: Int, speed: Float, lon: Float, lat: Float, portDist: Double, ts: Long, delta: Long)
  case class LowSpeed(mmsi: Mmsi, speed: Float)
  case class Stopped(mmsi: Mmsi, portDist: Double)

  def parseSignal(s: String): Try[AIS] = {
    // "id","mmsi","status","turn","speed","course","heading","lon","lat","ts","geom"
    val Array(_, mmsi, status, _, speed, _, _, lon, lat, ts, _) = s.split(",").map {
      _.replaceAll("\"", "")
    }
    Try(AIS(mmsi, status.toInt, speed.toFloat, lon.toFloat, lat.toFloat, ts.toLong))
  }

  val vesselFarFromPort: extendedAIS => Boolean = (s: extendedAIS) => s.portDist > Thresholds.FAR_FROM_PORT
}
