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

f = data.frame(rbind(patient1, patient2, patient3, patient4), drop.factors=TRUE)

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
table(f$gender)
which(f$age > 30)





































