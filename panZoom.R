# install.packages("htmlwidgets")
# devtools::install_github("timelyportfolio/svgPanZoom")
# devtools::install_github("duncantl/SVGAnnotation")
# install.packages("choroplethrMaps")

library(svgPanZoom)
library(SVGAnnotation)
library(choroplethr)
library(ggplot2)

# start with svgPlot
#  and use example from ?state_choropleth
data(df_pop_state)
sc <- state_choropleth(
  df_pop_state
  , title="US 2012 State Population Estimates"
  , legend="Population"
)

svgPanZoom(
  svgPlot(
    show(sc)
    # will need to manually specify height/width
    ,height = 9, width = 17
  )
)