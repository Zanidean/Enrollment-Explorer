library(shiny)
library(sRa)
library(air)

shinyUI(fluidPage(theme = "www/paper_modified.css",
  titlePanel("Enrolment Explorer"),
  tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, 
                  .js-irs-0 .irs-bar {background: #7ECBB5}")),
  sidebarLayout(fluid = TRUE,
    sidebarPanel(style = "max-height: 800px; position:relative;",
                 helpText("Choose a measure, institution, and variable to visualize using XMR style charts."),
                 selectInput("measure", "\n Measure", 
                             choices = c("Unique Student Static", "FLE")),
                 selectInput("inst", "Institution", 
                             choices = c("Medicine Hat College" = "MH", 
                                         "Mount Royal University" = "MU", 
                                         "University of Alberta" = "UA", 
                                         "Lethbridge College" = "LC", 
                                         "University of Lethbridge" = "UL")),
                 selectInput("var", "Variable", 
                             choices = c("Gender", 
                              "Legal Status", 
                              "Aboriginal Indicator",
                              "Year Of Study", 
                              "Program Band", 
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
                 downloadButton('downloadData', 'Save Data'),
    width = 2),
  
    mainPanel(
       plotOutput("xmr", width = "auto")
    )
  )
))
