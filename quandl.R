# install.packages("Quandl")
library(Quandl)
library(dplyr)

price <- tbl_df(Quandl("INDEXMUNDI/COMMODITY_FISHSALMON"))
qplot(  y    = price$US,
	ylab = "US Dollars per Kilogram",
	x    = Month,
	data = price,
	geom = "line")