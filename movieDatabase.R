library(dplyr)
library(RSQLite)
library(RSQLite.extfuns)

# Set up handles to database tables on app start
db <- src_sqlite("~/Dropbox/Datasets/movies.db")
omdb <- tbl(db, "omdb")
tomatoes <- tbl(db, "tomatoes")

# Join tables, filtering out those with <10 reviews, and select specified columns
all_movies <- inner_join(omdb, tomatoes, by = "ID") %>%
    select(ID, imdbID, Title, Year, Rating_m = Rating.x, Runtime, Genre, Released,
           Director, Writer, imdbRating, imdbVotes, Language, Country, Oscars,
           Rating = Rating.y, Meter, Reviews, Fresh, Rotten, userMeter, userRating, userReviews,
           BoxOffice, Production)

movies <- tbl_df(data.frame(all_movies))
