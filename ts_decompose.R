library(tidyverse)
library(lubridate)
setwd("/Users/dprice/Documents/GIT/fallow-srs")
fallow.data <- read_csv("data/fallow_data.csv", na = c("NA", "NaN"),
col_types = list(siep       = col_character(),
unique.id  = col_character(),
acs.id     = col_character(),
number     = col_double(),
number.new = col_double()))

library("TTR")
fal  <- fallow.data %>% filter(species == "Salar", region.id == "Los lagos") %>% select(cal.week, mort.tot.num, number.new) %>% mutate(year = year(cal.week), month = month(cal.week)) %>% group_by(year, month) %>% summarise(mort = sum(mort.tot.num, na.rm = T) / sum(number.new + mort.tot.num, na.rm = T))
fal.ts  <- ts(fal$mort, frequency = 12, start = c(2009,1))
plot(fal.ts)
fal.comps  <- decompose(fal.ts)
plot(fal.comps)
