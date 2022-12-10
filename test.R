library(dplyr)
library(ggplot2)
library(shiny)
library(tidyverse)

co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

states_data <- co2_data %>%
  filter(
    country == "United States")

world_data <- co2_data %>%
  filter(
    year == 2021
  ) %>%
  group_by(year) %>%
  summarise(
    per_cap_average = mean(co2_per_capita, na.rm = TRUE)
  )

percap_data11 <- co2_data %>%
  filter(
    country == "United States",
    year == 2011
    ) %>%
  pull(co2_per_capita) 


world_data <- co2_data %>%
  filter(
    year == 2021
  ) %>%
  group_by(year) %>%
  summarise(
    per_cap_average = mean(co2_per_capita, na.rm = TRUE)
  ) %>%
  pull(per_cap_average)

########test 
user_input <- "population"

x_variable <- rlang::sym(user_input)


new_names <- data.frame(
  "variables" = c("co2_per_capita", "consumption_co2_per_gdp", "cement_co2_per_capita", "flaring_co2_per_capita",
                  "gas_co2_per_capita", "oil_co2_per_capita", "ghg_per_capita", "methane_per_capita",
                  "nitrous_oxide_per_capita", "other_co2_per_capita"),
  "names" = c("CO2 Per Capita", "CO2 Per Capita from Consumption", "CO2 Per Capita from Cement", "CO2 Per Capita from Flaring",
              "CO2 Per Capita from Gas", "CO2 Per Capita from Oil", "Greenhouse Emissions Per Capita", "Methane per Capita",
              "Nitrous Oxide per Capita", "CO2 Per Capita from Other Sources")
)

new_names$names <- gsub(" ", "_", new_names$names)

scatter_data <- co2_data %>%
  rename_at(vars(new_names$variables), ~ new_names$names) %>%
  filter(
    country == "United States",
    year > 2000,
    year < 2020
  )
 ggplot(data = scatter_data, aes(x = year, y = !! sym(user_input))) + 
  geom_point()

scatterplotly <- ggplotly(scatterplot)

scatterplotly
