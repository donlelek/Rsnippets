# devtools::install_github("rstudio/leaflet")

library(leaflet)

leaflet() %>% addTiles() %>%
  setView(-72.9066, -41.4628, zoom=15) %>%
  addPopups(-72.9066, -41.4629, "Mi Casa")
