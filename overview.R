library(dplyr)
library(ggplot2)
library(plotly)
library(ggmap)
library(sf)
library(tidyverse)
library(readr)
library(showtext)
library(viridis)
library(tidyverse)
library(gt)
library(extrafont)
library(DT)
library(scales)
library(grDevices)
library(RColorBrewer)
library(tools)
library(stringr)
library(viridis)

mortality <- read_csv("data/HIV deaths.csv")
overview <- read_csv("data/HIV diagnoses.csv")
m_1 <- read_csv("data/m_1.csv")
m_2 <- read_csv("data/m_2.csv")
m_3 <- read_csv("data/m_3.csv")
f_1 <- read_csv("data/f_1.csv")
f_2 <- read_csv("data/f_2.csv")

HIV_full <- rbind(cbind(m_1, Gender = "Male"),
                  cbind(m_2, Gender = "Male"),
                  cbind(m_3, Gender = "Male"),
                  cbind(f_1, Gender = "Female"),
                  cbind(f_2, Gender = "Female"))
HIV_full$Cases <- as.numeric(HIV_full$Cases)
HIV_full$Year <- ifelse(HIV_full$Year == "2020 (COVID-19 Pandemic)", "2020", HIV_full$Year)
HIV_full$Year <- as.integer(HIV_full$Year)
HIV_full <- na.omit(HIV_full)
HIV_full$Geography <- gsub("\\^$", "", HIV_full$Geography)
HIV_full <- subset(HIV_full, select = -c(`Rate per 100000`))
HIV_full <- HIV_full %>% select(1:4, Gender, 5:ncol(HIV_full))
HIV_full

overview$Geography <- tolower(overview$Geography)
mortality$Geography <-tolower(mortality$Geography)

# Get the geographic data for the United States at the state level
us_states <- map_data("state")

overview_map <- 
  full_join(us_states, overview, by = c("region" = "Geography")) %>%
  group_by(Year,region) %>%
  mutate(region = str_to_title(region)) %>%
  mutate(text_label = str_c(region, "\nCases: ",Cases,
                            "\nRate(per 100k): ", `Rate per 100000`))

mortality_map <-
  full_join(us_states, mortality, by = c("region" = "Geography")) %>%
  group_by(Year,region) %>%
  mutate(region = str_to_title(region)) %>%
  mutate(text_label = str_c(region, "\nCases: ",Cases,
                            "\nRate(per 100k): ", `Rate per 100000`))

overview_map$`Rate per 100000` <- as.numeric(overview_map$`Rate per 100000`)
mortality_map$`Rate per 100000` <- as.numeric(mortality_map$`Rate per 100000`)
# overview_map$Cases <- as.double(overview_map$Cases)
# mortality_map$Cases <- as.double(mortality_map$Cases)

showtext_auto()
font_add_google("Montserrat", family = "my_font")
font_add_google('Abril Fatface', family ='my_font_title')

# Plot the map
create_overview <- function(data, year) {
  my_colors <- brewer.pal(n = 9, name = "Blues")
  
  overview.plot <- 
    data %>%
    filter(Year == year) %>%
    ggplot(aes(x = long, y = lat, group = region, fill = log10(`Rate per 100000`))) +
    geom_polygon(color = "white", aes(text = text_label)) +
    coord_fixed(1.3) +
    theme_minimal() +
    theme(legend.position = 'none') +
    theme(title = element_text(hjust = 0.5)) +
    theme(text = element_text(family = "my_font")) +
    scale_fill_gradientn(colors = my_colors, na.value = "gray50", trans = "exp") +
    xlab("Longitude") + ylab("Latitude")
  
  ggplotly(overview.plot, tooltip = "text") %>%
    layout(colorway = my_colors)
}


create_overview(overview_map,2008)
create_overview(overview_map,2018)


overview_barplot <- function(data, year) {
  overview.bar <- data %>%
    filter(Year == year) %>%
    select(region, `Rate per 100000`) %>%
    unique() %>%
    mutate(region = str_to_title(region), # Capitalize the region column
           text_label = str_c("State: ", region,
                              "\nRate per 100k: ", `Rate per 100000`
           )) %>%
    mutate(region = as.factor(region)) %>% # Convert region column to factor variable
    ggplot(aes(x = reorder(region, desc(`Rate per 100000`)),
               y = `Rate per 100000`,
               fill = log10(`Rate per 100000`), text = text_label)) +
    geom_bar(stat = "identity") + 
    xlab("State") + 
    theme_minimal() +
    theme(legend.position = 'none') +
    theme(axis.text.x = element_text(angle = 45)) + 
    theme(text = element_text(family = "my_font")) +
    scale_fill_gradient(low = "lightblue1", high = "steelblue4") # Use gradient color scale
  ggplotly(overview.bar, tooltip = "text")
}



overview_barplot(overview_map,2008)
overview_barplot(overview_map,2018)

overview_table <- function(data, year) {
  data %>%
    filter(Year == year) %>%
    select(region, `Rate per 100000`) %>%
    mutate(region = str_to_title(region)) %>%
    unique() %>%
    arrange(desc(`Rate per 100000`)) %>%
    rename(Region = region)
}
overview_table(overview_map,2018)

