# Define server logic required to draw a histogram ----
server <- function(input, output) {
  xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")
  daneImiona2017<-read.xlsx('im_2017.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2016<-read.xlsx('im_2016.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2015<-read.xlsx('im_2015.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2014<-read.xlsx('im_2014.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2013<-read.xlsx('im_2013.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  granice<-readOGR(dsn = 'Wojewodztwa\\Wojewodztwa.shp', layer = 'Wojewodztwa', encoding = "UTF-8")

  
  
  observeEvent(input$wyborR,{
    if(input$wyborR >= 2013){
      shinyjs::show(id = "wyborWoj")
      print("show")
    }else{
      shinyjs::hide(id = "wyborWoj")
      print("hide")
    }
    
  })
    
  wyliczTrend<-function(wybraneImie){
    wybraneImieX <- wybraneImie[[1]]
    wybraneImieY <- wybraneImie[[3]]
    liczbaWystapien<-length(wybraneImie)
    zrobLP=1999
    t=wybraneImieX-zrobLP
    Y=wybraneImieY
    sredniaT<-mean(t)
    sredniaY<-mean(Y)
    #print(t)
    #print(sredniaT)
    #print(sredniaY)
    tMinusSrednia<-t-sredniaT
    YMinusSrednia<-Y-sredniaY
    #print(tMinusSrednia)
    #print(YMinusSrednia)
    tMSxYMS<-tMinusSrednia*YMinusSrednia
    tMSxtMS<-tMinusSrednia*tMinusSrednia
    #print(tMSxYMS)
    #print(tMSxtMS)
    aLicznik<-sum(tMSxYMS)
    aMianownik<-sum(tMSxtMS)
    a=aLicznik/aMianownik
    print(a)
    return(a)
  }
  
  output$distPlot <- renderPlot({
    input$go
    isolate(X <- paste("^",toupper(input$imie),"$",sep = ""))
    Andrzej <- xx[grep(X, xx[[2]]),]
    Y<-max(Andrzej[[3]])
    #print(Y)
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
    #print(to10M)
  })
  
  output$Top10K<- renderTable({
    wybractop10K<-xx[grep(input$wyborRoku, xx[[1]]),]
    wybractop10K<-wybractop10K[grep("K", wybractop10K[[4]]),]
    #print(wybractop10)
    to10K<-wybractop10K[1:10,]
    #print(to10K)
  })
  
  output$pie <- renderPlot({
    zmienna <- xx[grep(input$wyborRoku,xx[[1]]),]
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
    pie3D(slices, labels = lbls, main="M vs K",col = rainbow(length(slices)))
  })
  
  output$trend <- renderPlot({
    X <- paste("^",toupper(input$imieT),"$",sep = "")
    wybraneImie <- xx[grep(X, xx[[2]]),]
    wartosciWybranegoImienia <- wybraneImie[[3]]
    srednia <- mean(wartosciWybranegoImienia)
    wariancja <- var(wartosciWybranegoImienia)
    odchylenie <- sd(wartosciWybranegoImienia)
    #print("srednia")
    #print(srednia)
    #print("wariancja")
    #print(wariancja)
    #print("odchylenie")
    #print(odchylenie)
    wybraneImieX <- wybraneImie[[1]]
    wybraneImieY <- wybraneImie[[3]]
    #print(wybraneImieX)
    #print(wybraneImieY)
    #print(wybraneImie)
    plot(wybraneImieX, wybraneImieY, type = "b")
    obliczonyTrend<-wyliczTrend(wybraneImie)
    if(obliczonyTrend < 0){
      output$trendtxt <- renderText("Trend maleje")
    }
    if(obliczonyTrend == 0){
      output$trendtxt <- renderText("Trend jest staly")
    }
    if(obliczonyTrend > 0){
      output$trendtxt <- renderText("Trend rosnie")
    }
    #plot()
  })
  
  output$mapapolski<-renderLeaflet({
    input$goM
   isolate(X <- paste(toupper(input$imieM))) 
   # X = "ANDRZEJ"
    #wybraneImie <- daneImiona[grep("MARCIN", daneImiona[[1]]),]
    #wybraneImie2 <- select(daneImiona, "ANDRZEJ")
    if(input$wyborM == 2013){
      wybraneImie3 <- daneImiona2013[grep(X, names(daneImiona2013), value = TRUE)]
    }
   if(input$wyborM == 2014){
     wybraneImie3 <- daneImiona2014[grep(X, names(daneImiona2014), value = TRUE)]
   }
   if(input$wyborM == 2015){
     wybraneImie3 <- daneImiona2015[grep(X, names(daneImiona2015), value = TRUE)]
   }
   if(input$wyborM == 2016){
     wybraneImie3 <- daneImiona2016[grep(X, names(daneImiona2016), value = TRUE)]
   }
   if(input$wyborM == 2017){
     wybraneImie3 <- daneImiona2017[grep(X, names(daneImiona2017), value = TRUE)]
   }
    
    colnames(wybraneImie3) <-("wybrane_imie")
    skala<-c(2,10,20,40,50,100,200,300,600)
    skalaAndrzej<-c(2,4,8,16,32,64,128,256,512,1024,2048)
    pal<-colorBin("Spectral", domain = wybraneImie3$wybrane_imie, bins = skalaAndrzej)
    etykiety<-(wybraneImie3$wybrane_imie)
  isolate(poland<-leaflet() %>%
     addTiles() %>%
     setView(19.313,52.278, zoom = 6) %>%
     addPolygons(data = granice, fillColor = pal(wybraneImie3$wybrane_imie), fillOpacity = 0.8, color = "white",
                 smoothFactor = 1, highlight = highlightOptions(weight = 5, color = "red",
                                                                                   fillOpacity = 0.5,
                                                                                 bringToFront = TRUE),
                 label = etykiety) %>% 
                 addLegend(pal = pal, values = wybraneImie3$wybrane_imie, opacity = 0.5, position = "topright")) 
  })
  
  observe({
    click = input$mapapolski_shape_click
    if(is.null(click))
      return()
    else
      leafletProxy("mapapolski") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 8) %>%
      clearMarkers() %>%
      addMarkers(lng = click$lng, lat = click$lat)
  })
  
}