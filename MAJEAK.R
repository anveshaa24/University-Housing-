library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(readxl)

college <- read_excel("college.xlsx") # Please download attached Excel file!!
college <- college[!(college$UGTENR17 == 0), ]
ROOMS <- college$ROOMS
ENROLLMENT <- college$UGTENR17
UGenroll <- college$UGTENR17
college$HOUSING_PCT <- as.integer((ROOMS/ENROLLMENT)*100)
college$HOUSING_PCT <- replace(college$HOUSING_PCT, college$HOUSING_PCT > 100, 100)
college$LEGEND <- cut(college$HOUSING_PCT, breaks = c(-1,0,25,50,75,100),
                      labels = c("No Housing Provided", ">0%-25%","26%-50%","51%-75%","76%-100%"))
LEGEND <- college$LEGEND
NAME <- college$NAME

ui <- fluidPage(
  h1("Undergraduate Total Enrollment (2017) vs. Total Dorming Capacity at US Colleges"), 
  h2("Introduction"),
    p("Hello! We are Team MAJEAK. Our team includes Angela Kan,
      Anvesha Dutta, Ellen Wei, Jonathan Yun, and Kayla Teng. We are
      UCLA students taking Professor Lew\'s Spring 2021 Statistics 20 course."),
    br(),
    p("We want to draw attention to college housing crises throughout the nation by
    looking at undergraduate housing availability by college, location, and undergraduate
    enrollment. As a result, we strive to compare undergraduate total enrollment numbers (Fall 2017)
    with the total dormitory capacity of each college on an interactive map, with each 
    college color-coded by the intensity of its housing crisis."),
    h2("About"),
    p("We found the proportion percentage between total undergraduate enrollment 
      and total dorming capacity to see what percentage of housing is available for undergraduate students at each school.
      Since not all undergraduates live on campus and some graduate students live on campus, we decided to assign 1 room 
      to 1 student to see the proportion of available housing for undergraduate students at a particular school. 
      We included an interactive map, a slider for the map, and a data table showing information about each 
      university's housing availability and hope that users will gain more clarification about the undergraduate housing crisis 
      across America"),
    titlePanel("Interactive Map and Data Table"),
    p("On the interactive map, you can zoom in and out and click on the different circle markers for a popup of information regarding 
      undergraduate enrollment and housing. You can also use the slider to filter schools based on percentage of 
      housing availability in the map and use the selector and search bar below the map to filter schools in the data table."),
    
  sidebarLayout(position = "right",
    sidebarPanel(
      sliderInput("housing", "% of Available Undergraduate Housing", 
                  min(college$HOUSING_PCT), 
                  max(college$HOUSING_PCT),
                  value = range(college$HOUSING_PCT), 
                  step = 1)
      ),
      mainPanel(leafletOutput("map"))
    ),
br(),
fluidRow(
  column(4,
         selectInput(inputId = "available",
                     label = "Housing Availability (select one)",
                     selectize = FALSE,
                    choices = c("All", "No Housing Provided", ">0%-25%","26%-50%","51%-75%","76%-100%")),
  )),
  dataTableOutput("table"),
h6("For more accurate results, please type the FULL NAME
               of the college, city, or state you want in the search bar."),
h6("(EX: Search University of Southern California, not USC | Los Angeles, not L.A.)")
)
    
server <- function(input, output) {
  mapslider <- reactive({
    college[college$HOUSING_PCT >= input$housing[1] & college$HOUSING_PCT <= input$housing[2], ]
    })
  legendcolors <- colorFactor(c("red4", "red", "orange", "yellow", "green"), college$LEGEND)
    output$map <- renderLeaflet({
      leaflet(college) %>%
            setView(lng = -118.4245, lat = 34.05367, zoom = 15) %>%
            addProviderTiles("CartoDB.Positron") %>%
        addLegend(
            "bottomleft", 
            pal = legendcolors, 
            values = ~LEGEND, 
            opacity = 1,
            title = "Housing Availability by Proportion of Rooms by Total UG Enrollment")
      })
    observe({
      leafletProxy("map", data = mapslider()) %>%
        clearMarkers() %>%
             addCircleMarkers(
                     lng = ~LONGITUDE,
                     lat = ~LATITUDE, 
                     radius = 5,
                     stroke = FALSE, 
                     fillOpacity = 0.5, 
                     color = ~legendcolors(LEGEND),
                     popup = ~paste0("<b>","Name:","</b>", " ", NAME,
                                   "<br/>", "<b>", "City", ",", " ", "State:", "</b>", " ", CITY, ",", " ", STATE,
                                   "<br/>", "<b>","Total Undergraduate Enrollment:", "</b>", " ", UGTENR17,
                                   "<br/>", "<b>", "Total Dorming Capacity (Rooms):", "</b>", " ", ROOMS,
                                   "<br/>", "<b>", "Percentage of Available UG Housing:", "</b>", " ", HOUSING_PCT, "%")
        )
    })
    
    output$table <- renderDataTable({
      if (input$available != "All") {
        college <- college[college$LEGEND == input$available, ]
        as.data.frame(college[ ,c(1:3,8)])
      } else {as.data.frame(college[ ,c(1:3,8)])
      }},
      options = 
        list(searching = TRUE, 
             language = 
               list(
               zeroRecords = 
               "<li> Please type the FULL NAME
               of the college, city, or state you want for more accurate results.
               </br>
               (EX: Search University of California - Los Angeles, not UCLA | Philadelphia, not Philly)</li>
               <li>If you want to search for a particular school, select the 'All' choice
               above to better find your school. 
               </br>
               (i.e.: Harvard University has 100% housing availability, so you
               will NOT be able to search for Harvard if you selected '26%-50%'.)</li>
               </li>")
        )
             )
}

# Run the application 
shinyApp(ui = ui, server = server)
