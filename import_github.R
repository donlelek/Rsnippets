library(RCurl)
library(dplyr)
library(ggplot2)
library(tidyr)

# Not sure why... but I have to getURL before assignment to a tbl_df
x <- getURL("https://raw.githubusercontent.com/cmrivers/ebola/master/country_timeseries.csv")
ts <- tbl_df(read.csv(text = x))

# reshape dataset to long format to plot
cases <- ts %>%
  gather(., "C", "N", 3:18) %>%
  separate(., C, c("Type", "Country"), sep = "_") %>%
  filter(N != "NA") 

#plot the results
qplot(data   = cases,
      x      = Day,
      y      = N,
      color  = Country,
      group  = Country,
      facets = . ~ Type,
      geom   = "line")