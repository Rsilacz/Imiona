library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Imiona dzieci w Polsce w latach 2000-2018"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(NULL,
    
    # Sidebar panel for inputs ----
    #sidebarPanel(
     
     
      # Input: Slider for the number of bins ----
     # sliderInput(inputId = "bins",
       #           label = "Number of bins:",
       #           min = 1,
      #            max = 2000,
       #           value = 30)
      
  # ),
    
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        tabPanel("Wyszukiwanie imion",
                 fluidRow(
                   column(8,textInput("imie","Wpisz imie",value = "ANDRZEJ")),
                   column(9,actionButton("go", "PLOT")),
                   column(10,textOutput("out")),
                   column(12,plotOutput(outputId = "distPlot")))),
       tabPanel("Top 10",
                 fluidRow(
                   column(3,wyborroku<-selectInput(inputId = "wyborRoku", label = "Wybierz rok:", choices = list("2000" = 2000, "2001" = 2001, "2002" = 2002, "2003" = 2003, "2004" = 2004, "2005" = 2005, "2006" = 2006, "2007" = 2007, "2008" = 2008, "2009" = 2009, "2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018), , selected = NULL, multiple = FALSE, selectize = FALSE)),
                   column(4,tableOutput(outputId = "Top10M")),
                   column(5,tableOutput(outputId = "Top10K"))
                   )),
        tabPanel("Rok",wyborroku )
      ),
      textOutput("text")
      # Output: Histogram ----
     # plotOutput(outputId = "distPlot"),
      
      
      
    )
  )
)