# source http://davetang.org/muse/2013/09/09/combinations-and-permutations-in-r/

#install if necessary
install.packages('gtools')

#load library
library(gtools)

#variables to combine
x <- c("`i1'","`i3'","`i4'","`i5'","`i6'","`i8'","`i9'","`i10'")
#pick r terms from n variables without replacement
#get all permutations
perm <- permutations(n=3,r=2,v=x,repeats.allowed=FALSE)
print(perm)
nrow(perm)

#get all combinations
comb <- combinations(n=8,r=4,v=x,repeats.allowed=FALSE)
print(comb)

