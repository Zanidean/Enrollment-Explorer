library(shiny)
library(sRa)
library(air)
library(ggrepel)

shinyUI(fluidPage(
  
  titlePanel("Enrolment Explorer"),
  tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, 
                  .js-irs-0 .irs-bar {background: #7ECBB5}")),
  sidebarLayout(
    sidebarPanel(style = "max-height: 900px; position:relative;",
                 selectInput("measure", "Measure", 
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
                              "Province")),
                 checkboxInput("offshores", "Remove offshores", value = T),
                 checkboxInput("cs", "Remove continuing studies", value = T),
                 sliderInput("size", "Height of Charts",
                             min = 300, max =3000, value = 850),
                 downloadButton('downloadData', 'Download Data'),
    width = 2),
  
    mainPanel(
       plotOutput("xmr", width = "auto")
    )
  )
))
