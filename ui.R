library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(bslib)
library(plotly)

#allows user to select relevant metric
metric_input <- selectInput(
  inputId = "metric",
  label = "Select a per capita metric",
  choices = list("CO2 Per Capita", "CO2 Per Capita from Consumption", "CO2 Per Capita from Cement", "CO2 Per Capita from Flaring",
                 "CO2 Per Capita from Gas", "CO2 Per Capita from Oil", "Greenhouse Emissions Per Capita", "Methane per Capita",
                 "Nitrous Oxide per Capita", "CO2 Per Capita from Other Sources"),
  selected = "CO2 Per Capita"
)

#allows user to input date range
early_year_input <- selectInput(
  inputId = "early_date",
  label = "Select first date for relevant date range",
  choices = seq(from = 1990, to = 2021, by = 1),
  selected = "2000"
)

#allows user to input date range
late_year_input <- selectInput(
  inputId = "late_date",
  label = "Select second date for relevant date range",
  choices = seq(from = 1990, to = 2021, by = 1),
  selected = "2015"
)


#introduction page with a photo and context information
introduction_page <- tabPanel(
  "Introduction",
  titlePanel("Greenhouse Emissions and You"),
  imageOutput("intro_pic"),
  h4("Overview"),
  textOutput("p1"),
  br(),
  h4("About"),
  p("Using data compiled by Our World in Data, this shiny application aims to help users see different carbon emission per capita metrics
    over a range of time. Hopefully, this can help users see how the different emission per capita
    metrics are related to each other and lead to people making more informed decisions in limiting
    their carbon footprint.")
)

#interactive page with two graphs and three widgets
interactive_page <- tabPanel(
  "Interactive",
  titlePanel("Emissions per Capita in the United States"),
  sidebarLayout(
    sidebarPanel(
      metric_input,
      p("This tool allows the user to select from a variety of emmission per capita metrics. It is important to note that the numbers graphed are measured per person, meaning that total emissions have to be calculated by per capita multiplied by population count."),
      early_year_input,
      late_year_input,
      p("This tool allows the user to select their time frame of interest. Data goes as far back as 1990, and the most current data available is from 2021.")
    ),
    mainPanel(
      plotlyOutput("scatterplot"),
      p("This plot shows a variety of specific United State emission per capita metrics from the years 1990 - 2021. Some interesting information we can see from different graphs, are that while certain per capita graphs decrease in similar fashion to overall CO2 emissions per capita over the years, the per capita graph for Gas is actually increasing. One takeaway from this, is for people to find more sustainable alternatives to driving to destinations."),
      plotlyOutput("populationplot"),
      p("This plot shows population data from the year 1990 through 2021. Users can use this data alongside the emissions per capita graph to calculate total emissions per year. Although population may seem like it is increasing faster than the per capita rate is decreasing, when multiplying population by per capita rate we can see that we are cutting emissions faster than the population is growing - recent years have shown a decrease in overall CO2 emissions despite population gains.")
    )
  )
)

#ui put together
ui <- navbarPage(
  theme = shinytheme(theme = "flatly"),
  setBackgroundColor(color = "beige"),
  introduction_page,
  interactive_page
)
