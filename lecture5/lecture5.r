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








