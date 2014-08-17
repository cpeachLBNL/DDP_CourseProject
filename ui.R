#ui.R - Plot Histogram, with Slide Input
shinyUI(pageWithSidebar(
        headerPanel("Exploratory Analysis:  Stock ~ Market"),
        sidebarPanel(
                selectInput("ticker", "1) Stock Ticker:",
                        c("Alcoa (AA)" = "AA",
                          "Boeing (BA)" = "BA",
                          "Citigroup (C)" = "C")),
                dateInput("endDate", "2) End Date:", value = "2014-08-01", 
                          min = "2008-08-01", max = "2014-08-01",
                          format = "mm/dd/yyyy", startview = "month", weekstart = 0, 
                          language = "en"),
                sliderInput("duration", "3) Duration:", value=200, min=50, max=400, step=1)

                
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Results", htmlOutput("model"), htmlOutput("R2"), plotOutput("chart")),
                tabPanel("Documentation", 
                         p("This application provides a simple means to explore a stock's relationship with related market data.  
                           For example, it might be useful to know how a specific stock moves with its market benchmark (e.g AA vs SP500).  
                           Parameters used in this exploration are:  Stock ticker, End Date, and Duration."),
                         p(""),
                         p("To explore the relationship between a stock and the market, follow these four simple steps:"),
                         HTML("1)  Select a stock from the <b><i>Stock Ticker</i></b> pick list.<br>"),
                         HTML("2)  Enter a date in the <b><i>End Date</i></b> text box.<br>"),
                         HTML("3)  Use the slider to select a <b><i>Duration</i></b>.<br>"),
                         HTML("4)  If not already selected, click the <b><i>Results</i></b> tab to see:<br>"),
                         HTML("<li> The model in the form <b><i>stock = b0 + b1 * market</i></b>."),
                         HTML("<li> The R-squared calculation, indicating the amount of variance explained by this model."),
                         HTML("<li> The plot of stock return and the model over the end date and duration selected."),
                         HTML("<li> The plot of residuals over the end date and duration selected.")
                         
                        )
                    )
                )
        )
)