library(shiny)
library(DT)
library(shinydashboard)

# Define UI for application that plots random distributions 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tamallow Card Table"),
  
  # Sidebar with a slider input for number of observations
  sidebarLayout(
    sidebarPanel(
    fileInput("file1", "Choose CSV File",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")
    ),
    tags$hr(),
    checkboxInput("header", "Header", TRUE)
  ),
    
    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(DT::dataTableOutput("cattledata")),
      fluidRow(DT::dataTableOutput("selectheader"))
    )
  )
))
