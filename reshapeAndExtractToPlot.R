# my answer to:
# http://stackoverflow.com/questions/38966607/having-trouble-plotting-multiple-data-sets-and-their-confidence-intervals-on-the

library(readr)    
library(ggplot2)
library(tidyr)
library(stringi)
library(dplyr)

df.combined <- data_frame(
  MLSupr = c(1.681572, 3.363144, 5.146645, 6.930146, 8.713648, 10.497149, 12.280651, 14.064152, 15.847653, 17.740388, 19.633122, 21.525857, 23.535127, 25.544397, 27.553667, 29.562937, 31.572207, 33.581477, 35.590747, 37.723961), 
  MLSpred = c(1.392213, 2.784426, 4.232796, 5.681165, 7.129535, 8.577904, 10.026274, 11.474644, 12.923013, 14.429805, 15.936596, 17.443388, 19.010958, 20.578528, 22.146098, 23.713668, 25.281238, 26.848807, 28.416377, 30.047177), 
  MLSlwr = c(1.102854, 2.205708, 3.318946, 4.432184, 5.545422, 6.65866, 7.771898, 8.885136, 9.998373, 11.119222, 12.240071, 13.360919, 14.486789, 15.612659, 16.738529, 17.864399, 18.990268, 20.116138, 21.242008, 22.370394), 
  BPLupr = c(1.046068, 2.112885, 3.201504, 4.368555, 5.480557, 6.592558, 7.681178, 8.924067, 10.125539, 11.327011, 12.620001, 13.821473, 15.064362, 16.307252, 17.600241, 18.893231, 20.245938, 21.538928, 22.891634, 24.313671), 
  BPLpred = c(0.8326201, 1.698825, 2.5999694, 3.614618, 4.5521112, 5.4896044, 6.3907488, 7.4889026, 8.5444783, 9.6000541, 10.7425033, 11.798079, 12.8962328, 13.9943865, 15.1368357, 16.2792849, 17.4678163, 18.6102655, 19.7987969, 21.0352693), 
  BPLlwr = c(0.6191719, 1.2847654, 1.9984346, 2.8606811, 3.6236659, 4.3866506, 5.1003198, 6.0537381, 6.9634176, 7.873097, 8.8650055, 9.774685, 10.7281032, 11.6815215, 12.67343, 13.6653384, 14.6896948, 15.6816033, 16.7059597, 17.7568676))


# plot from original data
ggplot(data = df.combined, aes(x = 1:20)) +
geom_ribbon(aes(ymin = MLSlwr, ymax = MLSupr), 
            fill = "blue", alpha = 0.25) +
geom_line(aes(y = MLSpred), color = "black") +
geom_ribbon(aes(ymin = BPLlwr, ymax = BPLupr), 
            fill = "red", alpha = 0.25) +
geom_line(aes(y = BPLpred), color = "black")


# reshape data for better plot
tidy.data <- df.combined %>%
  mutate(id = 1:20) %>% 
  # reshape to long format
  gather("variable", "value", 1:6) %>% 
  # separate variable names at position 3
  # separate(variable, 
  #          into = c("model", "line"), 
  #          sep = 3L, 
  #          remove = TRUE)
  #          
  # replaced `separate` to split string by letter case instead of position 3
  rowwise() %>% 
  mutate(model = paste(stri_extract_all_regex(variable, "[[:upper:]]*")[[1]],
                       collapse = ""),
         line  = paste(stri_extract_all_regex(variable, "[[:lower:]]*")[[1]], 
                       collapse = "")) %>% 
  # added to drop variable when separate is replaced by mutate
  select(-variable)

# plot
ggplot(data = tidy.data, 
       aes(x = id, 
           y = value, 
           linetype = line, 
           color = model)) + 
  geom_line() + 
  scale_linetype_manual(values = c("dashed", "solid", "dashed"))

# Or keep using geom_ribbon
# back to wide
wide.data <- tidy.data %>% 
  spread(line, value)

# plot with ribbon
ggplot(data = wide.data, 
       aes(x = id, 
           y = pred)) +
  geom_ribbon(aes(ymin = lwr,
                  ymax = upr,
                  fill = model), 
              alpha = .5) +
  geom_line(aes(group = model))
