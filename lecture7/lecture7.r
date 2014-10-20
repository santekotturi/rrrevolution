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
### once by Valnce
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
correctPush = responses[[1]]
correctPull = responses[[2]]

meanPushRT = mean(correctPush$Stimulus.RT)
meanPullRT = mean(correctPull$Stimulus.RT)

# let's start putting this together 
subid = x$Subject[1]
valence = x$Valence[1]

data = as.data.frame(cbind(subid, valence, meanPushRT, meanPullRT))





















