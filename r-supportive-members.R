# source = https://gist.github.com/renkun-ken/85aa6dff500196f82bb1

library(pipeR)
library(rlist)
library(httr)
library(rvest)
library(stringr)
 
Pipe("http://www.r-project.org/foundation/memberlist.html")$
  GET()$
  content("parsed")[
    xpath("//table[2]//td//text() | //table[3]//td//text()")]$
  list.mapv(XML::xmlValue(.))$
  str_trim()$
  str_match_all(".+\\s\\((.+)\\)")$ # select their nations
  list.rbind()[,2]$
  str_split(", ")$  # some members have multiple nationalities
  unlist()$
  table()$
  sort(decreasing = TRUE)$
  head(10)$
  barplot(main = "Where do R's supportive members mainly come from?")