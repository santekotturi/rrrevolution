# topics to cover: 

# 1) regex: pattern, grep and gsub
# 2) sat^2
# 3) sat^3 


# Regular Expressions
# its quite common in programming to need to match certain strings while ignoring others. 
# this is often done with the use of regular expressions aka regex. 

words1 = c("hi", "hello", "hi there", "hello you", "hightech")
grep("hi", words1)
grep("e", words1)
grep("hi", words1, invert = T)

words2 = c("sub01_T1_sss.csv","sub02_T1_sss.csv","sub01_T2_sss.csv","sub02_T2_sss.csv",
		   "sub01_T1_atd.csv","sub02_T1_atd.csv", "sub01_T2_atd.csv", "sub02_T2_atd.csv")

# so we have two subjects, 2 questionnaires and 2 timepoints. 
# generate a list containing all the data for sub01:
grep("sub01", words2)

# generate a list containing all the data for T1
grep("T1", words2)

# generate a list containing only the data for sss, T1
grep("T1_sss", words2)

# generate a list containing only the data for sub01, sss
grep("sub01_T[1-9]_sss", words2)
# here, [1-9] will match any number between 1-9 in this place. 
# Thus it matches "sub01_T1_sss.csv" & "sub01_T2_sss.csv"

# note that grep returns the INDEX of where the pattern matched. 
# Similar to how which() returns the index where the expression evaluated to true:
which(words2 == "sub01_T1_sss.csv")

# if we wanted to use these its typically helpful to store the index values in a variable:
index = which(words2 == "sub01_T1_sss.csv")
dataWeWant = words[index]

# you can use grep in your coding but its just good practice for when you want to greate a list of files to import:
myFiles = list.files(pattern = "YOUR_GREP_PATTERN_HERE", recursive = TRUE or FALSE)


# onto sat part 2: more advanced SAT functions

# calculate the average air temp for each month within in year. 

# first we need to load the El-Nino Data. 
# set your working directory to /lecture4
# create the list of files to import: 
myFiles = list.files(pattern = ".csv", recursive = TRUE)

# we need to define our import funciton:
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

# and then run the import function, saving our data to a dataframe called myData:
myData = importData(myFiles)

# we need to split by two levels, years & months. 
# there's a few ways to do this but the two most logical are:
# 1. split by both levels:
monthsByYear = split(myData, list(myData$year, myData$month))
# what did this create:
names(monthsByYear)
# this works but we need to do a lot of name/id tracking 
# and doesn't leave us with very modular code (ie. what happens if we want to do some other yearly calculations?)
results = list()
for(i in seq_along(monthsByYear)){
	x = monthsByYear[[i]]
	if(nrow(x) > 1){		#if there's no data for this month & year, skip it...
		year = x$year[1]
		month = x$month[1]
		x$air.temp. = as.numeric(x$air.temp.)
		aveMonthTemp = mean(x$air.temp., na.rm=T)
		data = as.data.frame(cbind(year, month, aveMonthTemp))
		results[[i]] = data
	} else {
		print("skipping empty dataset")
		next
	}
}
resultsDF = do.call(rbind, results)


years = split(myData, myData$year)

# our backbone structure will now revolve around this:
# iterate over each year
for(i in seq_along(years)){
	x = years[[i]]
	# any yearly calculations you want...put them here
	# someCalculation = calculateThis(x)
	# anotherCalc = moreCalc(x)
	# somePlot = plotMyData(x)
}

# ok, let's build this

averageMonthTemp = function(x){
	months = split(x, x$month)
	monthList = list()
	for(k in seq_along(months)){
		y = months[[k]]
		month = y$month[1]
		y$air.temp. = as.numeric(y$air.temp.)
		aveMonthTemp = mean(y$air.temp., na.rm=T)
		monthTemp = as.data.frame(cbind(month, aveMonthTemp))
		monthList[[k]] = monthTemp
	}

	monthData = do.call(rbind, monthList)
	return(monthData)
}

results = list()
for(i in seq_along(years)){
	print(i)
	x = years[[i]]
	year = x$year[1]
	
	monthData = averageMonthTemp(x)
	
	monthData$year = year
	results[[i]] = monthData
}
resultsDF = do.call(rbind, results)

# quick review:
# we have two ways of handling this slightly more complicated task:
# 1) we can split by two levels and then handle each task within the same for loop
# or 2) we can split by our larger factor first (year) and then write a function to help us with our inner (witin each year) task. 
# the second way may seem more complicated, however, what if your boss asks you to add another step?
# you could quickly have a large mess of unmanageable and annoying code. 

# herein lies the art of data science, learning when to write a quick one-off code snippet that handles a task quickly
# versus writing a more well orchestrated, more elaborate and resillient analysis pathway


# splitting by more than one factor can be a good idea but it also pidgeon holes you
# if you split by year & month then you basically can only do monthly analysis. 
# what if you want to compare average annual temps to average monthly temps? 
# you would need to write two different for loops, one to calc year & another more months
# then a third to put it all together. 

# let's define a plotting function and then add it to our analysis:

plotMonthlyAverages = function(x){
	require(ggplot2)
	require(reshape2)
	melted = melt(x, id.vars=c("year", "month"))
	dev.new()
	ggplot(melted, aes(x=month, y=value, group=variable)) + 
		geom_line(aes(linetype=variable)) + 
		xlab("Month") + 
		ylab("Temperature (C)") + 
		ggtitle(paste("Month Temps for year 19", x$year[1], sep=""))
	ggsave(paste("MonthTemps_19", x$year[1], ".pdf", sep=""))
	dev.off()
}

results = list()
for(i in seq_along(years)){
	print(i)
	x = years[[i]]
	year = x$year[1]
	avgYearTemp = mean(as.numeric(x$air.temp.), na.rm = T)
	
	monthData = averageMonthTemp(x)
	monthData$year = year
	monthData$yearAvg = avgYearTemp

	plotMonthlyAverages(monthData) 	# pretty simple to add a graph if we wanted. 

	results[[i]] = monthData
}
resultsDF = do.call(rbind, results)



























