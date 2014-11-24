# Text Mining: Basics
# source: http://www.listendata.com/2014/11/create-wordcloud-with-r.html
# Document is a whole paragraph or report. It can come in many formats such as txt, doc, PDF etc. For example, " Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal."
# Tokens represent words. For example:  "nation", "Liberty", "men".  
# Terms may represent single words or multiword units, such as “civil war”
# Corpus is a collection of documents (database). For example, A corpus contains 16 documents (16 txt files).

################ How to create wordcloud with R ##########################

# Step 1 : Install the required packages
install.packages("wordcloud")
install.packages("tm")
install.packages("ggplot2")
# Note : If these packages are already installed, you don't need to install them again.

# Step 2 : Load the above installed packages
library("wordcloud")
library("tm")
library(ggplot2)

# Step 3 : Import data into R
# Import a single file 
cname<-read.csv("C:/Users/Deepanshu Bhalla/Documents/Text.csv",head=TRUE)

# Import multiple files from a folder
setwd("C:\\Users\\Deepanshu Bhalla\\Documents\\text mining")
cname <-getwd()
# Number of documents
length(dir(cname))
# list file names
dir(cname) 
# Note : In the above syntax, "text mining" is a folder name. I have placed all text files in this folder

# Step 4 : Locate and load the corpus
# If imported a single file 
docs<-Corpus(VectorSource(cname[,1]));

# If imported multiple files from a folder
docs <- Corpus (DirSource(cname))
docs
summary(docs)
inspect(docs[1])

# Step 4 : Transformation

# 1. # Replacing "/" "@" "|" with space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# 2. Conversion to lower case
docs <- tm_map(docs, content_transformer(tolower))

# 3. Remove numbers
docs <- tm_map(docs, removeNumbers)

# 4. Remove punctuation
docs <- tm_map(docs, removePunctuation)

# 5. Remove english stop words
docs <- tm_map(docs, removeWords, stopwords("english"))

# 6. Remove own stop words
docs <- tm_map(docs, removeWords, c ("steps", "procedures")) 

# 7. Strip whitespace
docs <- tm_map(docs, stripWhitespace)

# 8. Convert to short form
toString <- content_transformer(function(x, from, to) gsub(from, to, x))
docs <- tm_map(docs, toString, "Indian Institute of Management", "IIM")

# Step 5 : Creating a Document Term Matrix
# A document term matrix is simply a matrix with documents as the rows and terms as the columns and a count of the frequency of words as the cells of the matrix.
dtm <- DocumentTermMatrix(docs)
inspect(dtm[1:5, 1000:1005]

# Step 6 : Explore the corpus
findFreqTerms(dtm, lowfreq=100)
findAssocs(dtm, "data", corlimit=0.6)
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
p <- ggplot(subset(wf, freq>500), aes(word, freq))
p <-p+ geom_bar(stat="identity")
p <-p+ theme(axis.text.x=element_text(angle=45, hjust=1))

# Step 7 : Generate a word cloud
wordcloud((names(freq), freq, min.freq=100, colors=brewer.pal(6,"Dark2"),random.order=FALSE)
