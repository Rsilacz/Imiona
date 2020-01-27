# Define server logic required to draw a histogram ----
server <- function(input, output) {
  xx <- read.csv(url("https://api.dane.gov.pl/media/resources/20190408/Imiona_nadane_wPolsce_w_latach_2000-2018.csv"), TRUE, sep = ",", encoding = "UTF-8")
  TOP <- read.csv('TOP.csv',TRUE,sep=",",encoding = "UTF-8", row.names = NULL)
  
  daneImiona2017<-read.xlsx('im_2017.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2016<-read.xlsx('im_2016.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2015<-read.xlsx('im_2015.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2014<-read.xlsx('im_2014.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  daneImiona2013<-read.xlsx('im_2013.xlsx', sheetIndex = 1, header = TRUE, encoding = "UTF-8")
  
  granice<-readOGR(dsn = 'Wojewodztwa\\Wojewodztwa.shp', layer = 'Wojewodztwa', encoding = "UTF-8")
  
  wyliczTrend<-function(wybraneImie){
    wybraneImieX <- wybraneImie[[1]]
    wybraneImieY <- wybraneImie[[3]]
    liczbaWystapien<-length(wybraneImie)
    zrobLP=1999
    t=wybraneImieX-zrobLP
    Y=wybraneImieY
    sredniaT<-mean(t)
    sredniaY<-mean(Y)
    tMinusSrednia<-t-sredniaT
    YMinusSrednia<-Y-sredniaY
    tMSxYMS<-tMinusSrednia*YMinusSrednia
    tMSxtMS<-tMinusSrednia*tMinusSrednia
    aLicznik<-sum(tMSxYMS)
    aMianownik<-sum(tMSxtMS)
    a=aLicznik/aMianownik
    return(a)
  }
  
  output$distPlot <- renderPlot({
    input$go
    if(input$wyborWoj == 1){
      isolate(X <- paste("^",toupper(input$imie),"$",sep = ""))
      Andrzej <- xx[grep(X, xx[[2]]),]
      Y<-max(Andrzej[[3]])
      AndrzejX <- Andrzej[[3]]
      AndrzejY <- Andrzej[[1]]
      napis<-"Lata 2000-2018"
      napis_d <-" w latach 2000-2018"
    }
    else{
      napis<-"Lata 2013-2017"
      napis_d <- " w latach 2013-2017"
      AndrzejY <-c(2013,2014,2015,2016,2017)
      aa<-input$wyborWoj
      if(aa == 2){
        choice<-9
      }
      if(aa == 3){
        choice<-7
      }
      if(aa == 4){
        choice<-16
      }
      if(aa == 5){
        choice<-17
      }
      if(aa == 6){
        choice<-14
      }
      if(aa == 7){
        choice<-11
      }
      if(aa == 8){
        choice<-15
      }
      if(aa == 9){
        choice<-3
      }
      if(aa == 10){
        choice<-10
      }
      if(aa == 11){
        choice<-8
      }
      if(aa == 12){
        choice<-12
      }
      if(aa == 13){
        choice<-2
      }
      if(aa == 14){
        choice<-6
      }
      if(aa == 15){
        choice<-13
      }
      if(aa == 16){
        choice<-4
      }
      if(aa == 17){
        choice<-5
      }
      choice<- choice-1
      
      XX<-paste("^",toupper(input$imie),"_",sep="")
      X<-grep(XX,colnames(daneImiona2013),value=TRUE)
      AndrzejX<-c(daneImiona2013[choice,X],
                  daneImiona2014[choice,X],
                  daneImiona2015[choice,X],
                  daneImiona2016[choice,X],
                  daneImiona2017[choice,X])
      Y<-max(AndrzejX)
    }
    
    isolate(slupki<-barplot(AndrzejX, space=NULL, names.arg = AndrzejY, ylim=c(0,Y+50),
                    xlab = napis, ylab="Ilość nadanych imion", col=rgb(0.2,0.4,0.6,0.6),
                    main = paste("Imię ",toupper(input$imie),napis_d)))
    output$wybranyRok <- renderPrint({ input$wyborRoku })
  })
  
  observeEvent(input$wyborRoku,{
    if(input$wyborRoku >= 2013 && input$wyborRoku < 2018){
      shinyjs::show(id = "wyborW")
    }
    else{
      shinyjs::hide(id="wyborW")
    }
  })
  
  output$Top10M<- renderTable({
    if(input$wyborRoku >= 2013 && input$wyborRoku < 2018 && input$wyborW != "Polska"){
      wybractop10M<-TOP[grep(input$wyborRoku,TOP[[1]]),]
      wybractop10M<-wybractop10M[grep("M", wybractop10M[[4]]),]
      wybractop10M<-wybractop10M[grep(input$wyborW, wybractop10M[[5]]),]
      to10M<-wybractop10M[1:10,]
      to10M<-to10M[-c(5)]
    }
    else{
      wybractop10M<-xx[grep(input$wyborRoku, xx[[1]]),]
      wybractop10M<-wybractop10M[grep("M", wybractop10M[[4]]),]
      to10M<-wybractop10M[1:10,]
      print(to10M)
    }
  })
  
  output$Top10K<- renderTable({
    if(input$wyborRoku >= 2013 && input$wyborRoku < 2018  && input$wyborW!="Polska") {
      wybractop10K<-TOP[grep(input$wyborRoku, TOP[[1]]),]
      wybractop10K<-wybractop10K[grep("K", wybractop10K[[4]]),]
      wybractop10K<-wybractop10K[grep(input$wyborW, wybractop10K[[5]]),]
      to10K<-wybractop10K[1:10,]
      to10K<-to10K[-c(5)]
    }
    else{
      wybractop10K<-xx[grep(input$wyborRoku, xx[[1]]),]
      wybractop10K<-wybractop10K[grep("K", wybractop10K[[4]]),]
      to10K<-wybractop10K[1:10,]
    }
  })
  
  output$pieChart <- renderPlot({
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
    lbls <- c("Mężczyźni", "Kobiety")
    lbls <- paste(lbls, pct) 
    lbls <- paste(lbls,"%",sep="") 
    pie3D(slices, labels = lbls, main="Procentowy rozkład płci w wybranym roku",col = c("red","green"), radius = 1)
  })
  
  output$trend <- renderPlot({
    X <- paste("^",toupper(input$imieT),"$",sep = "")
    wybraneImie <- xx[grep(X, xx[[2]]),]
    wartosciWybranegoImienia <- wybraneImie[[3]]
    srednia <- mean(wartosciWybranegoImienia)
    wariancja <- var(wartosciWybranegoImienia)
    odchylenie <- sd(wartosciWybranegoImienia)
    wybraneImieX <- wybraneImie[[1]]
    wybraneImieY <- wybraneImie[[3]]
    plot(wybraneImieX, wybraneImieY, type = "b", col=rgb(0.2,0.4,0.6,0.6), lwd=5, xlab="Kolejne lata", ylab="Ilość nadanych imion" )
    obliczonyTrend<-wyliczTrend(wybraneImie)
    if(obliczonyTrend < 0){
      output$trendtxt <- renderText("Trend maleje")
    }
    if(obliczonyTrend == 0){
      output$trendtxt <- renderText("Trend jest stały")
    }
    if(obliczonyTrend > 0){
      output$trendtxt <- renderText("Trend rośnie")
    }
  })
  
  output$mapapolski<-renderLeaflet({
    input$goM 
    isolate(X <- paste("^",toupper(input$imieM),"_",sep = ""))
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