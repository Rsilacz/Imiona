# Define server logic required to draw a histogram ----
server <- function(input, output) {
  

  
    output$out <- renderText({
      input$go
      isolate(input$imie)
      
      
      })

  
  
  
  
 
  
  
  output$distPlot <- renderPlot({
    input$go
    xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")
    isolate(X <- paste("^",input$imie,"$",sep = ""))
    
    Andrzej <- xx[grep(X, xx[[2]]),]
    
    Y<-max(Andrzej[[3]])
    print(Y)
    
    AndrzejX <- Andrzej[[3]]
    AndrzejY <- Andrzej[[1]]

    isolate(barplot(AndrzejX, space=NULL, names.arg = AndrzejY, ylim=c(0,Y+500),
                    xlab = "Lata 2000-2018", ylab="Ilosc nadanych imion",
                    main = paste("Imie ",input$imie," w latach 2000-2018")))
    
    
    output$wybranyRok <- renderPrint({ input$wyborRoku })
    
    
    
  
    
  })
  
}