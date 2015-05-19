library(readxl)
library(ggplot2)
library(dplyr)

# source:
# http://www.fda.gov/AnimalVeterinary/ScienceResearch/ToolsResources/Phish-Pharm/default.htm
phish <- read_excel("~/Dropbox/Datasets/Phish-PharmDB2014-11-24-2014.xls")

phish %>% 
  select(`Ave Water temp (°C)`, `t1/2-hr`, Drug) %>% 
  filter(Drug == "Oxytetracycline" | Drug == "Florfenicol") %>%
  qplot(x = `Ave Water temp (°C)`,
        y = log(`t1/2-hr`),
        ylab = "Log of Half life",
        color = Drug,
        data = .)
