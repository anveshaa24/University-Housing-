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

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

## fluidPage -- page layout -- Fluid pages scale their components 
## in realtime to fill all available browser width.
## functions within fluidPage are input and output with some layout

## *Input functions -- creates input, e.g., sliderInput
## *Output functions -- e.g., plotOutput -- what is displayed
## a plot will be displayed of an output object called "norm"
## we have not defined "norm" yet, that happens in the server portion
## commas are used to separate the arguments

## note: sliderInput(inputId, label, ...) 
## inputId is used to access the value
