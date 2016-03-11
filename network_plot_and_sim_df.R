library("igraph")

# simulate dataset with three columns: from, to, weight
set.seed(1828)
mov <- data.frame(from   = sample(LETTERS[1:10], 50, replace = TRUE, prob = runif(10)),
                  to     = sample(LETTERS[1:10], 50, replace = TRUE, prob = runif(10)),
                  weight = 30*runif(50))

# Load (DIRECTED) graph from data frame 
g <- graph.data.frame(mov[1:3], directed=TRUE)

# Plot graph
plot(g,
     vertex.shape = "circle",
     vertex.frame.color = "SkyBlue2",
     vertex.size = g[3],
     vertex.label.cex = 0.8,
     edge.curved = F,
     edge.arrow.size = 0.3)

# 3D plot
library(rgl)

rglplot(g,
        vertex.size = g[3]) 
