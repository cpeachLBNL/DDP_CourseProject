#server.r - Creates Histogram, input = Slider
library(shiny)
stocks <- readRDS("stocks.rds")
modelStatement <- ""

plotStock <- function(ticker, endDate, duration, output){
    dateEnd = as.Date(endDate)
    duration <- as.numeric(duration)
    stockData <- stocks[(stocks$date <= dateEnd),c("date", "SP500", ticker)]
    stockData <- stockData[1:duration,]
    #Scale Data
    stockData$market <- (stockData$SP500-mean(stockData$SP500))/sd(stockData$SP500)
    stockData$stock <- (stockData[,ticker]-mean(stockData[,ticker]))/sd(stockData[,ticker])
    
    #Fit a Linear Model to dataset
    lm1 <- lm(stock ~ market, data=stockData)
    B0 <- round(coef(lm1)[1], 2)
    B1 <- round(coef(lm1)[2], 2)
    modelStatement <- paste("<h3>Model: stock =", B0, "+", B1, "x market</h3>")
    output$model <- renderText({modelStatement})
    stockData$predStock <- B0 + B1 * stockData$market
    
    #Calc residuals:
    stockData$resid = resid(lm1)
    R2 = summary(lm1)$r.squared
    output$R2 <- renderText({paste("<h3>R-squared=", round(R2,2), "</h3>")})
    
    #plot the stock Return and the values predicted by the model
    par(mfrow=c(2,1), mar=c(4, 4, 2, 2))
    plot(stockData$date, stockData$stock, type="l", col="blue", main=paste(ticker, "and Model vs Time"),
         xlab="Date", ylab=paste(ticker, "return"), 
         ylim=range(stockData$stock, stockData$predStockReturn))
    lines(stockData$date, stockData$predStock, lwd=1, col="red")
    legend("topleft", legend = c(ticker,"Model"), col=c("blue", "red"), 
           pch = 20, bty="n")
    
    plot(stockData$date, stockData$resid, type="l", col="blue", main="Residuals vs Time",
         xlab="Date", ylab="Residuals")
    abline(h = 0, lwd = 1) #Horizontal line through 0
    
}

shinyServer(
        function(input, output){
            output$chart <- renderPlot({
                plotStock(input$ticker, input$endDate, input$duration, output)})
            
        }
        )