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
yoda = importData(myFiles)

# let's pause for a second, lines 6-29 do the same thing as lines 38-56
# so why take the time to learn how to use importData() ? 
# what happens if we add another file? 
# what happens when we change the file names?

years = split(yoda, yoda$year)

# let's keep our analysis simple, let's just find the average air temp and mer.winds for each year

for(i in seq_along())































