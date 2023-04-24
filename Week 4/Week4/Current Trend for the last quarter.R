#Finding the current stock price trend for the last quarter in Goldman Sachs, Morgan Stanley, and Charles Schwab
# are they decreasing , increasing, or or side ways?
# finding the support and resistance indicators 


library(readxl)

# Load the dataset
CurrentStockPriceTrend <- read_xlsx("/Users/korigray/Desktop/Data-Science-Program/DS110-Final Project/Tableau Data Set Combined.xlsx")

names(CurrentStockPriceTrend)[5] <- "Close_GS"
names(CurrentStockPriceTrend)[11] <- "Close_MS"
names(CurrentStockPriceTrend)[17] <- "Close_SCHW"





#install.packages("TTR")
library(quantmod)
library(TTR)

### Calculate the MACD for the closing prices with Goldman Sachs
macd_data <- MACD(CurrentStockPriceTrend$Close_GS)

# Convert the data to a time series object
GSCLOSEprices <- xts(CurrentStockPriceTrend$Close_GS, order.by = as.Date(CurrentStockPriceTrend$Date))

# Calculate the MACD
macd_data <- MACD(GSCLOSEprices)

# Extract the MACD line and the signal line
macd_line <- macd_data$macd
signal_line <- macd_data$signal

# Filter the MACD and signal lines to only include the last quarter of data
last_quarter <- tail(index(macd_line), n = 63)
macd_line_last_quarter <- macd_line[last_quarter]
signal_line_last_quarter <- signal_line[last_quarter]


# Plot the MACD and signal lines for the last quarter
MACDplot1<-plot(macd_line_last_quarter, type = "l", col = "blue", main = "MACD - Last Quarter for Goldman Sachs")
lines(signal_line_last_quarter, col = "red")

#Goldman sachs is bearish ( downward trend)




### Calculate the MACD for the closing prices with Morgan Stanley
macd_data <- MACD(CurrentStockPriceTrend$Close_MS)

# Convert the data to a time series object
MSCLOSEprices <- xts(CurrentStockPriceTrend$Close_MS, order.by = as.Date(CurrentStockPriceTrend$Date))

# Calculate the MACD
macd_data <- MACD(MSCLOSEprices)

# Extract the MACD line and the signal line
macd_line <- macd_data$macd
signal_line <- macd_data$signal

# Filter the MACD and signal lines to only include the last quarter of data
last_quarter <- tail(index(macd_line), n = 63)
macd_line_last_quarter <- macd_line[last_quarter]
signal_line_last_quarter <- signal_line[last_quarter]


# Plot the MACD and signal lines for the last quarter
MACDplot2<-plot(macd_line_last_quarter, type = "l", col = "blue", main = "MACD - Last Quarter for Morgan Stanley")
lines(signal_line_last_quarter, col = "red")

#Morgan Stanleys is a downword trend in the last quarter 



### Calculate the MACD for the closing prices with Charles Schwab
macd_data <- MACD(CurrentStockPriceTrend$Close_SCHW)

# Convert the data to a time series object
SCHWCLOSEprices <- xts(CurrentStockPriceTrend$Close_SCHW, order.by = as.Date(CurrentStockPriceTrend$Date))

# Calculate the MACD
macd_data <- MACD(SCHWCLOSEprices)

# Extract the MACD line and the signal line
macd_line <- macd_data$macd
signal_line <- macd_data$signal

# Filter the MACD and signal lines to only include the last quarter of data
last_quarter <- tail(index(macd_line), n = 63)
macd_line_last_quarter <- macd_line[last_quarter]
signal_line_last_quarter <- signal_line[last_quarter]


# Plot the MACD and signal lines for the last quarter
MACDplot3<-plot(macd_line_last_quarter, type = "l", col = "blue", main = "MACD - Last Quarter for Charles Schwab")
lines(signal_line_last_quarter, col = "red")


#last quarter trend tends to move in a downward trend for schwab


### All 3 decrease into the same direction seems as if they all are on the same path???



#trend indicators- support and resistance 
install.packages("TTR")
library(TTR)
library(ggplot2)

GS_data <- CurrentStockPriceTrend[CurrentStockPriceTrend$Close_GS == "Goldman Sachs",]

# Add technical indicators to MACD plot
GS_data$ma <- SMA(GS_data$Close_GS, n = 10)

ggplot(GS_data, aes(x = Date, y = MACD)) +
  geom_line() +
  geom_line(aes(y = Signal, linetype = "Signal")) +
  geom_line(aes(y = ma, linetype = "MA")) +
  scale_linetype_manual(values = c("Signal" = "dashed", "MA" = "dotted")) +
  ggtitle("Goldman Sachs MACD Comparison with Moving Average") +
  labs(x = "Date", y = "Value")
