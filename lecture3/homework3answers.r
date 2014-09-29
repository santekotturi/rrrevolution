# let's review some R basics, starting simple and building our way up
# I'll do the first one for you:

# 1) Store the value of 2 + 2 in a variable, a
a = 2 + 2
# 2) Store the value of 5 - 2 in another variable, b
b = 5 - 2
# 3) Store the value of a + b in a new variable, c
c = a + b
# 4) store the values of a, b & c in an array, d
values = c(a, b, c)
d = array(data = values)
# OR
d = array()
d[1] = a
d[2] = b
d[3] = c

# 5) combine all these data into a dataframe, myData : 
patient1 = c("sub01", 34, "female", "ctrl")
patient2 = c("sub02", 38, "male", "ctrl")
patient3 = c("sub03", 29, "male", "exp")
patient4 = c("sub04", 51, "female", "exp")

# note, you want your output to look like: 
            V1 V2     V3   V4
patient1 sub01 34 female ctrl
patient2 sub02 38   male ctrl
patient3 sub03 29   male  exp
patient4 sub04 51 female  exp

# hint: you'll need to use rbind() and as.data.frame()
# you can get some help by using ?rbind
# or Google "R cbind make dataframe" ... 

df = as.data.frame(rbind(patient1, patient2, patient3, patient4))

#####################################
# Questions 6-10 are based on the answer from 5. 
# if you're stuck on 5, go ahead to 11

# 6) what is the item in the 1st row, 1st column? 
df[1,1]
# 7) what is the item in the 2nd row, 3rd column? 
df[2,3]
# 8) get out just the 3rd row of the dataframe
df[3, ]
# 9) set the column names of the dataframe to something meaningful
colnames(df) = c("ID", "age", "gender", "group")
# 10) get just one of the columns using the $ operator
df$group
# 11) install the following packages in R: ggplot2, plyr, reshape2, AnalyzeFMRI, brainwaver, cudaBayesreg
# for those inclined, this article has a lot of good fMRI R packages: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0089470
install.packages("ggplot2")
install.packages("plyr")
install.packages("reshape2")
install.packages("AnalyzeFMRI")
install.packages("brainwaver")
install.packages("cudaBayesreg")

# 12) once you've installed those packages, load a couple of them into your R environment
# if you're stuck, Google "install and load R package"
library(ggplot2)
library(plyr)
library(reshape2)
library(AnalyzeFMRI)
library(brainwaver)
library(cudaBayesreg)

# 13) find a csv file on your computer (I know you have at least ONE!)

# 14) set you R working directory to the location of this csv file

# 15) read in this csv file into R. store it in a variable, myData
myData = read.csv("filename.csv", header = T, stringsAsFactors = F)
# 16) what are the dimensions of this dataframe? print just the first 5 rows of data
dim(myData)
# swapping over to the Loblolly dataset
# 17) load the Loblolly dataset into your R working environment and store it in a new variable, name it whatever you want
load(Loblolly)
# 18) verify that you have 84 rows and 3 columns 
dim(Loblolly)
# 19) print a table of how many data points for each age there are
table(Loblolly$age)
# 20) finish this code to calculate the average height at age point:

ages = split(Loblolly, Loblolly$age)
averageHeights = array() 	# what kind of data structure did we use to store the average growths in lecture 3? hint: starts with an A. hint: ends with a Y... 
for(i in seq_along(ages)){
	x = ages[[i]]

	averageHeight = mean(x$height)	# hint, what function would calcuate the mean height? another hint: mean()
	averageHeights[i] = averageHeight #there was a typo here, had an incorrect S on averageHeight
}

# now print averageHeights to see what the average heights were at age 3, 5, 10, 15, 20, & 25
print(averageHeights)

# Bonus 1) Now that we know the average height for each age, figure out 
#     whether each tree was above or below average at each age
trees = split(Loblolly, Loblolly$Seed)
aboveAndBelow = list()
for(i in seq_along(trees)){
	treeArray = array()
	x = trees[[i]]
	id = x$Seed[1]
	for(j in 1:nrow(x)){
		if(x$height[j] > averageHeights[j]){
			treeArray[j] = TRUE
		} else {
			treeArray[j] = FALSE
		}
	}
	aboveAndBelow[[i]] = treeArray
}
results = do.call(rbind, aboveAndBelow)

# Bonus 2) Write a function that calculates how far above and below average
#          each tree was at each timepoint
trees = split(Loblolly, Loblolly$Seed)

aboveOrBelow = function(data, averageHeights){
	aboveAndBelow = list()
	for(i in seq_along(data)){
		treeArray = array()
		x = data[[i]]
		id = x$Seed[1]
		for(j in 1:nrow(x)){
			heightDifference = x$height[j] - averageHeights[j]
			treeArray[j] = heightDifference
		}
		aboveAndBelow[[i]] = treeArray
	}
	results = as.data.frame(do.call(rbind, aboveAndBelow))
	return(results)
}

results2 = aboveOrBelow(trees, averageHeights)

# Bonus 3) Write another function that graphs each tree's height, 
#          compared to the average

ages = c(3, 5, 10, 15, 20, 25)
averageData = as.data.frame(cbind(averageHeights, ages))
averageData$Seed = "grpAvg"
colnames(averageData) = c("height", "age", "Seed")

graphRelativeHeights = function(trees, averageData){
	require(ggplot2)
	for(i in seq_along(trees)){
		x = trees[[i]]
		id = x$Seed[1]
		data = as.data.frame(rbind(x, averageData))
		dev.new()
		q = ggplot(data, aes(x=age, y=height, group=Seed))
		q = q + geom_line(aes(linetype=Seed))
		ggsave(paste("Height_Graph_for_Seed:", id, ".pdf" ,sep=""))
		print(q)
		dev.off()
	}
}

graphRelativeHeights(trees, averageData)





















