# let's review some R basics, starting simple and building our way up
# I'll do the first one for you:

# 1) Store the value of 2 + 2 in a variable, a
a = 2 + 2
# 2) Store the value of 5 - 2 in another variable, b

# 3) Store the value of a + b in a new variable, c

# 4) store the values of a, b & c in an array, d

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

#####################################
# Questions 6-10 are based on the answer from 5. 
# if you're stuck on 5, go ahead to 11

# 6) what is the item in the 1st row, 1st column? 

# 7) what is the item in the 2nd row, 3rd column? 

# 8) get out just the 3rd row of the dataframe

# 9) set the column names of the dataframe to something meaningful

# 10) get just one of the columns using the $ operator

# 11) install the following packages in R: ggplot2, plyr, reshape2, AnalyzeFMRI, brainwaver, cudaBayesreg
# for those inclined, this article has a lot of good fMRI R packages: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0089470

# 12) once you've installed those packages, load a couple of them into your R environment
# if you're stuck, Google "install and load R package"

# 13) find a csv file on your computer (I know you have at least ONE!)

# 14) set you R working directory to the location of this csv file

# 15) read in this csv file into R. store it in a variable, myData

# 16) what are the dimensions of this dataframe? print just the first 5 rows of data

# swapping over to the Loblolly dataset
# 17) load the Loblolly dataset into your R working environment and store it in a new variable, name it whatever you want

# 18) verify that you have 84 rows and 3 columns 

# 19) print a table of how many data points for each age there are

# 20) finish this code to calculate the average height at age point:

ages = split(Loblolly, Loblolly$age)
averageHeights = CHANGEHERE() 	# what kind of data structure did we use to store the average growths in lecture 3? hint: starts with an A. hint: ends with a Y... 
for(i in seq_along(ages)){
	x = ages[[i]]

	averageHeight = CHANGEHERE(x$height)	# hint, what function would calcuate the mean height? another hint: mean()
	averageHeights[i] = averageHeights
}

# now print averageHeights to see what the average heights were at age 3, 5, 10, 15, 20, & 25

# Bonus 1) Now that we know the average height for each age, figure out 
#     whether each tree was above or below average at each age

# Bonus 2) Write a function that calculates how far above and below average
#          each tree was at each timepoint

# Bonus 3) Write another function that graphs each tree's height, 
#          compared to the average

























