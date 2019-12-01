# Define server logic required to draw a histogram ----
server <- function(input, output) {
  xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")

  
    output$out <- renderText({
      input$go
      isolate(input$imie)
      
      
      })

  
  
  
  
 
  
  
  output$distPlot <- renderPlot({
    input$go
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
  
   output$Top10M<- renderTable({
    wybractop10M<-xx[grep(input$wyborRoku, xx[[1]]),]
    wybractop10M<-wybractop10M[grep("M", wybractop10M[[4]]),]
   #print(wybractop10)
    to10M<-wybractop10M[1:10,]
    print(to10M)
  })
  
  output$Top10K<- renderTable({
    wybractop10K<-xx[grep(input$wyborRoku, xx[[1]]),]
    wybractop10K<-wybractop10K[grep("K", wybractop10K[[4]]),]
    #print(wybractop10)
    to10K<-wybractop10K[1:10,]
    print(to10K)
  })
  
}