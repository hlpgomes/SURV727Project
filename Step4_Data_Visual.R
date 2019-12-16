
#########################
### Import Index Data ###
#########################

load('S:/SURV727_Fundamental_Computing_DataDisplay/Final_Project/Amazon/Data/data_index.Rda')
head(data_index)
library(tidyverse)

df0 <- data_index %>%
  filter(Date1 <= "2019-12-03") %>%     #"2019-11-30"
  select(Date1, Day1, L_IX, P_IX, G_IX, F_IX, T_IX, Unwgt_IX, IX_type) %>%
  rename(., Laspeyres=L_IX, Paasche=P_IX, Geo_means=G_IX, Fisher=F_IX, Tornqvist=T_IX, Unweighted=Unwgt_IX)

### Long Format ###
df <- gather(df0, Index, PercentChange, Laspeyres:Unweighted) %>%
  filter(., IX_type=="Proxy_wgt")


#######################################
### Import Laptop Price Change Data ###
#######################################

load('S:/SURV727_Fundamental_Computing_DataDisplay/Final_Project/Amazon/Data/data_PC.Rda')
names(data_PC)
dt <- data_PC %>% 
  rename(., Percent_Change = PriceChange_prct) %>% 
  filter(Date1 <= "2019-12-03") #"2019-11-30"


###################
####   Graph   ####
###################

h2 <- dt %>% 
  ggplot(., aes(x = Date1, y=Percent_Change)) 

p1 <- h2 + 
  geom_point(aes(size=Count_Review1), color="deepskyblue", alpha=0.3) + scale_size_area(max_size = 4) + 
  geom_smooth(data=df, aes(x = Date1, y=PercentChange, group=Index, color=Index), method = "loess", se = FALSE) +  
  scale_x_date(date_labels = "%b %d", breaks='7 day', minor_breaks = "1 day") 

p2 <- h2 + 
  geom_point(aes(size=Count_Review1), color="deepskyblue", alpha=0.3) + scale_size_area(max_size = 4) + 
  geom_line(data=df, aes(x = Date1, y=PercentChange, group=Index, color=Index)) + 
    geom_smooth(aes(group = Product_Name, color=Product_Name), method = "loess", se = FALSE, show.legend = FALSE) + 
  geom_point(data=df, aes(x = Date1, y=PercentChange, group=Index, color=Index), alpha=0.7, size=1.3)  +
  scale_x_date(date_labels = "%b %d", breaks='7 day', minor_breaks = "1 day") + ylim(-4,4) 


p7 <- h2 + 
  geom_point(aes(size=Count_Review1), color="deepskyblue", alpha=0.3) + scale_size_area(max_size = 4) + 
  geom_smooth(data=df, aes(x = Date1, y=PercentChange, group=Index), method = lm, formula = y ~ splines::bs(x, 12), se = FALSE, color="grey65") +
  geom_line(data=df, aes(x = Date1, y=PercentChange, group=Index, color=Index)) +
  geom_point(data=df, aes(x = Date1, y=PercentChange, group=Index, color=Index), alpha=0.7, size=1.3)  +
  scale_x_date(date_labels = "%b %d", breaks='7 day', minor_breaks = "1 day") + ylim(-4,4)  



##### Theme ####
thm <-  theme(axis.title.x = element_text(face="bold", size=12),
              axis.title.y = element_text(face="bold", size=10),
              axis.text.x  = element_text(angle=0, vjust=0.5, size=10, face="bold"),
              axis.text.y  = element_text(hjust=0.5, size=10, face="bold"))

################

################
## All Graphs ##
################

p1+ ylim(-20,20) + thm + xlab("") +  ylab("Percent Change %")
# Dim: 670 400 
p2 + thm + xlab("") +  ylab("Percent Change %")
p7 + thm + xlab("") +  ylab("Percent Change %")


