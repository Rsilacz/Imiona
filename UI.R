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
ui <- fluidPage(theme = "united",
  useShinyjs(),
  # App title ----
  titlePanel("Imiona dzieci w Polsce w latach 2000-2018"),
  tags$head(
    tags$style(
      HTML("h2 {
                            color: #85a3c2;
                          }

                         body {
                            background-color: #F0F0F0;
                         }"),
      ("#trendtxt{color: #85a3c2;
                  font-size: 32px;
                  font-style: bold;
                  margin: auto;
                  text-align: center;}"),
      ("#pieChart{
        align: center;
        margin: auto;
      }")
    )
  ),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(NULL,
                
                
                
                
                # Main panel for displaying outputs ----
                mainPanel(width="100%", style="margin-left:50px; margin-right:50px;",
                  tabsetPanel(
                    tabPanel("Wyszukiwanie imion",
                             fluidRow(
                               useShinyjs(),
                               column(8,textInput("imie","Wpisz imię",value = "ANDRZEJ")),
                               column(9,actionButton("go", "PLOT")),
                               column(3,selectInput( inputId = "wyborWoj", label = "Wybierz Województwo:", choices = list("Polska" = 1, "Dolnośląskie" = 2, "Kujawsko-pomorskie" = 3, "Lubelskie" = 4, "Lubuskie" = 5, "Łódzkie" = 6, "Małopolskie" = 7, "Mazowieckie" = 8, "Opolskie" = 9, "Podkarpackie" = 10, "Podlaskie" = 11, "Pomorskie" = 12, "Śląskie" = 13, "Świętokrzyskie" = 14, "Warmińsko-mazurskie" = 15, "Wielkopolskie" = 16, "Zachodniopomorskie" = 17) , selected = 1, multiple = FALSE, selectize = FALSE)),
                               column(12,plotOutput(outputId = "distPlot")))),
                    tabPanel("Top 10",
                             fluidRow(
                               column(4,tableOutput(outputId = "Top10M")),
                               column(5,tableOutput(outputId = "Top10K")),
                               column(3,selectInput(inputId = "wyborRoku", label = "Wybierz rok:", choices = list("2000" = 2000, "2001" = 2001, "2002" = 2002, "2003" = 2003, "2004" = 2004, "2005" = 2005, "2006" = 2006, "2007" = 2007, "2008" = 2008, "2009" = 2009, "2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018), , selected = 2000, multiple = FALSE, selectize = FALSE)),
                               column(3,selectInput( inputId = "wyborW", label = "Wybierz Województwo:", choices = list("Polska" = "Polska", "Dolnośląskie" = "Dolnoslakie", "Kujawsko-pomorskie" = "Kujawsko-pomorskie"
                                                                                                                , "Lubelskie" ="Lubelskie", "Lubuskie" = "Lubuskie", "Łódzkie" = "Lodzkie", "Małopolskie" = "Malopolskie"
                                                                                                                , "Mazowieckie" = "Mazowieckie", "Opolskie" = "Opolskie", "Podkarpackie" = "Podkarpackie"
                                                                                                                , "Podlaskie" = "Podlaskie", "Pomorskie" = "Pomorskie", "Śląskie" = "Slaskie", "Świętokrzyskie" ="Swietokrzyskie", "Warmińsko-mazurskie" = "Warminsko-mazurskie"
                                                                                                                , "Wielkopolskie" = "Wielkopolskie", "Zachodniopomorskie" ="Zachodniopomorskie") , selected ="Dolnośląskie", multiple = FALSE, selectize = FALSE)),
                               column(12,plotOutput(outputId= "pieChart", width =450, height = 450 )),
                             )),
                    tabPanel("Trendy",
                             fluidRow(
                               column(3,textInput("imieT","Wpisz imię",value = "ANDRZEJ")),
                               column(12, plotOutput(outputId = "trend")),
                               column(12,textOutput(outputId="trendtxt")),
                             )
                    ),
                    tabPanel("Mapa",
                             fluidRow(
                               column(3,textInput("imieM","Wpisz imię",value = "ANDRZEJ")),
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