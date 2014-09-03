#lecture 1

rm(list =ls())

# very basics
# r is a calculator

2 + 2

a = 2
b = 3
a + b
c = a + b 

# = vs <- vs == 
# = and <- are the assignment operator, they assign the value on the right to the object on the left
# Technically youre suppose to the <- but I heard years ago this was being phased out
# its also one of the most annoying keystroke combos I've ever seen and refuse to use it. 

a = 2
a <- 2 
# these are the same
a == 2 #asks the question, is "a" equal to 2?

# to see what variables you have declared: 
ls()

# what types of data structures are there in R? 
a = 2
b = "hello"
c = "world"
d = paste(b, c)
e = c(a, b, c, d)
e = array()
e[1] = a
e[4] = d

patient1 = c("sub01", 34, "female", "ctrl")
patient2 = c("sub02", 38, "male", "ctrl")
patient3 = c("sub03", 29, "male", "exp")
patient4 = c("sub04", 51, "female", "exp")

f = rbind(patient1, patient2, patient3, patient4)

class(f)

f = data.frame(rbind(patient1, patient2, patient3, patient4))

class(f)

colnames(f) = c("subId", "age", "gender", "group")

# getting help from R
?rbind
?colnames
?data.frame
?t.test
# the R help is usually quite painful to use, i recommend stack overflow, most people
# have already asked and received answers for almost all the questions youre going to have
# its THE BEST resource you have (other than yourself and your labmates)

# indexing 
f[1,1]
f[,1]
f[1,]
f$subId

#some more fun
table(f$age)
which(f$gender == "female") 
which(f$age > 30) #this throws an error, we'll go over factors and when you want and dont want them later. 
split(f, f$group)

# now that we have the basics down, lets import some data
# in the folder you ran "git clone" in, there should be a file called "data.csv", let's see our 
# R working directory to the same folder so that R can "see" this file and we can import the dataset. 


data = read.csv("mydata.csv", header = T, stringsAsFactors = F)

data$sums = rowSums(data[,3:12])

boxplot(sums ~ group, data = data)

# pretty graphs and a detour to additional packages
# when you install R it comes with a large number of basic functions, however, 
# lots of developers have developed additional functions packaged into libraries aka packages that 
# you can use FOR FREE! (classic R move...)
# one of the most popular R packages is called ggplot. Its currently called ggplot2 because its 
# on version 2. 
# to install a new library you need to do 2 things: 
# 1) tell R where you want to download packages from
# 2) install the package
# then you can load it into your current R environment and use the new functions. 
# R studio does the first part for you, but if youre using the regular R version or if you want to change it
# open the R Preferences and set your "cran mirror"
# now you install the package:
install.packages("ggplot2")
library(ggplot2)
# note the presence and lack there of quotes in the last two lines. 
# now you can checkout ggplot
?ggplot

q = ggplot(data, aes(x= group, y=sums)) 
q = q + geom_boxplot()
# this idea of building layers of a graph aka "The Grammar of Graphics" is very important and something we'll work on more later. 
# to see your graph just use:
q 

#voila! 
# you can get fancy by changing the colors manually or let ggplot give each group a color:
q = ggplot(data, aes(x= group, y=sums, color=group)) 
q = q + geom_boxplot()
q

# you can also add titles: 
q = q + ggtitle("Our first graph")
q

# now for the stats: 
?t.test
t.test(sums ~ group, data = data)
# because reading that can be a bit of a pain, and we know we want one particular value
# lets store the result of the t.test in an object: 
ttest = t.test(sums ~ group, data = data)
# how do we find how to get our value? 
names(ttest)
ttest$p.value

q = q + ggtitle(paste("Our first R graph with a p-value of:", substr(ttest$p.value, 0, 7), sep=" "))
q





































