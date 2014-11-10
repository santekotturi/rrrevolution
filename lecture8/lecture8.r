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
    group = x$Group[1]
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










##################################
##################################
#### to remove outliers who are above or below by 2 standard deviations: 
subjects2 = split(yoda, yoda$subid)
grpPushRTmean = mean(yoda$meanPushRT)
grpPullRTmean = mean(yoda$meanPullRT)
grpPushRTstd = sd(yoda$meanPushRT)
grpPullRTstd = sd(yoda$meanPullRT)

subjectsToKeep = list()
for(i in seq_along(subjects2)){
 
  x = subjects2[[i]]
  if(x$meanPullRT > (2*grpPullRTstd + grpPullRTmean) || x$meanPullRT < (2*grpPullRTstd - grpPullRTmean)){
    print(i)
    print("FOUND AN OUTLIER!")
  } else {
    subjectsToKeep[[i]] = x
  }
  
}

cleanedResults = do.call(rbind, subjectsToKeep)
##################################
##################################



####################################################
#### now that we have our data in the format we want 
#### we can run our stats on it... well almost
#### we still need to calculate our deltas: push - pull

yoda$deltas = yoda$meanPushRT - yoda$meanPullRT
# we get an error because I believe the do.call function convertes things to factors. so:
yoda$meanPushRT = as.numeric(as.character(yoda$meanPushRT))
yoda$meanPullRT = as.numeric(as.character(yoda$meanPullRT))
# now this will work:
yoda$deltas = yoda$meanPushRT - yoda$meanPullRT

# R is actually doing a pretty amazing thing here. instead of having to go through
for(i in 1:nrow(yoda)){
	yoda$delta[i] = yoda$meanPushRT[i] - yoda$meanPullRT[i]
}
# it does this all for us, in whats called a vectorized implementation. 
# now you can say you know how to do parallel computing in R.... 


# let's do some quick plots by valence
scoredValences = split(yoda, yoda$valence)
angry = scoredValences[[1]]
neutral = scoredValences[[3]]

plot(angry$deltas)
abline(h=30)

angryNeutral = rbind(angry, neutral)
t.test(valence ~ deltas, data=angryNeutral)
## oops, variable ~ group :
t.test(deltas ~ valence, data=angryNeutral)
































