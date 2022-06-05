library(shiny)

ui <- fluidPage(
  titlePanel("Stats 20 - Team Shoggoth"),
  sliderInput(inputId = "num",
              label = "Please choose a value",
              value = 25, min = 1, max = 1000),
  
  p("We can add text to document our work"),
  br(), # a line break
  code("Using p(), br() and code()"), # if you want to highlight code
  plotOutput("norm")
)

server <- function(input, output) {
  output$norm <- renderPlot({
    title <- "Random Normal Values"
    xlab <- "Z Score"
    hist(rnorm(input$num), main = title, freq = FALSE, xlab = xlab)})
}

shinyApp(ui = ui, server = server)

## server - objects to be displayed are saved in output$ and hist is passed to plotOutput
## displayed objects use a render*() function, here, renderPlot() -- builds what will be displayed
## renderDataTable, renderImage, renderTable, renderText etc.
## within {} in renderPlot is the actual code that will build a histogram based on
## user input (ui)
## access the input values with input$

## we could save this file as app.R in a folder and run it on our computer
## can also pay to have it run on a server