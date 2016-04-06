# my answer to: 
# http://stackoverflow.com/questions/36450278/summarize-with-dplyr-other-then-groups/36463525#36463525

# set up a toy data.frame
df <- data_frame(
  group = c('a', 'a', 'b', 'b', 'c', 'c'),
  value = c(1, 2, 3, 4, 5, 6)
)

# result 
res <- df %>%
  group_by(group) %>%
  # get a median by group
  summarise(median_ = median(value)) %>%
  # leave the current observation out using `combn` on the reversed 
  # vector that contains the median
  mutate(med_other = combn(rev(median_), n()-1, FUN = median),
         # and finally lag the result to get the median of the
         # preceeding group
         med_before = lag(median_))

res

# combn gives all possible combinations of a vector
combn(1:3, 2)

# using the reversed vector we get the current value omitted
combn(rev(1:3), 2)
