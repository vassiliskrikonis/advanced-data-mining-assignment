package com.vassiliskrikonis

import org.geotools.referencing.{CRS, GeodeticCalculator}
import org.opengis.referencing.crs.CoordinateReferenceSystem

case class Point(lon: Float, lat: Float)

object Utils {
  val crs: CoordinateReferenceSystem = CRS.decode("EPSG:4326")

  def distance(p1:Point, p2: Point): Double = {
    val gc = new GeodeticCalculator (crs)
    gc.setStartingGeographicPoint (p1.lon, p1.lat)
    gc.setDestinationGeographicPoint (p2.lon, p2.lat)
    gc.getOrthodromicDistance // in meters
  }
}
