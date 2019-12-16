


#########################
### Import Index Data ###
#########################
load('S:/SURV727_Fundamental_Computing_DataDisplay/Final_Project/Amazon/Data/data_index.Rda')
head(data_index)

library(tidyverse)


## Exclucing the Base index date 11-30 to calculate the summary stats 
df0 <- data_index %>%
  filter(Date1 > "2019-10-30", Date1 <= "2019-11-30") %>% 
  select(Date1, Day1, L_IX, P_IX, G_IX, F_IX, T_IX, Unwgt_IX, IX_type, n_matched) 


## Proxy_wgt Only
df1 <- data_index %>%
  filter(IX_type == 	"Proxy_wgt", Date1 > "2019-10-30", Date1 <= "2019-11-30")  %>% 
  select(Date1, Day1, L_IX, P_IX, G_IX, F_IX, T_IX, Unwgt_IX, n_matched) 

### Long format ###
df0_long <- gather(df0, key=Index, value = Percent_Change, L_IX:Unwgt_IX)
### Wide format ###
df0_wide <- spread(df0_long, key=IX_type, value = Percent_Change)


df1_long <- gather(df1, Index, Percent_Change, L_IX:Unwgt_IX)
df0_long <- df0_long %>% mutate(IX_type_wgt = interaction(Index, IX_type, sep = "_"))

names(df0)


#######################
### Pairwise T-test ###
#######################
names(df0_wide)
nrow(df0_wide)
# L_IX, P_IX, G_IX, F_IX, T_IX,
df0_wide1 <- df0_wide %>% filter(.,Index=="T_IX")

t.test(df0_wide1$Proxy_wgt, df0_wide1$Popularity_Adj_Proxy_wgt, paired = TRUE, conf.level = 0.95, alternative = "greater")

wilcox.test(df0_wide1$Proxy_wgt, df0_wide1$Popularity_Adj_Proxy_wgt, paired = TRUE, alternative = "greater") # alternative = "two.sided"



##########################
### Summary Statistics ###
##########################
df0_long3 <- data_index %>%
  filter(Date1 > "2019-10-30", Date1 <= "2019-11-30") %>% 
  select(Date1, Day1, L_IX, P_IX, G_IX, F_IX, T_IX, Unwgt_IX, IX_type, n_matched) %>%
  rename(., Laspeyres=L_IX, Paasche=P_IX, Geo_means=G_IX, Fisher=F_IX, Tornqvist=T_IX, Unweighted=Unwgt_IX) %>%
  gather(., key=Index, value = Percent_Change, Laspeyres:Unweighted)

####################################
### Used in the R-Markdown Paper ###
####################################
df3 <- df0_long3 %>% group_by(Index, IX_type) %>%
  summarise(Mean = round(mean(Percent_Change), 3), SD = round(sd(Percent_Change), 3), SE=round(sd(Percent_Change)/sqrt(n()), digits = 3), n = n()) 


################################## 
## This data has more variables ##
#################################
df3 <- df0_long3 %>% group_by(Index, IX_type) %>%
  summarise(n_Index = n(), Mean = round(mean(Percent_Change), 3), Variance = round(var(Percent_Change), 3), SD = round(sd(Percent_Change), 3), SE=round(sd(Percent_Change)/sqrt(n()), digits = 3), Mean_n_matched=round(mean(n_matched),digits = 0)) 



#######################
###     Graphs     ###
#######################

####################
###   Boxplot    ###
####################

## Exclucing the Base index date 11-30 to calculate the summary stats 
df0 <- data_index %>%
  filter(Date1 > "2019-10-30", Date1 <= "2019-11-30") %>% 
  select(Date1, Day1, L_IX, P_IX, G_IX, F_IX, T_IX, Unwgt_IX, IX_type, n_matched) 

### Long format ###
df0_long <- gather(df0, key=Index, value = Percent_Change, L_IX:Unwgt_IX) %>% mutate(IX_type_wgt = interaction(Index, IX_type, sep = "_"))

## Arrange dataset so boxplot is ordered specific way 
df0_long2 <- df0_long %>% 
  mutate(IX_type_wgt = interaction(Index, IX_type, sep = "_")) %>% 
  arrange(desc(Index, IX_type))



## outline box colored
p <- ggplot(df0_long2, aes(x=factor(IX_type_wgt, levels=unique(IX_type_wgt)), y=Percent_Change, fill=IX_type_wgt)) + stat_boxplot(geom = "errorbar", width = 0.3, aes(color=Index)) + 
  geom_boxplot(aes(fill=Index, color=Index), outlier.shape = 1, fill = "white") +
  stat_summary(fun.y=mean, geom="point", aes(colour=Index),size=1.3) 

p + coord_flip() + 
  theme(axis.title.x = element_text(face="bold", size=10),
        axis.title.y = element_text(face="bold", size=10),
        axis.text.x  = element_text(angle=0, vjust=0.5, size=8, face="bold"),
        axis.text.y  = element_text(hjust=1, size=8, face="bold"),
        legend.position = "none") +
  xlab("") + scale_y_continuous() +
  ylab("Daily Percent Change Index (Oct 31 to Nov 30)")
# ...\n
# Dim: 570  270

