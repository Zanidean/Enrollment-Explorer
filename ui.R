library(shiny)
library(sRa)
library(air)
library(tidyverse)

shinyUI(fluidPage(theme = "www/paper_modified.css",
  titlePanel("Enrolment Explorer"),
  sidebarLayout(fluid = TRUE,
    sidebarPanel(
                 helpText("Choose a measure, institution, and variable to visualize using XMR style charts."),
                 selectInput("measure", "\n Measure", 
                             choices = c(
                               "Unique Headcount" = "Unique Student Static", 
                               "FLE", 
                               "Calculated Full-Time" = "Calculated Full-Time for Year",
                               "Calculated Part-Time" = "Calculated Part-Time for Year")),
                 selectInput("inst", "Institution", 
                             choices = c("Medicine Hat College" = "MH", 
                                         "Mount Royal University" = "MU", 
                                         "University of Alberta" = "UA", 
                                         "Lethbridge College" = "LC", 
                                         "University of Lethbridge" = "UL")),
                 selectInput("var", "Variable", 
                             choices = c("Gender", 
                              "Credential Type",
                              "Legal Status", 
                              "Aboriginal Indicator",
                              "Year Of Study", 
                              "Grade Completed Year",
                              "Registration Type",
                              "Provider",
                              "Provider Service Area",
                              "Service Area",
                              "Program Band",
                              "Program Name",
                              "Program Specialization",
                              "Program Length",
                              "Census Division",
                              "Registration Status",
                              "Age Group",
                              "Level Of Study", 
                              "Session", 
                              "Current Status", 
                              "Source Country",
                              "CIP Level 2",
                              "CIP Level 4", 
                              "CIP Level 6",
                              "Province", 
                              "Provider Location")),
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
