library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(bslib)
library(plotly)

source("server.R")
source("ui.R")

shinyApp(ui = ui, server = server)