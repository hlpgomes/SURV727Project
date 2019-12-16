
###############
## Resources ##
###############

# http://r-statistics.co/Time-Series-Analysis-With-R.html
# https://ourcodingclub.github.io/2017/04/26/time.html
# https://otexts.com/fpp2/stl.html
# https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_ts.html
# http://r-statistics.co/Time-Series-Analysis-With-R.html
# https://cran.r-project.org/web/packages/dtw/vignettes/dtw.pdf
# https://www.statmethods.net/advstats/timeseries.html#:~:targetText=The%20ts()%20function%20will,%3Dmonthly%2C%20etc.).
# https://towardsdatascience.com/cross-correlation-of-currency-pairs-in-r-ccf-d27eec2d4b91
# https://www.itl.nist.gov/div898/handbook/pmc/section6/pmc622.htm#:~:targetText=The%20autocorrelation%20plot%20indicates%20that,and%20suggests%20an%20ARIMA%20model.&targetText=The%20run%20sequence%20plot%20of,autocorrelated%20than%20the%20original%20data
# https://afit-r.github.io/ts_exploration


################
## Load Data ###
################

load('S:/SURV727_Fundamental_Computing_DataDisplay/Final_Project/Amazon/Data/data_index.Rda')

library(tidyverse)

df <- data_index %>%
  filter(Date1 > "2019-10-30", Date1 <= "2019-11-30", IX_type=="Proxy_wgt") %>% 
  select(Date1, G_IX) 
class(df$Date1)


######################################
### Convert to timeseries TS object ##
######################################
library(tsbox)
dt0 <- ts_ts(ts_long(df))
plot(dt0)

#############################################
## Convert into correct Weekly time series ##
#############################################
dt1 <- ts(dt0, frequency = 7)
plot(dt1)
plot.ts(dt1)
str(dt1)

####################################
## Cross Correlation 
# https://towardsdatascience.com/cross-correlation-of-currency-pairs-in-r-ccf-d27eec2d4b91

## first line at 0 lag is the correlation with itself. Not correlation with lag
acfRes <- acf(dt1) # autocorrelation
acfRes <- acf(dt1, lag=31) # autocorrelation
acfRes

pacfRes <- pacf(dt1, lag=31)  # partial autocorrelation
pacfRes

#ccfRes <- ccf(dt1[,1], dt1[,2], ylab = "cross-correlation") # computes cross correlation between 2 timeseries.
#head(ccfRes[[1]])


############################################
## Autocorrelation from Forescast package ##
####         Used in paper              ####
############################################
# https://towardsdatascience.com/cross-correlation-of-currency-pairs-in-r-ccf-d27eec2d4b91
# https://rdrr.io/cran/forecast/man/autoplot.acf.html
# https://newonlinecourses.science.psu.edu/stat462/node/188/


###################################
#  Augemented Dickey-Fuller test ##
## Rejecting the null hypothesis suggests that a time series is stationary (from the tseries package)
##################################
library(tseries)
adf.test(dt1)

## Index Series is stationary, so the autocorrelation plot can be interpreted as correction with it's lag value for forcasting modeling. 


#################################
####     Ljung-Box test      ####
## to check that the residuals from a time series model resemble white noise. 
#If the result is a small p-value than it indicates the data are probably not white noise. Large p value means white noice.
################################
boxt <- Box.test(dt1, type="Ljung-Box")
boxt$p.value
boxt$method


#################
###   Plots   ###
#################
library(forecast)

ggseasonplot(dt1) +
  ylab("Percent Change (%)") +
  ggtitle("Seasonal plot of Daily Price Index (Geo-means)") +
  theme(legend.position = "none")  
### Dim 430 315


par(mar = c(4, 4, 0.2, 0.1))
par(mfrow=c(1,2)) 

ggAcf(dt1, lag=31) +
  ggtitle("Autocorrelation for Daily Price Index (Geo-means)")
ggPacf(dt1, lag=31) +
  ggtitle("Partial Autocorrelation for Daily Price Index")
## Dim 450 300

length(dt1)
ggAcf(dt1) +
  ggtitle("Autocorrelation for Daily Price Index (Geo-means)")
ggPacf(dt1, lag=1) +
  ggtitle("Partial Autocorrelation for Daily Price Index")
## Dim 450 300

## eact line in autocorrelation indicates correlation value between current the that lag. If it crosses the 95% band, then is has a significant correlation with that lag, so that lag (yt-lag) coule be used in developing a forcasting model. 



#ggCcf()
  
autoplot(dt1) + xlab("Week (start date: 2019-10-31")

autoplot(dt1) +
  geom_smooth()
gglagplot(dt1)



######################################
###  Decomposition of Times series  ##
######################################

dt1 %>% decompose(type="multiplicative") %>%
  autoplot() + xlab("Week") +
  ggtitle("Classical multiplicative decomposition
    of Daily Price Index (Geo-means)")

## dim 400 350

dt1 %>% decompose(type="additive") %>%
  autoplot() + xlab("Week") +
  ggtitle("Classical additive decomposition
    of Daily Price Index (Geo-means)")




