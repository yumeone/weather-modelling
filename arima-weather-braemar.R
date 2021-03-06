# Directories
mydata<- read.csv("braemar.csv")
attach(mydata)
summary(mydata)

weatherarima <- ts(mydata$tmin[1:591], start = c(1959,1), frequency = 12)
plot(weatherarima,type="l",ylab="Temperature")
title("Minimum Recorded Monthly Temperature: Braemar, Scotland")

stl_weather = stl(weatherarima, "periodic")
seasonal_stl_weather   <- stl_weather$time.series[,1]
trend_stl_weather     <- stl_weather$time.series[,2]
random_stl_weather  <- stl_weather$time.series[,3]

plot(as.ts(seasonal_stl_weather))
title("Seasonal")
plot(trend_stl_weather)
title("Trend")
plot(random_stl_weather)
title("Random")

# Load libraries
library(MASS)
library(tseries)
library(forecast)

# ACF, PACF and Dickey-Fuller Test
acf(weatherarima, lag.max=20)
pacf(weatherarima, lag.max=20)
adf.test(weatherarima)

# Time series and seasonality
weatherarima <- ts(weatherarima, start = c(1959,1), frequency = 12)
plot(weatherarima,type="l")
title("Minimum Recorded Monthly Temperature: Braemar, Scotland")

components <- decompose(weatherarima)
components
plot(components)

# ARIMA
fitweatherarima<-auto.arima(weatherarima, trace=TRUE, test="kpss", ic="bic")
fitweatherarima
confint(fitweatherarima)
plot(weatherarima,type='l')
title('Minimum Recorded Monthly Temperature: Braemar, Scotland')

# Forecasted Values From ARIMA
forecastedvalues=forecast(fitweatherarima,h=148)
forecastedvalues
plot(forecastedvalues)

# Percentage Error
df<-data.frame(mydata$tmin[592:739],forecastedvalues$lower)
col_headings<-c("Actual Weather","Forecasted Weather")
names(df)<-col_headings
attach(df)

range(df$`Actual Weather`)

library(Metrics)
rmse(df$`Actual Weather`,df$`Forecasted Weather`)
mean(df$`Actual Weather`)
var(df$`Actual Weather`)