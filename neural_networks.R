#########
# source: 
# http://gekkoquant.com/2012/05/26/neural-networks-with-r-simple-example/
########

install.packages('neuralnet')
library("neuralnet")

#Going to create a neural network to perform sqare rooting
#Type ?neuralnet for more information on the neuralnet library

#Generate 50 random numbers uniformly distributed between 0 and 100
#And store them as a dataframe
traininginput <-  as.data.frame(runif(50, min=0, max=100))
trainingoutput <- sqrt(traininginput)

#Column bind the data into one variable
trainingdata <- cbind(traininginput,trainingoutput)
colnames(trainingdata) <- c("Input","Output")

#Train the neural network
#Going to have 10 hidden layers
#Threshold is a numeric value specifying the threshold for the partial
#derivatives of the error function as stopping criteria.
net.sqrt <- neuralnet(Output~Input,trainingdata, hidden=c(10,8), threshold=0.01)
print(net.sqrt)

#Plot the neural network
plot(net.sqrt)

#Test the neural network on some training data
testdata <- as.data.frame((1:10)^2) #Generate some squared numbers
net.results <- compute(net.sqrt, testdata) #Run them through the neural network

#Lets see what properties net.sqrt has
ls(net.results)

#Lets see the results
print(net.results$net.result)

#Lets display a better version of the results
cleanoutput <- cbind(testdata,sqrt(testdata),
                     as.data.frame(net.results$net.result))
colnames(cleanoutput) <- c("Input","Expected Output","Neural Net Output")
print(cleanoutput)


########################
# source: 
# https://beckmw.wordpress.com/2014/12/20/neuralnettools-1-0-0-now-on-cran/
########################

# install, load package
install.packages('NeuralNetTools')
library(NeuralNetTools)

# create model
library(neuralnet)
AND <- c(rep(0, 7), 1)
OR <- c(0, rep(1, 7))
binary_data <- data.frame(expand.grid(c(0, 1), c(0, 1), c(0, 1)), AND, OR)
mod <- neuralnet(AND + OR ~ Var1 + Var2 + Var3, binary_data,
                 hidden = c(6, 12, 8), rep = 10, err.fct = 'ce', linear.output = FALSE)

# plotnet
par(mar = numeric(4), family = 'serif')
plotnet(mod, alpha = 0.6)

# create model
library(RSNNS)
data(neuraldat)
x <- neuraldat[, c('X1', 'X2', 'X3')]
y <- neuraldat[, 'Y1']
mod <- mlp(x, y, size = 5)

# garson
garson(mod, 'Y1')

# create model
library(nnet)
data(neuraldat)
mod <- nnet(Y1 ~ X1 + X2 + X3, data = neuraldat, size = 5)

# lekprofile
lekprofile(mod)
