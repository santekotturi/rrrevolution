
rm(list = ls())

df = read.table("AAT_faces_raw.txt", header = T, stringsAsFactors = F, sep="\t")

subjects = split(df, df$Subject)


calculateValenceRT = function(valences){
	valenceResults = list()
	for(v in seq_along(valences)){
		x = valences[[v]]

		correct = x[x$CorrectResponse == x$Stimulus.Resp, ]
		incorrect = x[x$CorrectResponse != x$Stimulus.Resp, ]

		responses = split(correct, correct$CorrectResponse)
		correctPush = responses[[1]]
		correctPull = responses[[2]]

		meanPushRT = mean(correctPush$Stimulus.RT)
		meanPullRT = mean(correctPull$Stimulus.RT)

		# let's start putting this together 
		# we need grab our id variables so that our data has the correct labels
		subid = x$Subject[1]
		valence = x$Valence[1]
		# if we had a group variable and/or time variable we get it here too:
		#time = x$Time[1]
		#group = x$Group[1]

		data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))

		valenceResults[[v]] = data

	}
	subjectResults = do.call(rbind, valenceResults)
	
	# then we need to add a return statement
	return(subjectResults)
}



####################################################
#### and VOILA! our complete analysis: 
#### all tidy and simple looking.... 
#### maybe too simple... if you show your boss maybe
#### he/she will think you're overpaid... #goodProblemsToHave

allResults = list()
for(i in seq_along(subjects)){

	y = subjects[[i]]
	valences = split(y, y$Valence)
	subjectResults = calculateValenceRT(valences)
  allResults[[i]] = subjectResults

}

yoda = do.call(rbind, allResults)




# 1) write the function
# 2) split on subjects
# 3) within for loop, split on valences and then call function
# 4) put results together using do.call()


# this is the manual way of doing it. there is a more automated way
# using the ddply function in the plyr package. 
# its only really helpful once you undestand the process, by doing it the manual way
# its definitely something to plan on using in the future

# intall plyr if you havent already:
install.packages("plyr")
library(plyr)

# to get some basic info about ddply:
?ddply

# let's scroll to the bottom and do the example together:

# make some test data 
dfx <- data.frame(
  group = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  sex = sample(c("M", "F"), size = 29, replace = TRUE),
  age = runif(n = 29, min = 18, max = 54)
)

# Note the use of the '.' function to allow
# group and sex to be used without quoting
ddply(dfx, .(group, sex), summarize,
 mean = round(mean(age), 2),
 sd = round(sd(age), 2)
 )


# all the arguments makes sense except the mean and sd, what are those doing? 
?summarize

# turns out, mean and sd are parameters/arguments that summarize expects to use
# if we go back to ddply we'll see that there's a .... arg which allows for paramters to be passed
# to the .fun 
?ddply

# so we see that it works, let's dig deeper to see HOW:
# instead of using summarize, let's write our own function:

newFunc = function(x){
	print(x)
}

result = ddply(dfx, .(group, sex), newFunc)

# this is really cool, if we wanted to do this the manual way we would have to:

groups = split(dfx, dfx$group)
for(i in seq_along(groups)){
	x = groups[[i]]
	genders = split(x, x$sex)
	for(k in seq_along(genders)){
		y = genders[[k]]
		print(y)
	}
}

# we get the same exact results from our print statements, however ddply did A LOT for us! 

# note: we could have made our manual lives easier by splitting by two variables: 
# groupsByGender = split(dfx, list(dfx$group, dfx$sex))
# for(i in seq_along(groupsByGender)){
# 	x = groupsByGender[[i]]
# 	print(x)
# }

# let's update our newFunc to do something more useful than printing out each subset

newFunc = function(x){
	meanAge = mean(x$age)
	return(meanAge)
}

result = ddply(dfx, .(group, sex), newFunc)


# this works great if we only want means, but what if we want standard dev too?
newFunc = function(x){
	meanAge = mean(x$age)
	sdAge = sd(x$age)

	# This is NOT allowed
	#return(meanAge, sdAge)

	# we need a new step where we combine the output because we can only return ONE item	
	outputData = as.data.frame(cbind(meanAge, sdAge))
	return(outputData)

}

result = ddply(dfx, .(group, sex), newFunc)

# ok so we've worked with the .fun argument, what about the .variables:
# what if only wanted group means (no care for gender):

result = ddply(dfx, .(group), newFunc)
# HOW EASY IS THAT? 

# and then only gender differences ignoring group:
result = ddply(dfx, .(sex), newFunc)


# now let's revisit our original analysis plan:

# first we need our function:
# old
calculateValenceRT = function(valences){
	valenceResults = list()
	for(v in seq_along(valences)){
		x = valences[[v]]

		correct = x[x$CorrectResponse == x$Stimulus.Resp, ]
		incorrect = x[x$CorrectResponse != x$Stimulus.Resp, ]

		responses = split(correct, correct$CorrectResponse)
		correctPush = responses[[1]]
		correctPull = responses[[2]]

		meanPushRT = mean(correctPush$Stimulus.RT)
		meanPullRT = mean(correctPull$Stimulus.RT)

		# let's start putting this together 
		# we need grab our id variables so that our data has the correct labels
		subid = x$Subject[1]
		valence = x$Valence[1]
		# if we had a group variable and/or time variable we get it here too:
		#time = x$Time[1]
		#group = x$Group[1]

		data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))

		valenceResults[[v]] = data

	}
	subjectResults = do.call(rbind, valenceResults)
	
	# then we need to add a return statement
	return(subjectResults)
}

# new
calculateValenceRTv2 = function(x){

		correct = x[x$CorrectResponse == x$Stimulus.Resp, ]
		incorrect = x[x$CorrectResponse != x$Stimulus.Resp, ]

		responses = split(correct, correct$CorrectResponse)
		correctPush = responses[[1]]
		correctPull = responses[[2]]

		meanPushRT = mean(correctPush$Stimulus.RT)
		meanPullRT = mean(correctPull$Stimulus.RT)

		data = as.data.frame(cbind(meanPushRT, meanPullRT))

		return(data)
}


# then we can ddply it:
results2 = ddply(df, .(Subject, Valence), calculateValenceRTv2)








# next up: MERGE! 

# first we need to make some work for ourselves, we usually have to merge data that is in wide format
# so let's split up our results2 , convert to wide format (requires going full long first)
# and then we can merge our two datasets: 

valences = split(results2, results2$Valence)
val1 = rbind(valences[[1]], valences[[2]])
val1long = melt(val1, id.vars=c("Subject", "Valence"), measure.vars=c("meanPushRT", "meanPullRT"))
val1wide = dcast(val1long, Subject ~ Valence + variable, value.var="value")

val2 = rbind(valences[[3]], valences[[4]])
val2long = melt(val2, id.vars=c("Subject", "Valence"), measure.vars=c("meanPushRT", "meanPullRT"))
val2wide = dcast(val2long, Subject ~ Valence + variable, value.var="value")

# now let's merge our two datasets, val1wide & val2wide
?merge

merge(val1wide, val2wide, by="Subject")

# where "by" is the shared variable name. 

#save the result:
mergedResults = merge(val1wide, val2wide, by="Subject")

# and write it out for safe keeping:
write.csv(mergedResults, "mergedResults.csv", row.names = F)
























