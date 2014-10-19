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
###### 1. calculate the mean response to all 8 conditions: 
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

conditions = split(df, df$Valence)
names(conditions) #just print them out to double check































