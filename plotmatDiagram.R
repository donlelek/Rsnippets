# Diagrams in R with plotmat
# source: http://stackoverflow.com/questions/27107183/matrix-specification-for-simple-diagram-using-diagram-package

library(diagram)

connect <- c(0,0,0,0,
             0,0,0,0,
             1,1,0,1,
             0,0,0,0)

M <- matrix(nrow=4, ncol=4, byrow=TRUE, data=connect)
p <- plotmat(M, pos=c(1, 2, 1), name='', box.col="lightblue", curve=0)