library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Clinic Comparison Tool"),
    
    sidebarPanel(selectInput(inputId = "site",
                             label = "Select Clinics of Interest",
                             choices = c("Oak Bridge" = "ob",
                                         "Birchfield" = "bf",
                                         "East Jonestown" = "ej",
                                         "Robertsville" = "rv"),
                             selected = "ob",
                             multiple = TRUE),
                 selectInput(inputId = "measure",
                             label = "Select Measure of Interest",
                             choices = c("Body Mass Index" = "bmi",
                                         "Hemoglobin A1C" = "hgba1c"),
                             selected = "hgba1c",
                             multiple = FALSE)),
    
    mainPanel(plotOutput("historical_data_plot"))
))