#### MRE to split facets of a plot into multiple pages ####

# set up a dataset to play with
df  <- data.frame(x = rnorm(1000),
                  y = rnorm(1000),
                  grp = sample(LETTERS, 1000, replace = TRUE))

# create a number of objects to 
# subset the groups pieces, many options to achieve this 
p1  <- LETTERS[1:9]
p2  <- LETTERS[10:18]
p3  <- LETTERS[19:26]

# open the pdf device, a lot of options here
pdf("file.pdf", paper = "letter")

# loop through the objects we created
for (i in list(p1, p2, p3)) {
  # progress indicator
  cat(".") 
  # print ggplot object
  print(
    # plot a subset of the data based on the "p" objects
    ggplot(data = filter(df, grp %in% i),
           aes(x = x, y = y)) +
      geom_point() +
      facet_wrap(~grp, ncol = 3)
  )
}
# close the pdf device
dev.off()


# Ta Daaa!!
