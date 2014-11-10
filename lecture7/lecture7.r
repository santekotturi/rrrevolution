# generally a good idea to start with a clear workspace:
rm(list = ls())

# in this case we only have a 1 file which makes import easier. 

df = read.table("AAT_faces_raw.txt", header = T, stringsAsFactors = F, sep="\t")


colnames(df)
unique(df$ExperimentName)
# so we have to versions
unique(df$Subject)
unique(df$Session)

# I would have like to use:
for(i in 1:ncol(df)){
	print(i)
	print(unique(df[i]))
}
# but this doesnt work so well because only the id columns are of interest. 
# the columns containing measurements will print out WAY TOO much information to make this helpful. 

unique(df$ExperimentName)
unique(df$Subject)
unique(df$Session)
unique(df$Group)
unique(df$Block)
unique(df$BorderType)
unique(df$Condition)
unique(df$CorrectResponse)
unique(df$Valence)


###############################################
############## ANALYSIS PLAN ##################
###############################################
###### 1. calculate the mean response to all 8 valences: 
############# 1) angry + push
############# 2) angry + pull
############# 3) disgust + push
############# 4) disgust + pull
############# 5) neutral + push
############# 6) neutral + pull
############# 7) positive + push
############# 8) positive + pull
###### 2. find the difference between:
############ 1 & 2
############ 3 & 4
############ 5 & 6
############ 7 & 8 

# Thus, we need to split twice:
### once by Valence
### then by Condition 

valences = split(df, df$Valence)
names(valences) #just print them out to double check

# we dont jump straight into writing a for loop to calculate our
# response times for each subject by each condition
# we need to write our code first for one subject in one condition and then expand out. 

angry = valences[[1]] # remember the double brackets! 

angrySubjects = split(angry, angry$Subject)
names(angrySubjects)

firstSub = angrySubjects[[1]]
head(firstSub)
# whoa, there's a lot of extra stuff in there, let's subset only the data we need to work with:
colnames(firstSub)
x = subset(firstSub, select=c("Subject", "CorrectResponse", 
							  "Stimulus.Resp", "Stimulus.RT", "Valence" ))

# are the responses correct?
x$CorrectResponse == x$Stimulus.Resp

# we can subset out the incorrect ones:
correct = x[x$CorrectResponse == x$Stimulus.Resp, ]
incorrect = x[x$CorrectResponse != x$Stimulus.Resp, ]

responses = split(correct, correct$CorrectResponse)
correctPush = responses[[2]]
correctPull = responses[[1]]

meanPushRT = mean(correctPush$Stimulus.RT)
meanPullRT = mean(correctPull$Stimulus.RT)

# let's start putting this together 
subid = x$Subject[1]
valence = x$Valence[1]

data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))

# we can now either implement either of two directions: 
# note: this next section is all pseudocode:
for(i in subjects){
	1) calculate angry
	2) calculate disgust
	3) calculate neutral
	4) calculate positive
}

OR 

for(i in subjects){
	valences = split(subject by valence)
	for(v in valences){
		calculate valence
	}
}

# the first one is easier to conceptualize but it will lead to a lot of repeated code 
# which is more error prone, harder to maintain and harder for others to comprehend

# so let's do the second one! we're up for the challenge :P 

# before we split by Subject we should write our inner for loop and work outwards. 
# we've done most of the work already but we need to adapt our code to handle all valences
# instead of just angry: 

# to avoid any variable overwriting, let's clean our workspace and begin 
# with a blank slate:
rm(list = ls())

df = read.table("AAT_faces_raw.txt", header = T, stringsAsFactors = F, sep="\t")

subjects = split(df, df$Subject)
names(subjects)  # sanity check, everything look as expected? 

y = subjects[[1]]
valences = split(y, y$Valence)
names(valences)  # sanity check, everything look as expected? 

for(v in seq_along(valences)){
	x = valences[[v]]

	# now we can reuse most of the code we wrote above for angry but 
	# we can copy and paste it but we need to double check it
}

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
	subid = x$Subject[1]
	valence = x$Valence[1]

	data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))

	valenceResults[[v]] = data

}

subjectResults = do.call(rbind, valenceResults)


allResults = list()
for(i in seq_along(subjects)){

	y = subjects[[i]]
	valences = split(y, y$Valence)

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
		subid = x$Subject[1]
		valence = x$Valence[1]

		data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))

		valenceResults[[v]] = data

	}
	subjectResults = do.call(rbind, valenceResults)
	allResults[[i]] = subjectResults

}

yoda = do.call(rbind, allResults)

##################################################
######## Ok, so it works but it looks kinda messy
######## we can clean it up by putting everything
######## in the inner for loop in a ___________
######## FUNCTION! 

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
		subid = x$Subject[1]
		valence = x$Valence[1]

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















