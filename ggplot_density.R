#### plot spatial density with ggplot
library(ggplot2)
library(ggfortify)
library(maptools) # for the density function

# generate a dataframe for plotting
df <- data.frame(x = runif(500), y = rnorm(500))

# generate a density object
df.ppp <- as(SpatialPoints(df), "ppp")
Dens <- density(df.ppp, adjust = 0.5)
# default plot
plot(Dens)


# now extract the values to a data.frame
library(dplyr)
library(tidyr)

j <- as.data.frame(Dens$v) %>% 
  # get the y coordinates
  mutate(y = Dens$yrow) %>%
  # reshape to long and drop the extra variable
  gather("v", "value", 1:128) %>% 
  dplyr::select(-v) %>% 
  # sort by y and combine with x values
  arrange(y) %>% 
  mutate(x = rep(Dens$xcol, times = 128))

# and plot the results
ggplot(data = j, 
       aes(x = x, y = y, fill = value)) +
  # plot data to raster
  geom_raster() +
  # cool color
  scale_fill_distiller(palette = "Spectral")
