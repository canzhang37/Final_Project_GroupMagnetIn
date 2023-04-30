Sys.setlocale("LC_ALL", "en_US.UTF-8")
library(shiny)
source("overview.R")
year_var <- unique(overview_map$Year)
select_var <- c("Morbidity", "Mortality")

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage(
    title = "AIDInsight: US HIV Data Explorer",
    tabPanel(
      "Overview",
      fluidRow(
        column(
          width = 4,
          wellPanel(
            selectInput(
              "year",
              "Year",
              choices = year_var,
              width = "100%"
            ),
            selectInput(
              "dataset",
              "By",
              choices = select_var,
              width = "100%"
            )
          )
        ),
        column(
          width = 8,
          wellPanel(
            plotOutput("OverviewTitle", height = "200px")
          )
        )
      ),
      fluidRow(
        column(
          width = 12,
          wellPanel(
            plotlyOutput("OverviewPlot", width = "100%", height = "600px")
          )
          ,
          style = "width: 100%;"
        )
      ),
      fluidRow(
        column(
          width = 12,
          wellPanel(
            plotlyOutput("OverviewBar", width = "100%")
          )
          ,
          style = "width: 100%;"
        )
      ),
      fluidRow(
        column(
          width = 12,
          wellPanel(
            div(
              style = "width: 100%; overflow-x: auto;",
              DTOutput("OverviewTable")
            )
          )
          ,
          style = "width: 100%;"
        )
      )
    ),
    tabPanel(
      "Insight",
      fluidPage(
        fluidRow(
          column(4,
                 wellPanel(
                   selectInput("geography", "Geography:",
                               choices = c("ALL", unique(HIV_full$Geography))),
                   selectInput("agegroup", "Age Group:",
                               choices = c("ALL", unique(HIV_full$Age.Group))),
                   selectInput("gender", "Gender:",
                               choices = c("ALL", unique(HIV_full$Gender))),
                   selectInput("race", "Race:",
                               choices = c("ALL", unique(HIV_full$Race))),
                   sliderInput("year_range", "Select Year Range:",
                               min = min(HIV_full$Year), max = max(HIV_full$Year),
                               value = c(min(HIV_full$Year), max(HIV_full$Year)), step = 1)
                 )
          ),
          column(width=8,  wellPanel(plotlyOutput("linePlot"),height = "400px"))
        ),
        fluidRow(
          column(width=12,  wellPanel(plotlyOutput("scatterPlot"),width = "100%"))
        ),
        fluidRow(
          column(3, wellPanel(plotlyOutput("pie1"))),
          column(3, wellPanel(plotlyOutput("pie2"))),
          column(3, wellPanel(plotlyOutput("pie3"))),
          column(3, wellPanel(plotlyOutput("pie4")))
        )
      )
    )
    
    
,
    tabPanel(
      "Data",
      sidebarLayout(
        sidebarPanel(
          selectInput("indicator_d", "Indicator:", choices = c("ALL", unique(HIV_full$Indicator))),
          selectInput("year_d", "Year:", choices = c("ALL", unique(HIV_full$Year))),
          selectInput("geography_d", "Geography:", choices = c("ALL", unique(HIV_full$Geography))),
          selectInput("gender_d", "Gender:", choices = c("ALL", unique(HIV_full$Gender))),
          selectInput("race_ethnicity_d", "Race:", choices = c("ALL", unique(HIV_full$Race))),
          selectInput("age_group_d", "Age Group:", choices = c("ALL", unique(HIV_full$Age.Group))),
          selectInput("transmission_category_d", "Transmission Category:", choices = c("ALL", unique(HIV_full$Transmission.Category))),
          downloadButton("download_data", "Download Data")
      ),
      mainPanel(
      dataTableOutput('data')
      )
    )
    ),
    tabPanel(
      "About",
      includeMarkdown("README.md")
    )
  )
)



  


