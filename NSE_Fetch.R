# Author: Rohil Saraf
# Date last modified: 11/11/2021
# Group A
# Extacting NSE Data
# Stock selected: Meta Platforms
# Dataset Description: This dataset will contain the current price, previous closing price, opening price, trading volumes and percentage change of a particular stock (NESTLEIND in this case) from NSE. 
# The intraday day has been collected at an interval of 2 minutes at every working day of the stock market.
# Columns: 
# STOCK NAME: The name of the stock
# DATE: Date when information was fetched
# TIME: Time when information was fetched
# OPEN: The price at which a stock started trading when the opening bell rang.
# CLOSE: The price of an individual stock when the stock exchange closed shop for the day.
# HIGH: The high is the highest price at which a stock traded during a period.
# LOW:  The low is the lowest price of the period. 
# VOLUME: The number of shares of a security traded between its daily open and close.
# PERCENT CHANGE: The Percent Change measures the absolute percentage price change of the security's price since the previous day's close. 

library(rvest, warn.conflicts = F)
library(tidyverse,warn.conflicts = F)

NSESYM<- "NESTLEIND"

baseURL<- paste0("https://finance.yahoo.com/quote/", NSESYM, ".NS?p=", NSESYM,".NS&ncid=stockrec")

link<- read_html(baseURL)

# Extracting Data
price<- as.double(gsub(",", "",minimal_html(link) %>% html_element(css=".Trsdu\\(0\\.3s\\).Fw\\(b\\)") %>% html_text()))
open<- as.double(gsub(",", "",minimal_html(link) %>% html_nodes('[data-test=OPEN-value]') %>% html_text()))
close<- as.double(gsub(",", "",minimal_html(link) %>% html_nodes('[data-test=PREV_CLOSE-value]') %>% html_text()))
volume<- as.double(gsub(",", "", minimal_html(link) %>% html_nodes('[data-test=TD_VOLUME-value]') %>% html_element("span") %>% html_text()))
percentage_change<- as.double(round((price-close)*100/price, 2))
date<- format(Sys.Date(), "%d %B, %Y")
time<- format(Sys.time(), "%H:%M:%S")
range<- strsplit(minimal_html(link) %>% html_nodes('[data-test=DAYS_RANGE-value]') %>% html_text(), split = "-")
low<- as.double(gsub(",", "",range[[1]][1]))
high<- as.double(gsub(",", "",range[[1]][2]))
# Updating
Date=Time=Open=Close=Price=Volume=Percent_Change=High=Low=NULL
Date<- c(Date, date)
Time<- c(Time, time)
Open<- c(Open, open)
Price<- c(Price, price)
High<- c(High, high)
Low<- c(Low, low)
Close<- c(Close, close)
Volume<- c(Volume, volume)
Percent_Change<- c(Percent_Change, percentage_change)
df<- data.frame(
  Stock_Name=NSESYM, Date, Time, Open, High, Low, Close, Price, Volume, Percent_Change
)

# Exporting
write.table(df, sep=",",file="C:\\Users\\Rohil Saraf\\OneDrive\\Pdfs\\Fall 21-22\\E1- Programming for Data Science\\19BDS0171_StockNSE2.csv", row.names = F, append = T, col.names = ifelse(file.exists("C:\\Users\\Rohil Saraf\\OneDrive\\Pdfs\\Fall 21-22\\E1- Programming for Data Science\\19BDS0171_StockNSE2.csv"), F, T))



