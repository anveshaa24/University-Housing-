#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
colleges <- readRDS("Little1.RDS")
age <- colleges$AGE_ENTRY

# Define UI for application that draws a histogram
ui <- fluidPage(
    ## we can add HTML elements
    h1("Header 1 - maybe an Introduction"),
    br(), # line break
    h2("Header 2 - maybe a section heading"),
    p(strong("bold")), p(em("italic")), p(code("code")),
    hr(),
    h3("Header 3 - maybe a subsection heading"),
    a(href="https://shiny.rstudio.com/images/shiny-cheatsheet.pdf", "Shiny Cheatsheet Online"), 
    br(),
    h4("Header 4"),
    img(src='sunset.jpg'),

    # Application title
    titlePanel("California College Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- age
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        title <- "Distribution of Age at Entry"
        xlab <- "mean age at entry"
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             main = title, xlab = xlab)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
