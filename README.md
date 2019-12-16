SURV727Project

## Description of each R Program and what is does  ##


Step1_Webscrape_Laptop_Data.Rmd: 
This program connects to Amazon website and scrapes the data of
100 best laptops using a loop. It uses various data wrangling techniques and string functions to manipulate
the list object, and to make it ready for analysis. Finally, it saves the data object to be used in the subsequent
steps.

Step2_InnerJoin_Datasets_Compute_Index.Rmd: 
This program matches the samples of laptops from any
2 periods (current and previous) and computes the percent change indexes based on the formulas of price
theory. All formulas are coded with automation (no packages are used). It also computes the adjustment
and calibration factors to incorporate the popularity ratings of laptops into the proxy weight. And finally it
appends the daily price index into previously saved data.

Step1.5_InnerJoin_Datasets_Compute_Index_BasePeriod.Rmd: 
This program is replicated from Step2
except it is customized to run only once for the base period when the index relative is set to 1 and percent
change is 0. It saves the first dataset that is being appended daily by new percent change index.
5

Step3_InnerJoin_Compute_Monthly_Change.Rmd: 
This program is also replicated from Step2 except it is
customized to run and compute a 1-month percent change between October (base) and November (current).
This monthly index enables to compare with BLS monthly index.

Step4_Data_Visual.R: 
This program produces various plots using ggplot2.

Step5_Shiny_App.R: 
This program is the Shiny App with advanced features that is currently on the public
server for users (https://hlpgomes.shinyapps.io/priceindex/).

Step6_dygraph.Rmd: 
This program generates JavaScript style interactive plot, embedded into HTML. This
could be shared with the clients to inspect the price index data interactively.

Step7_StatisticalAnalysis.R: 
This program conducts statistical analysis such as descriptive statistics, as well
as inferential statistics with pairwise t-test and Wilcoxson signed rank test.

Step8_CPI_Index_Laptop.R 
This program pulls the data directly from the website, BLS public release
repository, and computes the percent change index for EE01 Item Strata, “Personal computers and peripheral
equipment.”.

Step9_TimeSeries.R 
This program implements Times Series methodology, such as autocorrelation function
and decomposition function to the daily index dataset.
