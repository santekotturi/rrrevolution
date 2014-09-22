 # loops and functions. 
 # hopefully we end up functional, not loopy... 

 # first the for loop
 # then the if
 # while (but not really)
 # function (args) { return } 

 for(some index number less than another number){
 	do some stuff
 }

 # we normally use i to be our index:
 for(i in 1 through 10){
	do some stuff
 }
# the first time through i will be 1, the second time 2, 3 ... 10. but not 11. 

# an actual R for loop would look like:
 for(i in c(1:10)){
 	print(i)
 }
# test this out yourself! 

 for(i in c(1:10)){
 	x = 2^i
 	print(x)
 }
# you can check to see what x is equal to
x
# notice that its only 1024, the last value. Everytime through x gets rewritten. 
# what if we want to save all of our 2^x times tables? 
timeTables = array()	# create a new empty array we're going to use in the for loop
 for(i in c(1:10)){
 	x = 2^i
 	timeTables[i] = x
 }
 # each time through x get's a new value, but this time we store the value
 # into the next cell in the timeTables array

 for(i in c(1:10)){
	timeTables = array()	# a common mistake is to place the array INSIDE the for loop. why doesnt this work?
 	x = 2^i
 	timeTables[i] = x
 }
 # test it out and see what timeTables has at the end...
# make sure to do your initializations OUTSIDE (and BEFORE) your for loop

# let's put this to use:
data(Loblolly)

seeds = split(Loblolly, Loblolly$Seed)

for(i in seq_along(seeds)){
	print(i)
}
# seq_along(seeds) is basically c(1:14) but what if you add another Seed
# and forget to change 14 to 15, then you'll only go through the first 14. 
# seq_along(seeds) is a more resillient, dynamic way. It's called softcoding, 
# whereas c(1:14) is called hardcoding. Hardcoding, like wet code is something 
# you want to avoid, DRY & Soft code... 



for(i in 1:nrow(myData)){
	subject = myData[i, ]
	dev.new()
	ggplot(subject, aes(x=))
}


# let's test this out using our first dataset:
# remember how to import csv data into R?
myData = read.csv("mydata.csv", header = T, stringsAsFactors = F)
# one sidenote: read.csv is a function, it has a function name (read.csv),
# it accepts arguments, (filename, header, stringsAsFactors)
# and it returns something back to you, in this case the data file you wish to import
# you then save the returned data frame in a variable, in this case, myData. 
# we'll see how to write our own functions shortly. 

for(i in 1:nrow(myData)){
	print(i)
}
# where i is our index
# and 1:nrow is an array of values that i will equal to

# now we can use i to do something "useful"
for(i in 1:nrow(myData)){
	print(myData[i, ])
}

# and then something a little more useful:
for(i in 1:nrow(myData)){
	subject = myData[i, ]
	dev.new()
	ggplot(subject, aes(x=))
}


# a note on SAVING as Charlie brought up last time. 
# there are a couple ways to save things:
# 1. the most explicit way to write a csv file but you only want to do this at the end. 
# you dont really want to save every intermediate step
# Normally you'll want to save something so you can continue to work on it in R
# you can either save it as its own variable; a = 2
# or you can append a new column to a dataframe; data$sums = rowSums(myData)
# the last way to save something is to write a function that returns the desired value 
# we'll see how to do this last one in a bit