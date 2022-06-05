###########################
#
#  app4.R
#
###########################

library(shiny)
colleges <- readRDS("Little1.RDS")
IN_TUIT <- colleges[ , c("INSTNM", "TUITIONFEE_IN")]
SATMT75 <- colleges[ , c(4,38)]
ADM_RATE <- colleges[ , c(4,33)]

# Define UI for application that draws a histogram
ui <- fluidPage(
    ## we can add HTML elements
    h1("Introduction"),
    p("Hi, we are Team Shoggoth from Miskatonic University"),
    br(), # line break
    p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sit amet pellentesque enim, 
    ut imperdiet tellus. Nulla eget sollicitudin mi. Nullam varius ullamcorper ipsum in volutpat. 
    Nullam iaculis dapibus enim sed vulputate. Praesent fringilla eleifend cursus. Phasellus 
    semper ex nisi, sed tristique leo congue eu. Nullam quam sapien, cursus eu ex at, venenatis 
    fringilla nulla. Praesent in molestie leo. Ut auctor congue nisi sed ullamcorper. In imperdiet 
    orci at felis blandit venenatis. In nisl ex, hendrerit quis purus vel, efficitur congue orci. 
    Nulla in sollicitudin libero. Phasellus vel ante sed ante mattis vestibulum. Aenean mattis, 
    ex et vestibulum accumsan, sapien eros sagittis enim, vitae porttitor neque nisl ut lectus. 
    Vestibulum suscipit sapien quis mi porttitor ornare."),

    # Application title
    titlePanel("Important Statistics"),

    # menu 
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "caption",
                      label = "Caption:",
                      value = "Summary"),
            
            # Input: Selector for choosing measures ----
            selectInput(inputId = "value",
                        label = "Choose a measurementt:",
                        choices = c("Instate Tuition", "SAT MATH 75th PERCENTILE", "ADMISSION RATE")),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "obs",
                         label = "Number of observations to view:",
                         value = 10)
            
        ),

        # what will be displayed
        mainPanel(
            h3(textOutput("caption", container = span)),
            verbatimTextOutput("summary"),
            tableOutput("view")
        )
    )
)

# Define server logic required to select different measures
server <- function(input, output) {
    datasetInput <- reactive({
        switch(input$value,
               "Instate Tuition" = IN_TUIT,
               "SAT MATH 75th PERCENTILE" = SATMT75,
               "ADMISSION RATE" = ADM_RATE)
    })
    output$caption <- renderText({
        input$caption
    })
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset[,2])
    })
    output$view <- renderTable({
        head(datasetInput()[order(datasetInput()[2], decreasing = TRUE),], n = input$obs)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
