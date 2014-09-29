# we want to analyze our el nino data and see if we can find a trend in weather
# we have a bunch of data in a bunch of csv files, one for each year. 
# so far we've only imported data one file at a time
# with 19 files our code would look like: 

myData1 = read.csv("ElNinoData_1980.csv", header = T, stringsAsFactors = F)
myData2 = read.csv("ElNinoData_1981.csv", header = T, stringsAsFactors = F)
myData3 = read.csv("ElNinoData_1982.csv", header = T, stringsAsFactors = F)
myData4 = read.csv("ElNinoData_1983.csv", header = T, stringsAsFactors = F)
myData5 = read.csv("ElNinoData_1984.csv", header = T, stringsAsFactors = F)
myData6 = read.csv("ElNinoData_1985.csv", header = T, stringsAsFactors = F)
myData7 = read.csv("ElNinoData_1986.csv", header = T, stringsAsFactors = F)
myData8 = read.csv("ElNinoData_1987.csv", header = T, stringsAsFactors = F)
myData9 = read.csv("ElNinoData_1988.csv", header = T, stringsAsFactors = F)
myData10 = read.csv("ElNinoData_1989.csv", header = T, stringsAsFactors = F)
myData11 = read.csv("ElNinoData_1990.csv", header = T, stringsAsFactors = F)
myData12 = read.csv("ElNinoData_1991.csv", header = T, stringsAsFactors = F)
myData13 = read.csv("ElNinoData_1992.csv", header = T, stringsAsFactors = F)
myData14 = read.csv("ElNinoData_1993.csv", header = T, stringsAsFactors = F)
myData15 = read.csv("ElNinoData_1994.csv", header = T, stringsAsFactors = F)
myData16 = read.csv("ElNinoData_1995.csv", header = T, stringsAsFactors = F)
myData17 = read.csv("ElNinoData_1996.csv", header = T, stringsAsFactors = F)
myData18 = read.csv("ElNinoData_1997.csv", header = T, stringsAsFactors = F)
myData19 = read.csv("ElNinoData_1998.csv", header = T, stringsAsFactors = F)

yoda = rbind(myData1, myData2, myData3, myData4, myData5, myData6, myData7
	myData8, myData9, myData10, myData11, myData12, myData113,myData14, 
	myData15, myData16, myData17, myData18)

# and this doesnt look good... 
# instead we want to write DRY code
# and instead of dealing with 18 different data frames, 
# ideally we would only want one master that we can then analyze

# let's build a master data frame called "yoda"

# let's get a list of files we want our for loop to import:
myFiles = list.files(pattern = ".csv", recursive = TRUE)
# see what happens if you change recursive = TRUE to FALSE... 

# here's our import function
importData = function(listOfFilesToImport){
	yoda = NULL
	for(i in seq_along(listOfFilesToImport)){
		x = read.csv(listOfFilesToImport[i], header = TRUE, stringsAsFactors = FALSE)
		if(is.null(yoda)){
			yoda = x
		} else {
			yoda = rbind(yoda, x)
		}
	}
	return(yoda)
}

# and now let's actually import the data by running the script: 
myData = importData(myFiles)

# let's pause for a second, lines 6-29 do the same thing as lines 38-56
# so why take the time to learn how to use importData() ? 
# what happens if we add another file? 
# what happens when we change the file names?

years = split(myData, myData$year)
# years is a list! we just learned all about lists!!

# let's keep our analysis simple, let's just find the average and variance air temp  for each year
# but before we jump into a for loop, we should write our code to analyze the first year
# then worry about expanding our code to analyze all the years:

firstYear = years[[1]]
head(firstYear)
# one thing, when we imported the csv files, the air temp values
# got converted into strings (words), they weren't kept as numbers. 
# this is annoying but we can change it:
firstYear$air.temp. = as.numeric(firstYear$air.temp.)
meanAirTemp = mean(firstYear$air.temp.)
varAirTemp = var(firstYear$air.temp.)

# ok, now let's copy our code and put it inside a for loop
# then we can work on converting it, making it work inside our for loop

# and we'll need a list to store our values in:
results = list()
for(i in seq_along(years)){
  x = years[[i]]
  x$air.temp. = as.numeric(x$air.temp.)
  meanAirTemp = mean(x$air.temp., na.rm = T)
  varAirTemp = var(x$air.temp., na.rm = T)
  
  year = x$year[1]
  data = as.data.frame(cbind(year, meanAirTemp, varAirTemp))
  
  results[[i]] = data
}


# the last step is turn our results list into an easy to read dataframe:
# before:
head(results)
# after:
resultsDF = do.call(rbind, results)
head(resultsDF)

# that wraps up Split.Analyze.Together

# there are other ways of doing this including:
unsplit(lapply(split()))
# and 
ddply()

# in ddply it would be: 

meanAndVar = function(x){
  meanAirTemp = mean(x$air.temp., na.rm = T)
  varAirTemp = var(x$air.temp., na.rm = T)
  year = x$year[1]
  data = as.data.frame(cbind(year, meanAirTemp, varAirTemp))
  return(data)
}

require(plyr)
myData$air.temp. = as.numeric(myData$air.temp.) # fix that silly character problem
resultsDF = ddply(myData, .(year), meanAndVar)

# ddply is great but I really recommend taking the time to learn 
# how to write each part before using a powerful tool like ddply
























