# all of these practice problems use the same El Nino data we already used
# to import the data make sure you have the data folder

# Your file hierarchy should look like: 
# rrrevolution
# --- lecture1
# --- lecture2
# --- lecture3
# --- lecture4
#		SET YOUR WORKING DIRECTORY HERE
# 		--- lecture4.r
# 		--- data
# 				--- 80sData
#						--- bunch of csv files
# 				--- 90sData
#						--- bunch of csv files

# with your working directory properly set you can use this import function to import your data

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

myFiles = list.files(pattern = ".csv", recursive = TRUE)
myData = importData(myFiles)

# verify that myData has 178080 rows and 12 columns:
dim(myData)
# [1] 178080     12


# now we can begin our SAT practice:

# 1) calculate the number of data points each year

# 2) calculate the average meridian wind speeds (mer.winds) for each year. 

# 3) calculate the average air temp for each month within in year. 
# note: it's probably easiest to split twice:
years = split(myData, myData$year)
for(i in seq_along(years)){
	x = years[[i]]
	months = split(x, x$month)
}

# alternatively you can split across both variables at once: 
monthsByYear = split(myData, list(myData$year, myData$month))
# check out how R names this list:
names(monthsByYear)






































