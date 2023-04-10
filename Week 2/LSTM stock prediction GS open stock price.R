# Load in packages
library(keras)
library(tensorflow)
library(readxl)
library(ggplot2)
library(dplyr)

#Load in Data
GoldmanSachs = read.csv("/Users/korigray/Documents/GitHub/Final class project/Final-Project/GS.csv")

head(GoldmanSachs)

# Data Wranging
scale_factors <- c(mean(GoldmanSachs$Open), sd(GoldmanSachs$Open))
scale_factors

scaled_train <- GoldmanSachs %>%
  dplyr::select(Open) %>%
  dplyr::mutate(Open = (Open - scale_factors[1]) / scale_factors[2])

head(scaled_train)

prediction <- 12
lag <- prediction

## Scale x_train 

scaled_train <- as.matrix(scaled_train)

# we lag the data 11 times and arrange that into columns
x_train_data <- t(sapply(
  1:(length(scaled_train) - lag - prediction + 1),
  function(x) scaled_train[x:(x + lag - 1), 1]
))

# now we transform it into 3D form
x_train_arr <- array(
  data = as.numeric(unlist(x_train_data)),
  dim = c(
    nrow(x_train_data),
    lag,
    1
  )
)

head(x_train_data)



##Set y_train


y_train_data <- t(sapply(
  (1 + lag):(length(scaled_train) - prediction + 1),
  function(x) scaled_train[x:(x + prediction - 1)]
))

y_train_arr <- array(
  data = as.numeric(unlist(y_train_data)),
  dim = c(
    nrow(y_train_data),
    prediction,
    1
  )
)

head(y_train_data)


#set and scale x_test

x_test <- GoldmanSachs$Adj.Close[(nrow(scaled_train) - prediction + 1):nrow(scaled_train)]

x_test

# scale the data with same scaling factors as for training
x_test_scaled <- (x_test - scale_factors[1]) / scale_factors[2]

# this time our array just has one sample, as we intend to perform one 12-months prediction
x_pred_arr <- array(
  data = x_test_scaled,
  dim = c(
    1,
    lag,
    1
  )
)

x_pred_arr


## Build LSTM

library(reticulate)

lstm_model <- keras_model_sequential()

lstm_model %>%
  layer_lstm(units = 50, # size of the layer
             batch_input_shape = c(1, 12, 1), # batch size, timesteps, features
             return_sequences = TRUE,
             stateful = TRUE) %>%
  # fraction of the units to drop for the linear transformation of the inputs
  layer_dropout(rate = 0.5) %>%
  layer_lstm(units = 50,
             return_sequences = TRUE,
             stateful = TRUE) %>%
  layer_dropout(rate = 0.5) %>%
  time_distributed(keras::layer_dense(units = 1))

lstm_model



lstm_model %>%
  compile(loss = 'mae', optimizer = 'adam', metrics = 'accuracy')

summary(lstm_model)

lstm_model %>% fit(
  x = x_train_arr,
  y = y_train_arr,
  batch_size = 1,
  epochs = 20,
  verbose = 0,
  shuffle = FALSE
)



lstm_forecast <- lstm_model %>%
  predict(x_pred_arr, batch_size = 1) %>%
  .[, , 1]

# we need to rescale the data to restore the original values
lstm_forecast <- lstm_forecast * scale_factors[2] + scale_factors[1]

lstm_forecast


fitted <- predict(lstm_model, x_train_arr, batch_size = 1) %>%
  .[, , 1]

fitted


if (dim(fitted)[2] > 1) {
  fit <- c(fitted[, 1], fitted[dim(fitted)[1], 2:dim(fitted)[2]])
} else {
  fit <- fitted[, 1]
}

# additionally we need to rescale the data
fitted <- fit * scale_factors[2] + scale_factors[1]
nrow(fitted) # 562

# I specify first forecast values as not available
fitted <- c(rep(NA, lag), fitted)

library("timetk")
lstm_forecast <- timetk::tk_ts(lstm_forecast,
                               start = c(2000, 12),
                               end = c(2021, 12),
                               frequency = 12
)

lstm_forecast



input_ts <- timetk::tk_ts(GoldmanSachs$Open, 
                          start = c(2000, 12), 
                          end = c(2021,12 ), 
                          frequency = 12)
input_ts


forecast_list <- list(
  model = NULL,
  method = "LSTM",
  mean = lstm_forecast,
  x = input_ts,
  fitted = fitted,
  residuals = as.numeric(input_ts) - as.numeric(fitted)
)

class(forecast_list) <- "forecast"



forecast::autoplot(forecast_list)


