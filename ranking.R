##### A solution to this question:
##### http://stackoverflow.com/questions/33591515/transforming-reshaping-a-dataset-ranking-college-football-teams-for-the-last-5?noredirect=1#comment54961676_33591515


practice = data.frame('a'=character(), 'b'=character(), 'c'= numeric(), 'd'=character(), 'e'= numeric(), 'f'=character())
widths = c(10, 28, 5, 28, 3, 19)
years = 1960:2010
for (i in years){
  football_page = paste('http://homepages.cae.wisc.edu/~dwilson/rsfc/history/howell/cf', i, 'gms.txt',sep = '')
  get_data = read.fwf(football_page, widths)
  practice = rbind(practice, get_data)
}

heading = list('DATE', 'AWAY TEAM', 'AWAY SCORE', 'HOME TEAM', 'HOME SCORE', 'LOCATION')
colnames(practice) = heading


# Fixing season dates

practice = cbind('SEASON'=numeric(nrow(practice)),practice)
fix_date = matrix(0, nrow = nrow(practice))
for (j in 1:nrow(fix_date)){
  fix_date[j,1] = substr(practice[j,2],7,10)
}
fix_date = as.numeric(fix_date)
practice$SEASON = fix_date
for (j in 1:nrow(practice)){
  if (grepl('01/.......', practice[j,2]))
    practice[j,1] = practice[j,1]-1 
}


#fix names

practice[,3]=gsub(' ','',practice[,3])
practice[,5]=gsub(' ','',practice[,5])


#drop location and columns

practice = practice[, -7]
practice = practice[, -2]


###### Solution ######
library(dplyr)
library(tidyr)

practice_2 <- practice %>%
  mutate(home = `HOME TEAM`,
         away = `AWAY TEAM`) %>% 
  gather(LOC, TEAM, 6:7) %>% 
  group_by(SEASON, TEAM) %>%
  mutate(won  = ifelse(LOC == "home",
                       as.numeric(`HOME SCORE` >  `AWAY SCORE`),
                       as.numeric(`AWAY SCORE` >  `HOME SCORE`)),
         lost = ifelse(LOC == "home",
                       as.numeric(`HOME SCORE` <= `AWAY SCORE`),
                       as.numeric(`AWAY SCORE` <= `HOME SCORE`)),
         op = ifelse(LOC == "home", `AWAY TEAM`, `HOME TEAM`)) %>% 
  summarise(WINS   = sum(won, na.rm = TRUE),
            LOSSES = sum(lost, na.rm = TRUE),
            OPPONENTS = list(unique(op)))
