library(shiny)
library(shinyjs)
library(raster)
library(OpenStreetMap)
#library(ggplot2)
library(leaflet)
library(osmdata)
library(rgdal)
library(sf)
library(xlsx)
library(dplyr)
library(plotrix)
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  useShinyjs(),
  # App title ----
  titlePanel("Imiona dzieci w Polsce w latach 2000-2018"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(NULL,
  
    
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        tabPanel("Wyszukiwanie imion",
                 fluidRow(
                   useShinyjs(),
                   column(8,textInput("imie","Wpisz imie",value = "ANDRZEJ")),
                   column(9,actionButton("go", "PLOT")),
                   column(3,selectInput( inputId = "wyborWoj", label = "Wybierz Woj:", choices = list("Polska" = 1, "Dolnoslakie" = 2, "Kujawsko-pomorskie" = 3, "Lubelskie" = 4, "Lubuskie" = 5, "Lodzkie" = 6, "Malopolskie" = 7, "Mazowieckie" = 8, "Opolskie" = 9, "Podkarpackie" = 10, "Podlaskie" = 11, "Pomorskie" = 12, "Slaskie" = 13, "Swietokrzyskie" = 14, "Warminsko-mazurskie" = 15, "Wielkopolskie" = 16, "Zachodniopomorskie" = 17) , selected = 1, multiple = FALSE, selectize = FALSE)),
                   column(12,plotOutput(outputId = "distPlot")))),
       tabPanel("Top 10",
                 fluidRow(
                   column(4,tableOutput(outputId = "Top10M")),
                   column(5,tableOutput(outputId = "Top10K")),
                   column(3,selectInput(inputId = "wyborRoku", label = "Wybierz rok:", choices = list("2000" = 2000, "2001" = 2001, "2002" = 2002, "2003" = 2003, "2004" = 2004, "2005" = 2005, "2006" = 2006, "2007" = 2007, "2008" = 2008, "2009" = 2009, "2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018), , selected = 2000, multiple = FALSE, selectize = FALSE)),
                   column(3,selectInput( inputId = "wyborW", label = "Wybierz Woj:", choices = list("Polska" = 1, "Dolnoslakie" = 2, "Kujawsko-pomorskie" = 3, "Lubelskie" = 4, "Lubuskie" = 5, "Lodzkie" = 6, "Malopolskie" = 7, "Mazowieckie" = 8, "Opolskie" = 9, "Podkarpackie" = 10, "Podlaskie" = 11, "Pomorskie" = 12, "Slaskie" = 13, "Swietokrzyskie" = 14, "Warminsko-mazurskie" = 15, "Wielkopolskie" = 16, "Zachodniopomorskie" = 17) , selected = 1, multiple = FALSE, selectize = FALSE)),
                   plotOutput(outputId= "pie", width =750, height = 750 ),
                   )),
       tabPanel("Trendy",
                fluidRow(
                  column(3,textInput("imieT","Wpisz imie",value = "ANDRZEJ")),
                  column(12, plotOutput(outputId = "trend")),
                  column(3,textOutput(outputId="trendtxt")),
                )
       ),
       tabPanel("Mapa",
                fluidRow(
                  column(3,textInput("imieM","Wpisz imie",value = "ANDRZEJ")),
                  column(3,selectInput(inputId = "wyborM", label = "Wybierz rok:", choices = list("2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017), , selected = NULL, multiple = FALSE, selectize = FALSE)),
                  column(9,actionButton("goM", "MAPA")),
                  column(12,leafletOutput(outputId = "mapapolski", width = 750, height = 750))
                ))
      ),
      textOutput("text")
      # Output: Histogram ----
     # plotOutput(outputId = "distPlot"),
      
      
      
    )
  )
)