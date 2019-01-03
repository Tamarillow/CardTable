

# Load libraries - need to make sure these packages are loaded via --------

library(shiny)
library(shinydashboard)
library(leaflet)
library(geojsonio)
library(mongolite)
library(ggplot2)
library(plotly)
library(rgeos)
library(DT)
library(GISTools)
library(dplyr)
library(shinyWidgets)
library(dygraphs)
library(xts)
library(shinyalert)
library(sp)
library(data.table)


PropPadds <<- geojsonio::geojson_read("~/Documents/RStudio/MarkMapping/paddocks/BelPadds.geojson", what = "sp")

blip <- data.frame()

catnums <- c(3442,
             3399,
             3845,
             3784,
             3344,
             3859,
             3348,
             3067,
             3667,
             3224,
             3179,
             3473,
             3139,
             3495,
             3588,
             3152,
             3444,
             3781,
             3024,
             3502,
             2943,
             3243)



#info = file.info(filenames)

setwd("~/Desktop/TaggleLoc/")
finf <- file.info(dir())
finf <- finf[which(finf$size>50),]
finf <- finf[which(difftime(Sys.time(), finf$mtime, units="days")<2),]
chips <- rownames(finf)
temp <- lapply(paste0("~/Desktop/TaggleLoc/",chips), fread, sep=",")
MT <- rbindlist(temp)
MT$V2 <- as.numeric(MT$V2)
MT$V5 <- as.POSIXct(MT$V1,format="%d %B %Y %I:%M:%S")
MT <- MT[which(MT$V2%in%catnums),]
coords <- cbind(MT$V3,MT$V4)
MTCattle <- SpatialPointsDataFrame(coords, MT)

# ShinyServer -------------------------------------------------------------

Shinyserver <- function(input, output, session) {
  
  
  
  
  
  
  
  #session$onSessionEnded(stopApp)
  
  
  
  
  # Output sidebarpanel detail to UI  -------------------------------------------
  
  output$sidebarpanel <- renderUI({
    
    div( width =400,
         
         fluidRow(box(width=12, solidHeader = TRUE, align = "center", height=80, tags$a(href='https://www.datamuster.net.au/',tags$img(src="DM1.png", height = 65, width = 200)))),
         
         fluidRow(box(width=12, height=110, status="success", (prettyRadioButtons("mapchoice", label="Map View Options:",
                                                                                  choices = list("Base Map" = 1, "Satellite" = 2), selected = 1, inline=TRUE, outline= TRUE, animation = "pulse", status="danger")),
                      prettyCheckbox(
                        inputId = "displayboxes", label = "Display Cattle Info Box", shape = "round", status = "danger", outline = TRUE, value=FALSE, animation="pulse"
                      ))),
         #checkboxInput("displayboxes", "Display Map Info:", value=TRUE),
         
         fluidRow(box(width=12, height = 110,solidHeader = TRUE, prettyRadioButtons("zoomchoice", label = "Paddock Groups:",
                                                                                    choices = list("Whole Property (no selection)" = 3, "Paddock" = 2, "Sentinel Cattle"=1),selected = 3, outline= TRUE, animation = "pulse", status="danger"))),
         
         fluidRow(box(width=12, height = 110, status="success", prettyRadioButtons("malefemale", label = "Males or Females:",
                                                                                   choices = list("All Cattle (no selection)" = "all", "Males" = "male", "Females" = "female"),selected = "all", outline= TRUE, animation = "pulse", status="danger"))),
         
         fluidRow(box(width=12, height = 110, solidHeader=TRUE, prettyRadioButtons("breedersgrowers", label = "Breeders or Growers:",
                                                                                   choices = list("All Cattle (no selection)"= "all", "Breeders" = "breeding", "Growers" = "growing"),selected = "all", outline= TRUE, animation = "pulse", status="danger"))),
         fluidRow(box(width=12, height= 110, status="success", (prettyRadioButtons("radio", label = "Weight Range",
                                                                                   choices = list("All Cattle (no selection)"= 1, "Weight Range" = 2), 
                                                                                   selected = 1, outline= TRUE, animation = "pulse", status="danger")),
                      tags$style(HTML(".js-irs-0 .irs-from, .irs-to {font-family: 'arial'; color:#414042; background:white; font-size:12px} .js-irs-0 .irs-min, .irs-max {font-family: 'arial'; color: #414042; background:white; font-size:12px} .js-irs-0 .irs-slider {width: 18px; height: 18px; top: 20px; background: #F15A29} .js-irs-0 .irs-bar {background: #F15A29}")), 
                      sliderInput("rangewt", "ALMS live weight range (kg):",
                                  min = 50, max = 1000, value = c(450,650))))
    ) 
    
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
        fluidRow(width=12,
                 
                 box (title = h2("Belmont GPS Tracking Overview"), solidHeader = TRUE, status="warning", height = 850, width=12,
                      
                      leafletOutput("Map", height=750)
                      
                      
                      
                 ))
        
    )
  })
  
  
  
  
  
  
  
  # Output Base Map Plus General Map Controls e.g. satelite and select paddocks ----------------------------------------     
  
  output$Map <- renderLeaflet({ leaflet(Map) %>%
      fitBounds(PropPadds@bbox[1,1],PropPadds@bbox[2,1],PropPadds@bbox[1,2],PropPadds@bbox[2,2])%>%
      clearMarkers()%>%
      addPolygons(data=PropPadds, layerId=PropPadds@data$name,
                  fillOpacity = 0.6, fillColor= ifelse(input$mapchoice==2,"white","white"), popup=paste0(PropPadds$name, " is ", round(PropPadds$hectares,digits=2), " Ha"), stroke=TRUE, color="#6D6E71",
                  highlightOptions = highlightOptions(color = "#BE1E2D", weight = 3,
                                                      bringToFront = FALSE))%>%
      addMarkers(data=MTCattle, popup = paste0(MT$V1," ",MT$V2))
    
  })
  
  
  observeEvent(input$mapchoice,{
    satel <- input$mapchoice
    leafletProxy("Map")%>%
      #clearTiles()%>%
      addProviderTiles(ifelse(satel==1,"OpenStreetMap.Mapnik","Esri.WorldImagery"))
    
  })
  
  
  
}
