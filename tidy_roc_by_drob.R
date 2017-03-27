library(tidyverse)

roc <- iris %>% 
  gather(Metric, Value, -Species) %>% 
  mutate(Positive = Species == "virginica") %>% 
  group_by(Metric, Value) %>% 
  summarize(Positive = sum(Positive),
            Negative = n() - sum(Positive)) %>% 
  arrange(-Value) %>% 
  mutate(TPR = cumsum(Positive) / sum(Positive),
         FPR = cumsum(Negative) / sum(Negative))

auc <- roc %>% 
  group_by(Metric) %>% 
  summarize(AUC = sum(diff(FPR) * na.omit(lead(TPR) + TPR)) / 2)

ggplot(roc, aes(FPR, TPR, color = Metric)) +
  geom_step() +
  geom_abline(lty = 2) +
  labs(title   = "ROC at predicting Virginica iris species",
       x       = "False positive rate (1-specificity)",
       y       = "True positive rate (sentitivity)",
       caption = "source: https://twitter.com/drob/status/803635156841943040") +
  coord_equal() +
  scale_color_manual(name = "AUC", 
                     values = rev(viridis::viridis(n = 4, end = .8)),
                     labels = paste(auc$Metric, " - ", auc$AUC)) +
  theme_minimal() +
  theme(plot.caption = element_text(size = 8),
        legend.position = c(.85, .15),
        panel.border = element_rect(color = "gray", fill = NA))
