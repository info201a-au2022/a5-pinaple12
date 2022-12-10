library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
library(thematic)
library(plotly)

#load data into variable
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


server <- function(input, output) {
  
  #imports theme to server outputs
  thematic_shiny()
  
  #renders overview paragraph with 3 metrics
  output$p1 <- renderText({
    
    #variable with unit measurement
    metric_end <- " tonnes per person"
    
    #part one text
    p1 <- "CO2 emissions are one of the greatest threats we face today. Throughout the last 10 years
    (from 2011 to 2021) the US has cut from"
    
    #2011 US CO2 per capita data
    percap_data11 <- co2_data %>%
      filter(
        country == "United States",
        year == 2011
      ) %>%
      pull(co2_per_capita) 
    
    #2021 US CO2 per capita data
    percap_data21 <- co2_data %>%
      filter(
        country == "United States",
        year == 2021
      ) %>%
      pull(co2_per_capita) 
    
    #Difference between 2021 and 2011 per capita rates as absolute value
    growth <- abs(percap_data21 - percap_data11)
    
    #Part two text
    p2 <- "With temperatures rising rapidly 
    despite countries around the world pledging to limit emissions, we must each ask ourselves what we can do
    ourselves to lower our carbon footprint in solving this issue. As far as CO2 emissions per capita go,
    despite the cuts in emission the US sports a hefty " 
    
    #current CO2 per Capita 
    states_data <- co2_data %>%
      filter(
        country == "United States",
        year == 2021
      ) %>%
      pull(co2_per_capita)
    
    #Part 3 text
    p3 <- "Compare this to the global average, which is "
    
    #World average CO2 emissions per capita
    world_data <- co2_data %>%
      filter(
        year == 2021
      ) %>%
      group_by(year) %>%
      summarise(
        per_cap_average = mean(co2_per_capita, na.rm = TRUE)
      ) %>%
      pull(round(per_cap_average, 2))
    
    #Rounds world average to nearest thousandth
    world_data <- round(world_data * 10000) / 10000
    
    #Part 4 text
    p4 <- " , and it is clear that the United States still has a lot of work to do."
    
    #Pastes paragraph together
    paste0(p1, percap_data11, metric_end, " to ", percap_data21, metric_end, " for a total difference of ", growth, metric_end, " decrease in emissions per capita. ",
           p2, states_data, metric_end, ". ",
           p3, world_data, metric_end, p4)
  
  })
  
  #Renders interactive emissions per capita scatterplot 
  output$scatterplot <- renderPlotly({
    
    #User input with underscores instead of spaces as a variable
    user_input <- gsub(" ", "_", input$metric)
    
    #Dataframe with matching column names and user choice options
    new_names <- data.frame(
      "variables" = c("co2_per_capita", "consumption_co2_per_gdp", "cement_co2_per_capita", "flaring_co2_per_capita",
                         "gas_co2_per_capita", "oil_co2_per_capita", "ghg_per_capita", "methane_per_capita",
                         "nitrous_oxide_per_capita", "other_co2_per_capita"),
      "names" = c("CO2 Per Capita", "CO2 Per Capita from Consumption", "CO2 Per Capita from Cement", "CO2 Per Capita from Flaring",
                     "CO2 Per Capita from Gas", "CO2 Per Capita from Oil", "Greenhouse Emissions Per Capita", "Methane per Capita",
                     "Nitrous Oxide per Capita", "CO2 Per Capita from Other Sources")
    )
    
    #Removes spaces from user choice options and replaces them with underscores
    new_names$names <- gsub(" ", "_", new_names$names)
    
    #Filters data to consider only United States data, as well as years indicated by user input
    scatter_data <- co2_data %>%
      rename_at(vars(new_names$variables), ~ new_names$names) %>%
      filter(
        country == "United States",
        year > input$early_date,
        year < input$late_date
      )
    
    #Creates a line/scatter plot based on selected emission variable within selected year range
    scatterplot <- ggplot(scatter_data, aes(x = year, y = !! sym(user_input))) + 
      geom_line() + 
      geom_point() +
      xlab("Year") + 
      ylab(paste(input$metric, "(Tons)")) +
      ggtitle("United States CO2 Emissions per Capita Across The Years") 
    
    #Makes plot interactive with plotly package
    scatterplotly <- ggplotly(scatterplot)
    
    scatterplotly
    
  })
  
  #Filters data to consider only United States data, as well as years indicated by user input
  output$populationplot <- renderPlotly({
    plot_data <- co2_data %>%
      filter(
        country == "United States",
        year >input$early_date,
        year < input$late_date
      )
    
    #Creates a line/scatter plot of US population within selected year range
    populationplot <-ggplot(scatter_data, aes(x = year, y = population)) + 
      geom_line() + 
      geom_point() +
      xlab("Year") +
      ylab("US Population") +
      ggtitle("United States Population Across The Years")
    
    #Makes plot interactive with plotly package
    populationplotly <- ggplotly(populationplot)
    
    populationplotly
  })
  
  #Renders home image
  output$intro_pic <- renderImage({
    list(src = "www/intro.jpg", width = 500, height = 370)
  }, deleteFile = F)
}

