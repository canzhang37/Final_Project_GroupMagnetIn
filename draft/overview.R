library(dplyr)
library(ggplot2)
library(plotly)
library(ggmap)
library(sf)
library(tidyverse)
library(readr)

overview <- read_csv("HIV diagnoses.csv")
overview$Geography <- tolower(overview$Geography)
# Get the geographic data for the United States at the state level
us_states <- map_data("state")

overview_map <- 
  left_join(us_states, overview, by = c("region" = "Geography")) %>%
  group_by(Year,region) %>%
  mutate(text_label = str_c(region, "\nCases: ",Cases,
                            "\nRate(per 100k): ", `Rate per 100000`))


# Plot the map
create_overview <- function(year,data){
overview.plot <- 
  data %>%
  filter(Year==year) %>%
  ggplot( aes(x = long, y = lat, group = region, fill = `Rate per 100000`,)) +
  geom_polygon(color = "white",aes(text = text_label)) +
  # scale_fill_viridis_d(`Rate per 100000`) +
  # labs(fill = "Census Data") +
  coord_fixed(1.3) +
  theme_void() +
  theme(legend.position = 'none')
ggplotly(overview.plot,tooltip = "text")
}
create_overview(2018,overview_map)
