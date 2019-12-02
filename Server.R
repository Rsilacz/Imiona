# Define server logic required to draw a histogram ----
server <- function(input, output) {
  xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")

  
  
  
  
  
 
  
  
  output$distPlot <- renderPlot({
    input$go
    isolate(X <- paste("^",toupper(input$imie),"$",sep = ""))
    
    Andrzej <- xx[grep(X, xx[[2]]),]
    
    Y<-max(Andrzej[[3]])
    print(Y)
    
    AndrzejX <- Andrzej[[3]]
    AndrzejY <- Andrzej[[1]]

    isolate(barplot(AndrzejX, space=NULL, names.arg = AndrzejY, ylim=c(0,Y+500),
                    xlab = "Lata 2000-2018", ylab="Ilosc nadanych imion",
                    main = paste("Imie ",toupper(input$imie)," w latach 2000-2018")))
    
    
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
  
  
  output$pie <- renderPlot({
    
    zmienna <- xx[grep(input$Rok,xx[[1]]),]
    man <- zmienna[grep("M", zmienna[[4]]),]
    wman <- zmienna[grep("K", zmienna[[4]]),]
    tmp1 <- man[3:3]
    Lman <-colSums(tmp1)
    tmp2 <- wman[3:3]
    LWman <-colSums(tmp2)
    print(Lman)
    print(LWman)
    
    
    
    slices <- c(Lman, LWman)
    pct <- round(slices/sum(slices)*100,digits = 2)
    lbls <- c("Mezczyzni", "Kobiety")
    lbls <- paste(lbls, pct) 
    lbls <- paste(lbls,"%",sep="") 
    pie(slices, labels = lbls, main="M vs K",col = rainbow(length(slices)))
    
    
  })
  
  output$trend <- renderPlot({
    
    X <- paste("^",toupper(input$imie),"$",sep = "")
    wybraneImie <- xx[grep(X, xx[[2]]),]
    wartosciWybranegoImienia <- wybraneImie[[3]]
    srednia <- mean(wartosciWybranegoImienia)
    wariancja <- var(wartosciWybranegoImienia)
    odchylenie <- sd(wartosciWybranegoImienia)
    print(srednia)
    print(wariancja)
    print(odchylenie)
    wybraneImieX <- wybraneImie[[1]]
    wybraneImieY <- wybraneImie[[3]]
    plot(wybraneImieX, wybraneImieY, type = "b")
    
    
  })

  
  
}