geom_polygon()


overview_title <- function(data,year){
  text <- ifelse(data=="Morbidity",
                 "morbidity", "mortality")
  out <- paste("US HIV Map in",as.character(year),"\n(by" , text, ")")
  text_df <- data.frame(x = 0.5, y = 0.5, label = out)
  
  ggplot(text_df, aes(x=x,y=y,label = label)) +
    geom_text(size = 20, family = 'my_font_title') +
    theme_void()
}

overview_title(overview_map,2018)

overview_lineplot <- function(data) {
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV deaths", "AIDS deaths")) %>%
    group_by(Year, Indicator) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE))
  p <- ggplot(filtered_data, aes(x = Year, y = Cases, color = Indicator, group = Indicator)) +
    geom_line() +
    labs(title = "Total Cases of HIV Deaths, and AIDS Deaths",
         x = "Year",
         y = "Total Cases") +
    scale_x_continuous(breaks = seq(2008, 2020, 1))
  
  # Convert ggplot to plotly
  ggplotly(p)
}


overview_scatterplot <- function(data,year_min,year_max) {
  n_year <- year_max - year_min + 1
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV prevalence", "AIDS prevalence")) %>%
    group_by(`Transmission Category`, `Age Group`,Indicator) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE))
  filtered_data$Cases <- round(filtered_data$Cases/n_year)
  
  new_filtered_data <- filtered_data %>%
    group_by(`Transmission Category`, `Age Group`, Indicator) %>%
    summarise(Cases = sum(Cases)) %>%
    pivot_wider(names_from = Indicator, values_from = Cases) %>%
    rename(`AIDS Prevalence Cases` = `AIDS prevalence`, `HIV Prevalence Cases` = `HIV prevalence`)
  
  # show the new DataFrame
  print(new_filtered_data)
  p <- ggplot(new_filtered_data, aes(x = `HIV Prevalence Cases`, y = `AIDS Prevalence Cases`, 
                                     color = `Transmission Category`, shape=`Age Group`)) +
    geom_point(size = 5) +
    labs(title = "HIV and AIDS Prevalence by Transmission Category and Age Group",
         x = "Cases of HIV prevalence",
         y = "Cases of AIDS prevalence",
         color = "Transmission Category",
         shape = "Age Group") +
    theme_bw() #+guides(color = FALSE, shape = FALSE)
  ggplotly(p)
}



overview_pie1 <- function(data) {
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV diagnoses")) %>%
    group_by(Gender) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE)) %>%
    mutate(Percent = Cases / sum(Cases) * 100)
  color_palette <- brewer.pal(n = 7, name =  "Blues")

  plot_ly(filtered_data, values = ~Cases, labels = ~ Gender, type = "pie",
          textinfo = "percent",hole=0.6, marker = list(colors = color_palette)) %>%
    layout(title = "HIV Diagnoses by Gender",
           showlegend = FALSE,
           plot_bgcolor = "#f6f6f6",
           paper_bgcolor = "#f6f6f6")
}

overview_pie2 <- function(data) {
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV diagnoses")) %>%
    group_by(`Age Group`) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE)) %>%
    mutate(Percent = Cases / sum(Cases) * 100)
  color_palette <- brewer.pal(n = 7, name =  "Blues")
  plot_ly(filtered_data, values = ~Cases, labels = ~ `Age Group`, type = "pie",
          textinfo = "percent",hole=0.6, marker = list(colors = color_palette)) %>%
    layout(title = "HIV Diagnoses by Age Group",
           showlegend = FALSE,
           plot_bgcolor = "#f6f6f6",
           paper_bgcolor = "#f6f6f6")
}

overview_pie3 <- function(data) {
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV diagnoses")) %>%
    group_by(`Race/Ethnicity`) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE)) %>%
    mutate(Percent = Cases / sum(Cases) * 100)
  color_palette <- brewer.pal(n = 7, name =  "Blues")
  plot_ly(filtered_data, values = ~Cases, labels = ~ `Race/Ethnicity`, type = "pie",
          textinfo = "percent",hole=0.6, marker = list(colors = color_palette)) %>%
    layout(title = "HIV Diagnoses by Race/Ethnicity",
           showlegend = FALSE,
           plot_bgcolor = "#f6f6f6",
           paper_bgcolor = "#f6f6f6")
}

overview_pie4 <- function(data) {
  filtered_data <- 
    data %>% 
    filter(Indicator %in% c("HIV diagnoses")) %>%
    group_by(`Transmission Category`) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE)) %>%
    mutate(Percent = Cases / sum(Cases) * 100)
  color_palette <- brewer.pal(n = 7, name =  "Blues")
  
  plot_ly(filtered_data, values = ~Cases, labels = ~ `Transmission Category`, type = "pie",
          textinfo = "percent",hole=0.6, marker = list(colors = color_palette)) %>%
    layout(title = list(text = "HIV Diagnoses by Transmission Category", font = list(size = 12)),
           showlegend = FALSE,
           plot_bgcolor = "#f6f6f6",
           paper_bgcolor = "#f6f6f6")
}

overview_pie4(HIV_full)
