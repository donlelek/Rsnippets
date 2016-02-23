#### Extract weather info from tutiempo.net
#### adapted from:
#### http://yihui.name/en/2010/10/grabbing-tables-in-webpages-using-the-xml-package/

## Variables:
## T   Average Temperature (°C)
## TM  Maximum temperature (°C)
## Tm  Minimum temperature (°C)
## SLP Atmospheric pressure at sea level (hPa)
## H   Average relative humidity (%)
## PP  Total rainfall and / or snowmelt (mm)
## VV  Average visibility (Km)
## V   Average wind speed (Km/h)
## VM  Maximum sustained wind speed (Km/h)
## VG  Maximum speed of wind (Km/h)
## RA  Indicates whether there was rain or drizzle
## SN  Indicates if it snowed
## TS  Indicates whether there storm
## FG  Indicates whether there was fog

## Stations:
## pmc = ws-857990
## scl = ws-855740

library(XML)   # for readHTMLTable
library(dplyr) # general data manipulation

setwd("~/Downloads/")

# loop through year and month
for (y in 1980:2015){
  # `formatC` sets a fixed width for month
  for (m in formatC(1:12, width = 2, flag = "0")) {
  month  <- readHTMLTable(
    # variables m and y replace cycle through month and year respectively
    # las portion of URL codes for the weather station
    paste0("http://en.tutiempo.net/climate/", m, "-", y, "/ws-855740.html"),
    # had to specify the data types to work properly
    colClasses = c("numeric", "numeric", "numeric", "numeric",
                   "numeric", "numeric", "numeric", "numeric",
                   "numeric", "numeric", "numeric", "character",
                   "character", "character", "character"),
    # don't convert strings to a factor
    stringsAsFactors = FALSE,
    # specifies which table in the URL has to extracted
    which = 1) %>%
    # add month and year as variables in the data frame
    # and remove empty rows and monthly summaries
    mutate(month = m, year = y) %>%
    filter(!is.na(Day))

  # print is not necessary but is encouraging to watch
  # data flooding your screen
  print(month)

  # this writes a new file for the first month of the first year
  if (m == "01" & y == 1980){
    write.table(month, "weather_data_scl.txt", row.names = FALSE)
    # the subsequent queries will be appended to the file created in the
    # previous step
    } else {
    write.table(month, "weather_data_scl.txt", row.names = FALSE,
                append = TRUE, col.names = FALSE)
    }
  }
}

## Read the data I just extracted from tables from web pages!
weather.pmc <- read.table("weather_data_pmc.txt",
  header = TRUE, stringsAsFactors = FALSE)

weather.scl <- read.table("weather_data_scl.txt",
  header = TRUE, stringsAsFactors = FALSE)
