# source https://gist.github.com/jcheng5/cbcc3b439a949deb544b

library(ggplot2)
library(shiny)

# Call ggbrush with a ggplot2 object, and the dimensions which
# should be brushed (try "xy" for scatter, "x" for histogram).
# The plot will show in RStudio Viewer or your web browser, and
# any observations selected by the user will be returned.
ggbrush <- function(plotExpr, direction = c("xy", "x", "y")) {
  
  # See below for definition of dialogPage function
  ui <- dialogPage(
    plotOutput("plot", brush = brushOpts(id = "brush", direction = direction),
               width = "100%", height = "100%" # Fill the dialog
    )
  )
  
  server <- function(input, output, session) {
    # Show the plot... that's important.
    output$plot <- renderPlot(plotExpr)
    
    # The part of the data frame that is currently brushed (or
    # NULL if no brush is active)
    brushed <- reactive({
      if (is.null(input$brush))
        return(NULL)
      else
        brushedPoints(plotExpr$data, input$brush)
    })
    
    # Show a message giving instructions, or showing how many
    # rows are selected
    output$msg <- renderText({
      if (is.null(brushed()))
        return("Click and drag to select, then press Done \u27f6")
      
      count <- nrow(brushed())
      sprintf("%d %s selected",
              count, 
              ifelse(count == 1, "observation", "observations")
      )
    })
    
    # When the Done button is clicked, return the brushed
    # rows to the caller.
    observeEvent(input$done, {
      stopApp(brushed())
    })
  }
  
  shiny::runApp(shinyApp(ui, server), launch.browser = getOption("viewer", TRUE))
}

# Helper function to present Shiny controls in a dialog-like layout
dialogPage <- function(outputControl) {
  bootstrapPage(
    tags$style("
               html, body { width: 100%; height: 100%; overflow: none; }
               #dialogMainOutput { position: absolute; top: 10px; left: 10px; right: 10px; bottom: 40px; }
               #dialogControls {
               position: absolute; bottom: 0px; left: 0px; right: 0px; height: 40px;
               padding: 10px 10px 0 10px;
               background-color: #444; color: white;
}"),
    tags$div(id = "dialogMainOutput", outputControl),
    tags$div(id = "dialogControls",
      textOutput("msg", inline = TRUE),
      actionButton("done", "Done", class = "btn btn-primary btn-xs pull-right")
    )
  )
}
 
#' @examples
#' 
#' p <- ggplot(diamonds, aes(carat, price)) + geom_point() + facet_wrap(~cut)
#' ggbrush(p)
#' 
#' p <- ggplot(diamonds, aes(x=carat)) + geom_bar()
#' ggbrush(p, direction = "x")
