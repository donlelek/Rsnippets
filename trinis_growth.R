library(tidyverse)
library(lubridate)

statage <- read_csv("http://www.cdc.gov/growthcharts/data/zscore/statage.csv") %>% 
  filter(Sex == 2) %>% 
  select(-L, -M, -S, -Sex) %>%
  gather("perc", "height", 2:10)

statbaby <- read_csv("~/Dropbox/Datasets/lenageinf.csv")[-1] %>% 
  gather("perc", "height", 2:10) %>% 
  filter(Agemos < 24)
  
statlen <- bind_rows(statbaby, statage)
  
trini <- read_csv("~/Dropbox/Datasets/trini.csv") %>% 
  filter(!is.na(`LARGO(CM)`)) %>% 
  mutate(date = mdy(FECHA),
         height = `LARGO(CM)`,
         weight = `PESO(G)` / 1000,
         Agemos = (date - first(date))/30) %>% 
  select(date, Agemos, height, weight) %>% 
  gather("measure", "value", 3:4)
  





p <- ggplot(statlen, aes(Agemos, height)) +
  geom_line(aes(color = perc)) +
  geom_point(data = trini) +
  xlim(0, 125) +
  labs(title = "Trinidad's Growth Chart",
       x = "Age in months",
       y = "Height in cm",
       caption = "Reference Percentiles: CDC Growth Charts")

library(directlabels)
direct.label(p,"last.qp")

ggsave("~/Downloads/trini_growth.png", width = 9, height = 6)




statwt <- read_csv("http://www.cdc.gov/growthcharts/data/zscore/wtage.csv") %>% 
  filter(Sex == 2) %>% 
  select(-L, -M, -S, -Sex) %>%
  gather("perc", "weight", 2:10)

statwt <- read_csv("http://www.cdc.gov/growthcharts/data/zscore/wtageinf.csv") %>% 
