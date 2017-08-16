library(shiny)
library(sRa)
library(air)
library(tidyverse)

shinyUI(fluidPage(theme = "www/paper_modified.css",
  titlePanel("Enrollment Explorer"),
  sidebarLayout(fluid = TRUE,
    sidebarPanel(
                 helpText("Choose a measure, institution, and variable to visualize using XMR style charts."),
                 selectInput("measure", "\n Measure", 
                             choices = c(
                               "Unique Headcount" = 
                                 "Unique Student Static", 
                               "FLE")),
                 selectInput("inst", "Institution", 
                             choices = c("Medicine Hat College" = "MH", 
                                         "Mount Royal University" = "MU", 
                                         "University of Alberta" = "UA", 
                                         "Lethbridge College" = "LC", 
                                         "University of Lethbridge" = "UL")),
                 selectInput("var", "Variable", 
                             choices = c(
                               "Gender", 
                              "Legal Status", 
                              "Aboriginal Indicator",
                              "Year Of Study", 
                              "Program Band",
                              "Program Name",
                              "Age Group",
                              "Level Of Study", 
                              "Session", 
                              "Current Status", 
                              "Source Country",
                              "Province", "Provider Location")),
                 checkboxInput("offshores", "Remove offshores", value = T),
                 checkboxInput("cs", "Remove continuing studies", value = T),
                 submitButton("Update View", icon("refresh")),
                 helpText("Data saved does not contain XMR calculations."),
                 downloadButton('downloadData', 'Save Data', 
                                style ="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                 #downloadButton('downloadPlot', 'Download Plot'),
    width = 2),
  
    mainPanel(
       plotOutput("xmr", width = "auto")
    )
  )
))
