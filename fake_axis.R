# my answer to 
# http://stackoverflow.com/questions/39856318/colour-axis-labels-or-draw-rectangles-over-axis-in-ggplot2
# OP wants to extend rectagles over left axis, 
# I proposed to fake it in the desired position

library(ggplot2)
library(ggdendro)

x <- as.matrix(scale(mtcars))
dd.row <- as.dendrogram(hclust(dist(t(x))))

ggdendrogram(dd.row, rotate = TRUE, theme_dendro = FALSE) +
  labs(x="", y="Distance") +
  ggtitle("Mtcars Dendrogram") + 
  theme(panel.border = element_rect(colour = "black", fill=NA, size=.5), 
        axis.text.x=element_text(colour="black", size = 10), 
        axis.text.y=element_text(colour="black", size = 10),
        legend.key=element_rect(fill="white", colour="white"),
        legend.position="bottom", legend.direction="horizontal", 
        legend.title = element_blank(),
        panel.grid.major = element_line(colour = "#d3d3d3"), 
        panel.grid.minor = element_blank(), 
        panel.border = element_blank(), 
        panel.background = element_blank(),
        plot.title = element_text(size = 14, family = "Tahoma", face = "bold"), 
        text=element_text(family="Tahoma")) +
  # my answer starts here
  annotate("rect", xmin = 0.6, xmax = 5.4,  ymin = -1, ymax = 6.4, fill="red", colour="red", alpha=0.1) +
  annotate("rect", xmin = 5.6, xmax = 7.4,  ymin = -1, ymax = 6.4, fill="blue", colour="blue", alpha=0.1) +
  annotate("rect", xmin = 7.6, xmax = 11.4, ymin = -1, ymax = 6.4, fill="orange", colour="orange", alpha=0.1) +
  geom_hline(yintercept = 6.4, color = "blue", size=1, linetype = "dotted") +
  theme(axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank()) + 
  geom_text(aes(y = 0, x = 1:11, 
                label = c("carb", "wt", "hp", "cyl", "disp", "qsec", "vs", "mpg", "drat", "am", "gear")),
            hjust = "right",
            nudge_y = -.1)
