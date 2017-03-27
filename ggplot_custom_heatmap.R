# my answer to 
# http://stackoverflow.com/questions/40899554/r-ggplot2-adding-custom-text-to-legend-and-value-counts-on-sides-of-the-heat-ma/

graph <- read_csv(
"COMPANY      ,DOMAIN    ,REVIEW    ,PROGRESS
Company A    ,Service   ,Good      ,+
Company A    ,Response  ,Good      ,+
Company A    ,Delay     ,Very Good ,   
Company A    ,Cost      ,Poor      ,-
Company B    ,Service   ,Poor      ,-
Company B    ,Delay     ,Average  ,
Company B    ,Cost      ,Good      ,+
Company C    ,Service   ,Very Poor ,+
Company C    ,Cost      ,Average  ,")


ggplot() + 
  # moved aesthetics to the geom, if you keep them in the ggplot call,
  # you have to specify `inherit.aes = FALSE` in the rest of the geoms     
  geom_tile(data = graph,
            aes(x    = COMPANY, 
                y    = DOMAIN, 
                fill = REVIEW)) + 
  # changed from `geom_text` to `geom_point` with custom shapes
  geom_point(data = graph,
             aes(x     = COMPANY, 
                 y     = DOMAIN, 
                 shape = factor(PROGRESS, labels = c("Worse", "Better"))),
             size = 3) +
  # custom shape scale
  scale_shape_manual(name = "", values = c("-", "+")) +
  # calculate marginal totals "on the fly"
  # top total
  geom_text(data  = summarize(group_by(graph, COMPANY),
                              av_data  = length(!is.na(PROGRESS))),
            aes(x = COMPANY,
                y = length(unique(graph$DOMAIN)) + 0.7,
                label = av_data)) + 
  # right total
  geom_text(data  = summarize(group_by(graph, DOMAIN),
                              av_data  = length(!is.na(PROGRESS))),  
            aes(x = length(unique(graph$COMPANY)) + 0.7, 
                y = DOMAIN, label = av_data)) + 
  # expand the plotting area to accomodate for the marginal totals
  scale_x_discrete(expand = c(0, 0.8)) + 
  scale_y_discrete(expand = c(0, 0.8)) +
  # horizontal lines
  geom_segment(aes(y    = rep(0.5, 1 + length(unique(graph$COMPANY))),
                   yend = rep(length(unique(graph$DOMAIN)) + 0.5,
                              1 + length(unique(graph$COMPANY))),
                   x    = seq(0.5, 1 + length(unique(graph$COMPANY))),
                   xend = seq(0.5, 1 + length(unique(graph$COMPANY))))) + 
  # vertical lines
  geom_segment(aes(x    = rep(0.5, 1 + length(unique(graph$DOMAIN))),
                   xend = rep(length(unique(graph$COMPANY)) + 0.5, 
                              1 + length(unique(graph$DOMAIN))),
                   y    = seq(0.5, 1 + length(unique(graph$DOMAIN))),
                   yend = seq(0.5, 1 + length(unique(graph$DOMAIN))))) + 
  
  # custom legend order
  guides(fill  = guide_legend(order = 1), 
         shape = guide_legend(order = 2)) +
  # theme tweaks
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line        = element_blank(),
    axis.ticks       = element_blank(),
    panel.background = element_blank(),
    plot.background  = element_blank(),
    axis.title       = element_blank(),
    axis.text.x = element_text(angle = 45,
                               size  = 12,
                               hjust =  1,
                               # move text up 20 pt
                               margin = margin(-20,0,0,0, "pt")),
    # move text right 20 pt
    axis.text.y = element_text(margin = margin(0,-20,0,0, "pt"))
  )
