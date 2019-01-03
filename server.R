library(shiny)


# Layout for table of cards
shinyServer(function(input, output) {
  

  output$cattledata <- DT::renderDT({
    
    # generate an rnorm distribution and plot it
  inFile <- input$file1
  
  if (is.null(inFile))
    return(NULL)
  
  DT::datatable(read.csv(inFile$datapath, header = input$header), colnames=c("List"=2))
    })
  
  output$selectheader <- DT::renderDT({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    jag <- read.csv(inFile$datapath, header = input$header)
    jag <- jag[1,]
    
    DT::datatable(jag)
    
    
  })
  
})

