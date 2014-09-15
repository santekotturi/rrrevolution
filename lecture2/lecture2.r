# lets practice some of our dataframe skills. We're going to cover: 
# 1) how to import practice data
# 2) how to get a feel for our data
# 3) how to start selecting just the data we want
# 4) how to clarify your data
# 4.1) a sidenote in DRY principle 
# 5) how to ... do anything you like

# R comes with a set of datasets to play with
# lets see what we've got:
data()
# this prints out a list of all the available datasets 

# wait, why is some of my text green?! a note on comments...

# lets load the Loblolly dataset into our working environment:
data(Loblolly)
# this is really weird, it actually creates a variable named Loblolly with the Loblolly data in it. 
# this isn't normal, you typically need to do something like Loblolly = data(Loblolly)
# just know that this works in this case only (its designed as a practice dataset)

# now let's learn how to get comfortable with our new dataframe. 
# its typically not a good idea to print off the entire dataframe (usually theyre quite big)
# instead, use a series of functions to the complete picture without just staring at a big mess of numbers...

# how big is it:
dim(Loblolly)   #stands for dimensions(x)

# dim gives you both of these:
# number of columns
ncol(Loblolly)
# and
# number of rows
nrow(Loblolly)

# what does the first 5 rows look like? 
head(Loblolly)

# and the bottom 5 rows? 
tail(Loblolly)

# what are the column names? 
colnames(loblolly)

# let's get some practice! 
# pick a dataset from the data() set and figure out its dimensions, column names and what the data looks like

# let's learn some more tools! 
# "Seed" looks like a unique identifier, a subject id...
# how many unique plants do we have?
unique(Loblolly$Seed)
# that's not exactly what we wanted, we wanted to know HOW MANY...
length(unique(Loblolly$Seed))

# how many data points at each age point?
table(Loblolly$age)

# table is cool, but not super useful most of the time:
table(Loblolly$height)
# ordinal and categorial data are good candidates for table(), but continous data, not so much. 

# pick a seed number, let's use the first one, 301:
which(Loblolly$Seed == 301)
# think about having a giant dataframe of subject data and you want just the data for sub163
# you could scroll through looking for their data or just use which()

# which() is great, but if you want to actually use this data you need to subset your dataframe
indexes = which(Loblolly$Seed == 301)
seed301 = Loblolly[indexes, ]

# a faster way to do this:
seed301=Loblolly[which(Loblolly$Seed == 301), ]
# here we just skipped the intermediate step of storing the indexes variables and combined the previous 2 steps into 1
# you can do a lot of this kind of stuff in R, its up to you really. 
# when you're starting off I recommend doing everything in small, manageable, easy to understand steps. 
# then start to combine steps later when youre comfortable and fluent. 

# lets go back to our individual practice sets and grab the data for unique factor/variable. 

# now lets change some data:
# having seed names like 301-331 isn't super helpful
# all these recordings are from different seeds, let's label where these seeds came from (we'll make it up)
# so when we share this data with our labmates, it makes more sense to them

# let's store the name in a new column, Name
# we'll need to name: 301 303 305 307 309 311 315 319 321 323 325 327 329 331
Loblolly$Name[which(Loblolly$Seed == 301)] = "yosemite"
Loblolly$Name[which(Loblolly$Seed == 303)] = "tahoe"
Loblolly$Name[which(Loblolly$Seed == 305)] = "mariposa"
Loblolly$Name[which(Loblolly$Seed == 307)] = "humbolt"
Loblolly$Name[which(Loblolly$Seed == 309)] = "lostcoast"
Loblolly$Name[which(Loblolly$Seed == 311)] = "kindscanyon"
Loblolly$Name[which(Loblolly$Seed == 315)] = "sequioa"
Loblolly$Name[which(Loblolly$Seed == 309)] = "mtlaguna"
Loblolly$Name[which(Loblolly$Seed == 315)] = "mybackyard"
Loblolly$Name[which(Loblolly$Seed == 319)] = "zion"
Loblolly$Name[which(Loblolly$Seed == 321)] = "shasta"
Loblolly$Name[which(Loblolly$Seed == 323)] = "yreka"
Loblolly$Name[which(Loblolly$Seed == 325)] = "baker"
Loblolly$Name[which(Loblolly$Seed == 327)] = "hood"
Loblolly$Name[which(Loblolly$Seed == 321)] = "shasta"
Loblolly$Name[which(Loblolly$Seed == 323)] = "yreka"
Loblolly$Name[which(Loblolly$Seed == 325)] = "baker"
Loblolly$Name[which(Loblolly$Seed == 329)] = "rainier"
Loblolly$Name[which(Loblolly$Seed == 331)] = "sthelens"

# we'll soon see how to write this kind of thing in a more expedited way using a for loop: 
uniqueSeeds = unique(Loblolly$Seed)
names = c("yosemite","tahoe","mariposa","humbolt","lostcoast","kindscanyon","sequioa","mtlaguna"
          ,"mybackyard","zion","shasta","yreka","baker","hood","shasta","yreka","baker","rainier"
          ,"sthelens")
for(i in seq_along(uniqueSeeds)){
  Loblolly$Name[which(Loblolly$Seed == uniqueSeeds[i])] = names[i]
}
# but don't worry about that for now, it'll make more sense in a bit. 
# its just a sneak preview :P
# let's discuss DRY! 
# in the future I'll be giving you gnarly code like the very code above and we'll work on DRYing it out! 

# let's work with a slightly more advanced dataset: mtcars
data(mtcars)
head(mtcars)
str(mtcars)
# i dont even know what drat, qsec, vs, am are and im not sure what to do with carb data
# so let's only work with the data we're interested in:
mtcarsInteresting = subset(mtcars, select = c("mpg", "cyl", "hp", "gear"))


# for some more good intro to R datasets with a large emphasis on graphics, I recommend: 
# http://had.co.nz/stat480/lectures/07-r-intro.pdf



