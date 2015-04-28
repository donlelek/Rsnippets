# befor installing tmaps have to install rgdal and rgeos
# instructions for OSX (from: https://stackoverflow.com/questions/15248815/rgdal-package-installation/26836125#26836125)
# in a terminal type: brew install --with-postgresql gdal
# in R type: install.packages('rgdal', type = "source", configure.args=c('--with-proj-include=/usr/local/include','--with-proj-lib=/usr/local/lib'))
# and then: install.packages('rgeos')
# now proceed with:

# install.packages('tmap')
# source: http://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html

library(tmap)
data("World")

qtm(World[World$continent=="South America",],
    fill="gdp_cap_est",
    text="iso_a3",
    text.cex="AREA",
    root=5,
    title="GDP per capita")

data(rivers)
data(cities)

tm_shape(World[World$continent=="South America",],
                  projection = "longlat") +
  tm_fill(c("pop_est_dens","gdp_cap_est"),
          style = "pretty",
          palette = "Spectral") +
  tm_borders(lwd=0) +
  tm_shape(rivers) +
  tm_lines("dodgerblue3") +
  tm_shape(cities) +
  tm_text("name",
          cex="pop_min",
          scale=1,
          ymod=-.02,
          root=4,
          bg.alpha = .5) +
  tm_bubbles("pop_max",
             "red",
             border.lwd=0,
             alpha = .5,
             size.lim = c(0, 11e6),
             sizes.legend = seq(2e6,10e6, by=2e6)) +
  tm_layout_World(title = c("Density","GDP"), 
                  asp = 1,
                  bg.color = "white",
                  legend.position = c("left","bottom"),
                  legend.titles = c(fill = c("Density","GDP"), 
                                    bubble.size="Population"))

