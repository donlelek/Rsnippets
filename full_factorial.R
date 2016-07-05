# http://stats.stackexchange.com/questions/208273/diagnostics-for-mixed-model-from-pre-post-design

library(tidyr)
library(dplyr)
library(lme4)

data <- read.csv("http://pastebin.com/raw/G4D8dh1f")

# reorder data
data_wide  <- data %>% 
  spread(time, undamaged_area) %>% 
  separate(specimen_id, c("mat", "id", "tx")) %>% 
  mutate(damage = before - after, 
         unique_id = paste(mat, id, sep = "_")) %>% 
  select(-mat, -tx, -id)

# model for full factorial with replications
mm2  <- lm(damage ~ material * treatment , data = data_wide)

# model for id as blocking 
mm3 <- lmer(damage ~ material * treatment + (1 | unique_id), data = data_wide)

# ANOVA
anova(mm2)
anova(mm3)

# Residuals diagnostics
qqnorm(residuals(mm2, type = "pearson"))
# Shotgun blast!
plot(fitted(mm2), residuals(mm2, type = "pearson"))

# table with average and variance by group
data_wide %>%
  group_by(material, treatment) %>% 
  summarise(avg_dmg = mean(damage), 
            var_dmg = var(damage)) %>% 
  knitr::kable(digits = 1)

# suggestions for unequal variances
# http://stats.stackexchange.com/questions/56971/alternative-to-one-way-anova-unequal-variance
