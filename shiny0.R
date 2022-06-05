## This basic structure is required in every shiny app
## This particular one will open a blank page in Shiny

library(shiny) # need to call Shiny

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

## ui defines the elements that will be displayed on the page, 
## they are arguments to the fluidpage() function
## Shiny will process the outputs from server
## shinyApp puts it all together -- the input, display and processing of the daata