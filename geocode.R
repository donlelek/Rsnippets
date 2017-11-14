library(ggmap)

x <- data.frame(place   = c("university", 
                            "mall"),
                address = c("550 University Avenue, PE, Canada", 
                            "Charlottetown Mall, PE, Canada"),
                stringsAsFactors = FALSE) %>%
  mutate_geocode(address, 
                 source = "google",
                 output = "more")

ggmap(get_map(x[,3:4], zoom = 15),
      base_layer = ggplot(data = x, aes(y = lat, x = lon))) +
  geom_point()