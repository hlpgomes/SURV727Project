
############################
## Read Data from the Web ##
############################

library(data.table)
BLS_data <- fread('https://download.bls.gov/pub/time.series/cu/cu.data.17.USEducationAndCommunication')
head(BLS_data)

# EE01 is an Item Strata called "Personal computers and peripheral equipment". It has 1 Entry Level Item (ELI) EE011 "Personal computers and peripheral equipment".


library(tidyverse)
BLS_EE01 <- BLS_data %>%
  select(series_id, year, period, value) %>%
  filter(year %in% c(2016, 2017, 2018, 2019) & series_id=="CUSR0000SEEE01") 

BLS_EE01
str(BLS_EE01)

BLS_EE01$month <- as.numeric(gsub("[^0123456789]", "", BLS_EE01$period))


## Create Date
library(lubridate)
BLS_EE01_df <- BLS_EE01 %>% 
  mutate(date = make_date(year=year, month=month))

str(BLS_EE01_df)


##################################################
## Compute 1-month Percent Change from BLS data ##
##################################################

BLS_EE01_df$PC_1month <- NA
for (i in 1:nrow(BLS_EE01_df)) {
  BLS_EE01_df$PC_1month[i+1] <- 100 * (BLS_EE01_df$value[i+1]-BLS_EE01_df$value[i]) / BLS_EE01_df$value[i]
}

options(scipen=999)
BLS_EE01_df$PC_1month

## Note: error message is fine. It says that the last row with NA has been dropped.



#########################################################
###  Decide what year data to show in the data visual ###
#########################################################

BLS_df <- BLS_EE01_df %>%
    filter(year %in% c(2016, 2017, 2018,2019)) 
names(BLS_df)


#################
## data Visual ##
#################

# https://ggplot2.tidyverse.org/reference/geom_smooth.html

################
##### Theme ####
################
thm <-  theme(axis.title.x = element_text(face="bold", size=12),
              axis.title.y = element_text(face="bold", size=10),
              axis.text.x  = element_text(angle=0, vjust=0.5, size=10, face="bold"),
              axis.text.y  = element_text(hjust=0.5, size=10, face="bold"))


#### Readable Date ####
p <- ggplot(BLS_df, aes(date, PC_1month))
p + scale_x_date(date_labels = "%b'%y", breaks='6 month', minor_breaks = "1 month") +
  geom_smooth(method = lm, formula = y ~ splines::bs(x, 8), se = FALSE, color="darkred") + 
  geom_point(aes(size=abs(PC_1month)), color="blue3", fill="deepskyblue", alpha=0.7, shape = 21) +
  geom_hline(yintercept=0, linetype="dashed", color = "grey40") +
  geom_line(color="grey40", linetype = "dashed") + thm + xlab("") +  ylab("1-Month Percent Change %")

## Dim: 900 x 500

#################
### Save Data ###
#################

#save(BLS_df, file="S:/SURV727_Fundamental_Computing_DataDisplay/Final_Project/Final_Paper/BLS_df.Rda")




