raster_a_marco <- function(r,crs){
  p1 <- Polygon(extent(r),hole = TRUE)
  p2 <- Polygons(list(p1), 1)
  p3 <- SpatialPolygons(list(p2),proj4string = crs)
  return(p3)
}