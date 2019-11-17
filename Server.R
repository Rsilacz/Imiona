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
    cf <- file.choose()
    x    <- read.csv(cf, TRUE, sep = ",", nrows = 20)
    y <- x[[2]]
    z <- x[[1]]
    print(z)
    
    #counts <- table(y)
    #barplot(counts, main="Car Distribution",
     #       xlab="Number of Gears")
    #print(counts)
    
    
    
    slices <- y
    lbls <- z
    
    pie(slices, labels = lbls, main="Pie Chart of Names")
  
    
      
     
    
    
    
    
    
    
    
    #hist(y)
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    #hist(x, breaks = bins, col = "#75AADB", border = "white",
     #    xlab = "Waiting time to next eruption (in mins)",
      #   main = "Histogram of waiting times")
    
  })
  
}