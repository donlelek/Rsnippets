# my answer to 
# http://stackoverflow.com/questions/38806503/shiny-click-brush-not-working-with-non-cartesian-coordinates

library(shiny)
library(dplyr)
library(maps)
library(mapdata)


mapPoints <- data.frame(Longitude = c(-103, -108, -130, -120),
                        Latitude  = c(  52,   40,   45,   54))

ui <- fluidPage(
  fluidRow(
    column(width = 6, 
           plotOutput("plot1", 
                      height = 300, 
                      click  = "plot1_click", 
                      brush  = "plot1_brush"))
  ),
  fluidRow(
    column(width = 6, 
           h4("Near points"),
           verbatimTextOutput("click_info")),
    column(width = 6, 
           h4("Brushed points"),
           verbatimTextOutput("brush_info"))
  )
)

server <- function(input, output) {
  # output world map
  output$plot1 <- renderPlot({
    map('worldHires')
    points(mapPoints$Longitude,
           mapPoints$Latitude, 
           col = "red",
           pch = 16)
  })
  # output clicked points 
  output$click_info <- renderPrint({
    nearPoints(mapPoints,
               xvar = "Longitude", 
               yvar = "Latitude",
               input$plot1_click)
  })
  # output brushed points 
  output$brush_info <- renderPrint({
    brushedPoints(mapPoints,
                  xvar = "Longitude", 
                  yvar = "Latitude",
                  input$plot1_brush)
  })
}

shinyApp(ui, server)
