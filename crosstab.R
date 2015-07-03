# Crosstab of two categorical variables populated by a third summarized one
# from:
# http://stackoverflow.com/questions/31100579/how-to-do-a-crosstab-with-two-categorical-variables-but-populate-it-with-the-mea?sgp=2
# I like the dplyr approach, added the last line to output a markdown table

library(ggplot2)
library(dplyr)
library(tidyr)

diamonds %>%
  group_by(cut, color) %>%
  summarise(price = mean(price)) %>%
  spread(color, price) %>% 
  knitr::kable()
