##----generate 3 years by day starting in 2000-01-01-------
library(zoo)
x <- ts(rnorm(1095),st = 2000, freq = 365)
y <- zooreg(coredata(x), as.Date("2000-01-01"))
index(y)
