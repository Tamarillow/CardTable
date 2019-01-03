

# Load libraries - need to make sure these packages are loaded via --------

library(shiny)
library(shinydashboard)
library(dplyr)
library(shinyWidgets)





# ShinyServer -------------------------------------------------------------

Shinyserver <- function(input, output, session) {
  
  
  
  
  
  
  
  #session$onSessionEnded(stopApp)
  
  
  
  
  # Output sidebarpanel detail to UI  -------------------------------------------
  
  output$sidebarpanel <- renderUI({
    
    
    
  })
  
  
  # Output body detail to UI  -------------------------------------------    
  output$body <- renderUI({
    
    
    
    div(width=12,
        
        # Info Box output --------------------------------------------------------------
        
        tags$head(
          tags$style(HTML("hr {border-top: 2px solid #FCAF17;}"))
        ),
        fluidRow(
          column(12,div(style = "height:25px;background-color: rgb(248,248,248);")
          )),
        fluidRow(box (title = h2("Player 1"), solidHeader = TRUE, status="warning", height = 400, width=6),
                 box (title = h2("Player 2"), solidHeader = TRUE, status="warning", height = 400, width=6)),
        fluidRow(box (title = h2("Player 3"), solidHeader = TRUE, status="warning", height = 400, width=6),
                 box (title = h2("Player 4"), solidHeader = TRUE, status="warning", height = 400, width=6))
        
    )
  })
  
  
  
  
  
  
  

    
  }
