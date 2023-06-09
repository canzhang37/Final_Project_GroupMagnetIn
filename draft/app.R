#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("overview.R")
year_var <- unique(overview_map$Year)

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage(
  title = "US HIV Visualization",
  tabPanel("Overview",
           selectInput("year",
                       "Year",
                       choices = year_var),
           mainPanel(
             plotlyOutput("OverviewPlot")
             )
           ),
  tabPanel("Trend",
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
               plotlyOutput("distPlot")
             )
           )
           ),
  tabPanel("About")
  )
  

)


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$OverviewPlot <- renderPlotly({
    # generate bins based on input$bins from ui.R
    create_overview(input$year,overview_map)
  })
    

}

# Run the application 
shinyApp(ui = ui, server = server)
