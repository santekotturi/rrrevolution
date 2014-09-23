 # loops and functions. 
 # hopefully we end up functional, not loopy... 

 # first the for loop
 # then the if
 # while (but not really)
 # function (args) { return } 


 # the if loop: 
 if(something is true){
 	do this
 } else {
 	do something else
 }

 # can be joined together
 if(something is true){
 	do this 
 } else if(something else is true){
 	do something else
 } else if(something else is true){
 	do this thing
 } else {
 	do whatever else 
 }

 # let's get some practice with conditional statements:
 # in your setting
 if(group == "ctrl"){
 	analyze the control group
 } else if(group == "trmtA"){
 	analyze treatment A group
 } else if(group == "trmtB"){
 	analyze treatment B group
 } else {
 	print("something went wrong, unmatched group")
 }

if(group == "ctrl" && scanner == "west"){
	analyze the control patients that were scanned on 3T West
} else if(group == "ctrl" && scanner == "east"){
	analyze the control patients that were scanned on 3T East
}

if(gender == "female" || gender == "male"){
	analyze women and men the same
} else {
	print("are we that progressive yet in science?")
}

# we'll see more if statements in practice
# let's go over the for loop: 

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
exponentTables = array()	# create a new empty array we're going to use in the for loop
 for(i in c(1:10)){
 	x = 2^i
 	exponentTables[i] = x
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

# a really corny example of for & if statements:
# youre a head chef. You have a sous-chef. 
# when you had your sous-chef a bowl of veggies, you want him to chop each one. 
# however, he should first check to see the veggie is rotten
for(i in seq_along(veggies)){
	veggie = veggies[i]
	if(veggie == rotten){
		throw away veggie 
	} else{
		chop veggie
	}
	#once the for loop has gone through it will iterate over and he'll get the next veggie
}
# the problem we'll see is that in this case, the sous-chef doesnt return anything back to us. the veggies just sit there, chopped. 


# let's put this to use:
data(Loblolly)

seeds = split(Loblolly, Loblolly$Seed)

for(i in seq_along(seeds)){
	print(i)
}

# seq_along(seeds) is basically c(1:14) but what if you add another Seed
# and forget to change 14 to 15, then you'll only go through the first 14. 
# seq_along(seeds) is a more resillient, dynamic way. It's called softcoding, 
# whereas c(1:14) is called hardcoding. Hardcoding, like wet code is something you want to avoid 
# DRY & Soft code is good.... 

# let's say we want to calculate the average growth between timepoints
# we need an array to store 
 allRates = vector("list", length = length(names(seeds)))
 for(i in seq_along(seeds)){
   growth = array()
   x = seeds[[i]]
   m = 1
   k = 2
   for(j in 1:nrow(x)){
     if(k > nrow(x)){
       break
     } else {
     	# rate = (y2 - y1)/(x2 - x1)	
       rate = (x$height[k] - x$height[m])/(x$age[k] - x$age[m])
       growth[j] = rate
       m = m + 1
       k = k + 1 
     }
    }
   dev.new()
   plot.ts(growth)

   allRates[[i]] = growth
 } 
  allRates = as.data.frame(do.call(rbind, allRates))


# ok but this is a MESS. 
# let's clean this up with the use of some functions! 

myFunc = function(argument1, argument2, argument3){
	if(argument3 == true){
		do something with argument1 & argument2
	}
	return(some new value)
}

myValue = myFunc(5, 10, TRUE)
# let's dissect this a bit


# let's put this to use in our gnarly for loop ^^ 
# we want to write functions that do only one thing. 
# this way we can reuse them as much as possible. 
# if you have a sous-chef whose in charge of chopping vegetables 
# and grilling meat and baking souffle's all at once, you probably 
# never need all three of these done at the same time... 

# here we have two distinct things, we calculate rates of growth and we plot. 
# let's write functions to handle these for us

calculateGrowth = function(x){
   growth = array()
   m = 1
   k = 2
   for(j in 1:nrow(x)){
     if(k > nrow(x)){
       break
     } else {
       # rate = (y2 - y1)/(x2 - x1)	
       rate = (x$height[k] - x$height[m])/(x$age[k] - x$age[m])
       growth[j] = rate
       m = m + 1
       k = k + 1 
     }
    }
    return(growth)
}

plotGrowth = function(growth){
	dev.new()
	plot.ts(growth)
	# note the lack of return value, this is totally fine! 
}

# now our code looks like: 
allRates = vector("list", length = length(names(seeds)))
for(i in seq_along(seeds)){
 	x = seeds[[i]]
 	myGrowth = calculateGrowth(x)
 	plotGrowth(myGrowth)
 	allRates[[i]] = myGrowth
}
allRates = as.data.frame(do.call(rbind, allRates))

# wow, that looks way better, is more functional. 
# keep in mind that when you're code gets longer 
# the need for functions will be greatly increased

# a function I've written and used many many many times: 

importData = function(pattern, recursive){
	# pattern is the String pattern you want to match in the file names
	# recursive is a Boolean value whether or not you want to search all folders from your current location
	filesToImport = list.files(pattern = pattern, recursive = recursive)
	yoda = null
	for(i in seq_along(filesToImport)){
		x = read.csv(filesToImport[i], header = TRUE, stringsAsFactors = FALSE)
		if(is.null(yoda)){
			yoda = x
		} else {
			yoda = rbind(yoda, x)
		}
	}
	return(yoda)
}

myData = importData(".csv", FALSE)
myT1Data = importData("T1.csv", TRUE)
myT2Data = importData("T2.csv", TRUE)


# a note on SAVING as Charlie brought up last time. 
# there are a couple ways to save things:
# 1. the most explicit way to write a csv file but you only want to do this at the end. 
# you dont really want to save every intermediate step
# Normally you'll want to save something so you can continue to work on it in R
# you can either save it as its own variable; a = 2
# or you can append a new column to a dataframe; data$sums = rowSums(myData)
# the last way to save something is to write a function that returns the desired value 
# we'll see how to do this last one in a bit
 
 
 # task: 
 # write a function that returns the dimensions of any dataframe
 # and save that value in a new variable 
 
 returnDimensions = function(x){
   if(is.null(dim(x))){
     dimensions = length(x)
   } else {
     dimensions = dim(x)
   }
   return(dimensions)
 }
 
 
LobDimensions = returnDimensions(Loblolly)
FormDimensions = returnDimensions(Formaldehyde)
 
 
 
 
 
 
 
 
 