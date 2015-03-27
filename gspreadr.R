# An API to access Google spreadsheets via R
# source: https://github.com/jennybc/gspreadr

library(gspreadr) ## Check that dplyr version is at least 0.4.0
suppressMessages(library("dplyr")) 

# get a list of the sheets you have access to (and authorize the library)
list_sheets()

# let's try the tutorial
gap_key <- "1HT5B8SgkKqHdqHJmn5xiuaC04Ngb7dG9Tv94004vezA"
copy_ss(key = gap_key, to = "GGapminder")
gap <- register_ss("GGapminder")
# Get the data for worksheet "Oceania": the super-fast csv way
oceania_csv <- gap %>% get_via_csv(ws = "Oceania")
head(oceania_csv)

# Now lets try with my own data
reg <- register_ss("Farm Visits") 
data <- reg %>% get_via_csv(ws = "Sheet1")
glimpse(data)
