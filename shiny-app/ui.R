library(tidyverse)
library(shiny)
library(shinythemes)
library(sbo)
ngram_model <- load("../models/ngram_model.Rda")

# Define UI for app that draws a histogram ----
ui <- navbarPage(
  # App title ----
  "Next Word Prediction Tool",
  
  theme = shinytheme("flatly"),
  
  # Sidebar layout with input and output definitions ----
  tabPanel("Next Word",
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      textInput("text", h3("Text Input"), 
                value = "Enter text..."),
      actionButton(inputId = "Run", "Run")
      ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Next Word Predictions",
                           textOutput("words")),
                  tabPanel("Babble",
                           textOutput("babble"))),
      width = 8
    )),
  tabPanel("Documentation",
           mainPanel(
             h4("Purpose"),
             "This application provides visualizations and maps for Formula 1 races from 2010 to present. Formula 1 is an international auto racing championship involving (as of 2021) 20 drivers, 10 constructors, and races all over the world. More information about how to interpret figures from this application can be found", 
             a("here.", 
               href = "https://wiscodisco5.github.io/f1-race-app/#(1)"),
             h4("How to Use"),
             "Visualizations can be selected by:",
             tags$ol(
               tags$li("Selecting a race 'Year'"),
               tags$li("Selecting a 'Race' event name"),
               tags$li("Selecting a set of 'Drivers'")
             ),
             "Since the list of eligible races can vary by year and the list eligible drivers can vary by race and year, you may notice some of the options changing based on your selections. Every time a year is changed, the figures will reset to the first race of the year and the top 3 drivers from the first race. When a new race is selected within a particular year, the driver figures will reset to the top 3 drivers of that race.",
             h4("Sources"),
             "Historical race data comes thanks to",
             a("Rohan Rao's Kaggle project", 
               href = "https://www.kaggle.com/rohanrao/formula-1-world-championship-1950-2020"),
             "which gathers data from http://ergast.com/mrd/ into an easy to work with series of CSV's. Track maps and locations come from",
             a("Tomislav Bacinger's repository", 
               href = "https://github.com/bacinger/f1-circuits"),
             "containing GeoJSON data on most of the Formula 1 Circuits. Note that not all of the races from 2010 forward have maps available.",
             h4("Link to Source Code"),
             a("Source code for this project can be found here.", 
               href = "https://github.com/WiscoDisco5/f1-race-app"),
             width = 5 
           )
  )
  )