# Define server logic required to draw a histogram
server <- function(input, output) {
  source_overview <- reactive({
    if(input$dataset == "Morbidity"){
      data <- overview_map}
    if(input$dataset == "Mortality"){
      data <- mortality_map}
    return(data)
  })
    
  output$OverviewPlot <- renderPlotly({
    # generate bins based on input$bins from ui.R
    create_overview(source_overview(),input$year)
  })
  output$OverviewBar <- renderPlotly({
    overview_barplot(source_overview(),input$year)
  })  

  
  
  output$OverviewTable <- renderDT({
    median_val <- median(overview_table(source_overview(), input$year)$Rate.per.100000)
    scale <- max(abs(overview_table(source_overview(), input$year)$Rate.per.100000 - median_val))
    pal <- colorRampPalette(brewer.pal(3,  "Blues"))(100)
    colors <- pal[findInterval(overview_table(source_overview(), input$year)$Rate.per.100000, c(seq(median_val - scale, median_val, length.out = 50), seq(median_val, median_val + scale, length.out = 50)))]
    
    datatable(overview_table(source_overview(), input$year),
              options = list(pageLength = 10),
              rownames = FALSE) %>%
      formatStyle("Rate.per.100000",
                  backgroundColor = styleEqual(levels = overview_table(source_overview(), input$year)$Rate.per.100000,
                                               values = colors),
                  backgroundSize = "98% 88%",
                  backgroundRepeat = "no-repeat",
                  backgroundPosition = "center")
  })
  
  
  output$OverviewTitle <- renderPlot(
    overview_title(input$dataset, input$year)
    )
  
  
  
  # Trend
  
  filtered_data <- reactive({
    filtered <- HIV_full
    if (input$geography != "ALL") {
      filtered <- filtered %>% filter(Geography == input$geography)
    }
    if (input$gender != "ALL") {
      filtered <- filtered %>% filter(Gender == input$gender)
    }
    if (input$race != "ALL") {
      filtered <- filtered %>% filter(Race == input$race)
    }
    if (input$agegroup != "ALL") {
      filtered <- filtered %>% filter(Age.Group == input$agegroup)
    }
    filtered <- filtered %>% filter(Year >= input$year_range[1] & Year <= input$year_range[2])
    filtered
  })
  
  output$linePlot <- renderPlotly({
    overview_lineplot(filtered_data())
  })
  output$scatterPlot <- renderPlotly({
    overview_scatterplot(filtered_data(), input$year_range[1],input$year_range[2])
  })
  output$pie1 <- renderPlotly({
    overview_pie1(filtered_data())
  })
  output$pie2 <- renderPlotly({
    overview_pie2(filtered_data())
  })
  output$pie3 <- renderPlotly({
    overview_pie3(filtered_data())
  })
  output$pie4 <- renderPlotly({
    overview_pie4(filtered_data())
  })
  
  filtered_downloaddata <- reactive({
    filtered <- HIV_full
    if (input$indicator_d != "ALL") {
      filtered <- filtered %>% filter(Indicator == input$indicator_d)
    }
    if (input$year_d != "ALL") {
      filtered <- filtered %>% filter(Year == input$year_d)
    }
    if (input$geography_d != "ALL") {
      filtered <- filtered %>% filter(Geography == input$geography_d)
    }
    if (input$gender_d != "ALL") {
      filtered <- filtered %>% filter(Gender == input$gender_d)
    }
    if (input$race_ethnicity_d != "ALL") {
      filtered <- filtered %>% filter(Race == input$race_ethnicity_d)
    }
    if (input$age_group_d != "ALL") {
      filtered <- filtered %>% filter(Age.Group == input$age_group_d)
    }
    if (input$transmission_category_d != "ALL") {
      filtered <- filtered %>% filter(Transmission.Category == input$transmission_category_d)
    }
    filtered
  })
  
  output$download_data <- downloadHandler(
    filename = "HIV.csv",
    content = function(file) {
      write.csv(filtered_downloaddata(), file)
    })
  
  output$data <- renderDataTable(filtered_downloaddata(),
                                 options = list(
                                   pageLength = 10
                                 )
  )
  
}


# Run the application 
shinyApp(ui = ui, server = server)
