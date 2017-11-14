# devtools::install_github("rstudio/leaflet")

library(leaflet)

leaflet() %>% addTiles() %>%
  setView(-72.9066, -41.4635, zoom=15) %>%
  addPopups(-72.9066, -41.4636, "Popup")
