#
# A modified example of a Shiny App
# Click the 'Run App' button above to see it
#

###########
# call up any needed packages
library(shiny)

###########
# if you have non-built in data or data external to the program
# this is a good time to make it available to Shiny
colleges <- readRDS("Little1.RDS")

# I like performing the data handling with the data read
# but this is not required, it could be done later
age <- colleges$AGE_ENTRY
age24 <- colleges$AGEGE24[!is.na(colleges$AGEGE24)]
loans <- colleges$LOAN_EVER[!is.na(colleges$LOAN_EVER)]

# Define UI for application that draws a histogram
ui <- fluidPage(
    ## I can change the fonts and background color
    tags$head(tags$style(
        HTML('
        body, form.well, input, div, button, select { 
            font-family: "Covered By Your Grace";
            background-color: gold;
        }')
    )),
    
    ## we can add HTML elements
    h1("Header 1 - maybe an Introduction"),
    br(), # line break
    h2("Header 2 - maybe a section heading"),
    p(strong("bold")), p(em("italic")), p(code("code")),
    br(),
    h3("Header 3 - maybe a subsection heading"),
    a(href="https://shiny.rstudio.com/images/shiny-cheatsheet.pdf", "Shiny Cheatsheet Online"), 
    br(),
    h4("Header 4"),
    img(src='https://s3.amazonaws.com/cms.ipressroom.com/173/files/20203/5e99ec062cfac21b62081f02_200416_ulca_MGL6265/200416_ulca_MGL6265_hero.jpg', 
        height="50%", width="50%"),
    hr(),

    # Application title
    titlePanel("California College Data"),

      # Slider input for number of bins 
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),

        # Show a plot of the generated distribution
        mainPanel(
            splitLayout(plotOutput("distPlot"),
                        plotOutput("distPlot2"))
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
        par(bg = 'gold')
        hist(x, breaks = bins, col = 'DodgerBlue', border = 'black',
             main = title, xlab = xlab)
        box()
    })
    output$distPlot2 <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- loans
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        title <- "Distribution of Loan Recipient Proportion"
        xlab <- "proportion ever using student loans"
        par(bg = 'gold')
        hist(x, breaks = bins, col = 'DodgerBlue', border = 'black',
             main = title, xlab = xlab)
        box()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
