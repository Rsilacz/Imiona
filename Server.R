# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    #cf <- file.choose()
    #x    <- read.csv(cf, TRUE, sep = ",",encoding = "UTF-8", nrows = 20)
   # y <- x[[2]]
    #z <- x[[1]]
    #print(z)
    
    #slices <- y
    #lbls <- z
    
    #(slices, labels = lbls, main="Pie Chart of Names")
    #Imie Andrzej w latach 2000-2018
    #chfi <- file.choose()
    xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")
    Andrzej <- xx[grep(input$imie, xx[[2]]),]
    #print(Andrzej)
    AndrzejX <- Andrzej[[3]]
    AndrzejY <- Andrzej[[1]]
    #print(AndrzejX)
    #print (AndrzejY)
    barplot(AndrzejX, space=NULL, names.arg = AndrzejY, ylim=c(0,2000), xlab = "Lata 2000-2018", ylab="Ilosc nadanych imion", main = paste("Imie ",input$imie," w latach 2000-2018"))
    
    
    output$wybranyRok <- renderPrint({ input$wyborRoku })
    
    
    
    
    #hist(y)
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    #hist(x, breaks = bins, col = "#75AADB", border = "white",
     #    xlab = "Waiting time to next eruption (in mins)",
      #   main = "Histogram of waiting times")
    
  })
  
}