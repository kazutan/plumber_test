library(plumber)
library(tidyverse)
library(leaflet)

#* @apiTitle my first api.

#* Echo back the input
#* @param msg1 The message1 to echo
#* @param msg2 The message2 to echo
#* @get /echo2
function(msg1 = "", msg2 = "") {
  paste(msg1, "-", msg2)
}

#* Plotting
#* @param type type of iris
#* @png
#* @get /plot
function(type = "setosa") {
  df <- iris %>% 
    filter(Species == type)
  p <- ggplot(df, aes(Sepal.Length, Sepal.Width)) +
    geom_point() +
    ggtitle(type)
  print(p)
}

#* Map
#* @param lng longtitude
#* @param lat latitude
#* @param zoom zoom
#* @serializer htmlwidget
#* @get /map
function(lng = 135, lat = 38, zoom = 7) {
  lng <- as.numeric(lng)
  lat <- as.numeric(lat)
  zoom <- as.numeric(zoom)
  map <- leaflet(elementId = "mapWgt") %>% 
    addTiles() %>% 
    setView(lng = lng, lat = lat, zoom = zoom)
  map
}

#* create report with rmd
#* @param res res
#* @serializer contentType list(type="application/html")
#* @get /rmd_test
function(res, nrow = 10) {
  tmp <- tempfile()
  rmarkdown::render("include_rmd_test.Rmd", output_file = tmp, params = list(nrow = nrow))
  include_html(tmp, res)
}
