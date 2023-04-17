
library(data.table)
library(dplyr)
setwd("C:/Users/Oemx/Desktop/2023SPRING/PUBH7462/Git/Final_Project_GroupMagnetIn/draft/dataset")

race_2_1_m <- read.csv("race_2_1.csv", skip = 11)
race_2_2_m <- read.csv("race_2_2.csv", skip = 11)
race_3_m <- read.csv("race_3.csv", skip = 11)
race_3_f <- read.csv("race_3_f.csv", skip = 11)
race_4_f <- read.csv("race_4_f.csv", skip = 11)

hiv_f <- bind_rows(race_3_f, race_4_f)
hiv_m <- bind_rows(race_2_1_m, race_2_2_m,race_3_m)
hiv_f <- hiv_f %>%
  mutate(Gender = "Female")
hiv_m <- hiv_m %>%
  mutate(Gender = "Male")
hiv <- bind_rows(hiv_f, hiv_m)
hiv
write.csv(hiv, "hiv.csv", row.names = TRUE)