# my answer to:
# http://stackoverflow.com/questions/36637545/how-to-create-legend-continuous-colourbar-based-on-specific-range-of-values-in
# data available
# https://drive.google.com/file/d/0ByY3OAw62EShOG44MUtJeGFxeU0

library(scales)
library(ggplot2)
library(raster)
library(dplyr)

myKrige_new <- read.csv("~/Downloads/myKrige_new.csv")[-1]

# get the range of values to plot  
range(myKrige_new$LON) 
range(myKrige_new$LAT)

# Original skorea data transformed the same was as myKrige_new
skorea1 <- getData("GADM", country = "KOR", level = 1)
skorea1 <- fortify(skorea1)  
myKorea1 <- data.frame(skorea1)

# get the range of predicted values
summary(myKrige_new$pred)

# plot the map
ggplot() + 
  theme_minimal() +
  # mutated predictions, values above 200 become 200 now
  stat_summary_2d(data = mutate(myKrige_new,
                                pred = ifelse(pred > 200, 200, pred)),
                  aes(x = LON, y = LAT, z = pred),
                  bins = 30,
                  binwidth = c(0.05,0.05)) +
  scale_fill_gradientn(colours = c("white","blue","green","yellow","red"),
                       values  = rescale(c(0,50,100,150,200)),
                       name    = expression(paste(PM[10], group("[",paste(mu,g/m^3), "]"))),
                       # adding limits and breaks gets you there 
                       limits  = c(0,200),
                       breaks  = seq(0,200, 20),
                       # moved guide_colorbar to within the scale_fill
                       guide   = guide_colorbar(nbin = 20, # optional
                                                barwidth = 27,
                                                title.position = "bottom",
                                                title.hjust = 0.5,
                                                # raster = FALSE creates the boxes
                                                raster = FALSE,
                                                ticks = FALSE)) + 
  # changed to coord equal to keep map proportions
  coord_equal(xlim = c(126.6, 127.2),
              ylim = c(37.2 ,37.7)) +
  scale_y_continuous(expand = c(0,0)) +
  scale_x_continuous(expand = c(0,0)) +
  labs(title = "PM10 Concentration in Seoul Area at South Korea",
       x     = "",
       y     = "") +
  theme(legend.position = "bottom") +
  annotate("text",
           label = "PM[10]~group('[', mu*g/m^3, ']')*':'*2012/03/28/23*'~'*KST",
            x = 127,
            y = 37.5,
            parse = TRUE,
            size = 6,
            colour = "black",
            fontface = "bold")
