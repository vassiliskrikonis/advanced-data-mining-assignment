package com.vassiliskrikonis

import scala.util.Try

object Events {
  case class AIS(mmsi: String, status: Int, speed: Float, lon: Float, lat: Float, ts: Long)
  case class extendedAIS(mmsi: String, status: Int, speed: Float, lon: Float, lat: Float, portDist: Double, ts: Long, delta: Long)

  def parseSignal(s: String): Try[AIS] = {
    // "id","mmsi","status","turn","speed","course","heading","lon","lat","ts","geom"
    val Array(_, mmsi, status, _, speed, _, _, lon, lat, ts, _) = s.split(",").map {
      _.replaceAll("\"", "")
    }
    Try(AIS(mmsi, status.toInt, speed.toFloat, lon.toFloat, lat.toFloat, ts.toLong))
  }

  val MIN_GAP_DURATION: Int = 5 * 60 // in seconds
  val vesselFarFromPort: extendedAIS => Boolean = (s: extendedAIS) => s.portDist > 5000
}
