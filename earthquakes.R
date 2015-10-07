####### Earthquake dataset ######
# obtained from USGS with this search:
# http://earthquake.usgs.gov/fdsnws/event/1/query.csv?starttime=1900-01-01%2000:00:00&minmagnitude=6&endtime=2015-09-22%2023:59:59&orderby=time
# this search retrieves every quake of a 6+ magnitude since 1950 ~10800 obs
# 
# For a glossary of the columns:
# http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php
# magtype: The method or algorithm used to calculate the preferred magnitude for the event.
# nst: The total number of Number of seismic stations which reported P- and S-arrival times for this earthquake.
# gap: The largest azimuthal gap between azimuthally adjacent stations (in degrees). In general, the smaller this number, the more reliable is the calculated horizontal position of the earthquake.
# dmin: Horizontal distance from the epicenter to the nearest station (in degrees). 1 degree is approximately 111.2 kilometers. In general, the smaller this number, the more reliable is the calculated depth of the earthquake.
# rms: The root-mean-square (RMS) travel time residual, in sec, using all weights. This parameter provides a measure of the fit of the observed arrival times to the predicted arrival times for this location. Smaller numbers reflect a better fit of the data. The value is dependent on the accuracy of the velocity model used to compute the earthquake location, the quality weights assigned to the arrival time data, and the procedure used to locate the earthquake.
# net:The ID of a data contributor. Identifies the network considered to be the preferred source of information for this event.

# you can install any of this using install.packages("name_of_library")
# loading data manipulation/visualization libraries
library(RCurl)
library(readr)
library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2)
# extra library to parse iso8601 dates
library(parsedate)
library(stringi)


# first read the dataset (point this to where you saved your dataset)
quakes <- read_csv("~/Dropbox/Datasets/M6.0plus1900_20150922.csv") #doesn't pick up the date formats

# force data types with `col_types`
quakes <- read_csv("~/Dropbox/Datasets/M6.0plus1900_20150922.csv", col_types = "cddddcidddccccc")

# or better still, grab directly from the USGS server
quakes <- getURL("http://earthquake.usgs.gov/fdsnws/event/1/query.csv?starttime=1900-01-01%2000:00:00&minmagnitude=6&endtime=2015-09-22%2023:59:59&orderby=time") %>% 
  read_csv(., col_types = "cddddcidddccccc")


# transform dates from character to posix (...slow)
quakes %<>% 
  mutate(time    = parse_iso_8601(time),
         updated = parse_iso_8601(updated))

# the top 10
quakes %>% 
  arrange(desc(mag)) %>% 
  select(mag, time, place) %>% 
  head(., n = 10)

# ok, but I want names of the countries
# using colon as separator; 
# if extra colon merge, 
# if no colon, fill with left side
quakes %<>%
  separate(place,
           c("place", "country"),
           extra = "merge",
           fill = "left",
           sep = ",")


# clean country
quakes %<>%
  mutate(country = ifelse(country == " ", place, country),
         country = replace(country, is.na(country), place),
         country = stri_trim_both(country))
                   
dput(sort(unique(quakes$country)))

# counts by country
quakes %>% 
  group_by(country) %>% 
  tally() %>% 
  arrange(desc(n)) %>% 
  View()

# or counts of quakes over mag 8
quakes %>% 
  group_by(country) %>% 
  filter(mag > 8) %>% 
  tally() %>% 
  arrange(desc(n)) %>% 
  View()


# a map
library(leaflet)
leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = quakes,
                   lng = ~longitude,
                   lat = ~latitude,
                   radius = (quakes$mag^2)/10,
                   stroke = FALSE,
                   fill = TRUE,
                   fillColor = "red",
                   fillOpacity = 0.4,
                   popup = paste0(quakes$time, " - ",
                                  quakes$place, " - ",
                                  quakes$mag))
