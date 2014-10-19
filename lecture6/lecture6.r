# all about graphing and data visualization
# R has a built in set of graphing abilities but they're pretty weak
# ggplot2 is an awesome library for creating powerful graphs quickly. 
# to install: 
install.packages("ggplot2")
install.packges("plyr")
install.packages("reshape2")
# and load it into R when you want to use it:
library(ggplot2)

# but before we can plot data in R, ggplot works best when your data is in long aka narrow format. Most of us are used to storing our data in wide format. 
# we need to learn what the difference is and how to convert our data into long format
# overview: http://en.wikipedia.org/wiki/Wide_and_narrow_data

# we're used to this where each variable is stored in it's own column: 
wideData <- read.table(header=T, text='
 subject sex control cond1 cond2
       1   M     7.9  12.3  10.7
       2   F     6.3  10.6  11.1
       3   F     9.5  13.1  13.8
       4   M    11.5  13.4  12.9
 ')

# but ggplot will be much easier and more powerful if we store our data like this: 
longData <- read.table(header=T, text='
 subject sex condition measurement
       1   M   control         7.9
       1   M     cond1        12.3
       1   M     cond2        10.7
       2   F   control         6.3
       2   F     cond1        10.6
       2   F     cond2        11.1
       3   F   control         9.5
       3   F     cond1        13.1
       3   F     cond2        13.8
       4   M   control        11.5
       4   M     cond1        13.4
       4   M     cond2        12.9
 ')

# why do we need to do this? Because ggplot expects you tell you what variable you want plotted on the x-axis. 
# if you want to see how each condition compares, you need to store all of that in one column
# fortunately there's a function for going from wide to long (melt) and from long to wide (dcast)

longData = melt(wideData, id.vars=c("subject","sex"), measure.var=c("control", "cond1", "cond2"))

# you should start thinking about your data as either an id.vars or a measure.vars. 
# columns like "subjectID", "timepoint", "group", "class" etc are typically id.vars
# while measure.vars are actual data points. 

# you can be more specific with melt: 
longData <- melt(wideData,
                  # ID variables - all the variables to keep but not split apart on
                  id.vars=c("subject","sex"),
                  # The source columns
                  measure.vars=c("control", "cond1", "cond2" ),
                  # Name of the destination column that will identify the original
                  # column that the measurement came from
                  variable.name="condition",
                  value.name="measurement"
)

library(ggplot2)

# basic structure of a plot: 
ggplot(df, aes(x, y, <other aesthetics>))
# where df is your data and aes specificies your aesthetics. 
# aes (stands for aesthetics) is the meat/logic of your graph.
# It contains things like: what data should be on the x-axis, y-axis, how data should be grouped
# for a couple list: http://stackoverflow.com/questions/11657380/is-there-a-table-or-catalog-of-aesthetics-for-ggplot2

graph1 = ggplot(longData, aes(x = subject, y = measurement, fill = condition))

# Same as: 
graph1 = ggplot(longData, aes(x = subject, y = measurement, fill = condition))
graph1 = graph1 + geom_bar(stat="identity")

# stacking graphs can sometimes be good, but facets can typically help achieve your goals: 
graph1 = graph1 + facet_wrap( ~ condition)

graph2 = ggplot(longData, aes(x = condition, y = measurement, group = subject)) + 
            geom_line(aes(color = subject))
# almost there, our colors seem weird, its a gradient because it thinks that subject 1-4 is a continuous variable. 
class(longData$subject)
# confirms this. 

# we can force R to handle these IDs as factors:

graph2 = ggplot(longData, aes(x = condition, y = measurement, group = subject)) + 
            geom_line(aes(color = as.factor(subject)))

graph2 = graph2 + geom_point()   

# get the colors to match:
graph2 = graph2 + geom_point(aes(color=factor(subject), shape=factor(subject)))   


# adding standard error bars is pretty common and some functions have been written to help us. 
# in this same folder there's a summarySE.r file, the same code is also at the bottom of this script. 
# summarySE() is a function written by Winston Chang: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/

# we can't use our current longData because it only contains 1 data point per measurement. 
# here's longData2 which contains 2 datapoints per measurement which will allow us to divide by N-1
longData2 <- read.table(header=T, text='
 subject sex condition measurement
       1   M   control         7.9
       1   M     cond1        12.3
       1   M     cond2        10.7
       2   F   control         6.3
       2   F     cond1        10.6
       2   F     cond2        11.1
       3   F   control         9.5
       3   F     cond1        13.1
       3   F     cond2        13.8
       4   M   control        11.5
       4   M     cond1        13.4
       4   M     cond2        12.9
       1   M   control         8.1
       1   M     cond1        12.1
       1   M     cond2        10.9
       2   F   control         6.6
       2   F     cond1        10.6
       2   F     cond2        11.2
       3   F   control         9.1
       3   F     cond1        13.3
       3   F     cond2        13.6
       4   M   control        11.2
       4   M     cond1        13.1
       4   M     cond2        12.2
 ')

library(plyr)
summarized = summarySE(longData2, measurevar="measurement", groupvars=c("subject","condition"))

graph3 = ggplot(summarized, aes(x=condition, y=measurement, group=subject)) + 
    geom_errorbar(aes(ymin=measurement-se, ymax=measurement+se, color= as.factor(subject)), width=.1) +
    geom_line(aes(color = as.factor(subject))) +
    geom_point(aes(color=as.factor(subject))) 


# let's tidy this graph up making it look more professional: 
# axes and title: 
graph3 = graph3 + 
		 xlab("Condition") + 
		 ylab("Amout Measured") + 
		 ggtitle("Subject by Condition w/ SE bars")

# tweaking axes scales: THIS CAN BE REALLY IMPORTANT. 
# IF YOU RELY ON R TO SCALE YOUR AXES, IT WILL THE GRAPH TO YOUR DATA AND CAN BE MISLEADING
# I RECOMMEND FIRST PLOTTING ALL YOUR DATA TO SEE WHAT RANGE WILL FIT ALL YOUR DATA
# THEN HARDCODE SOME LIMITS...
graph3 + scale_y_continuous(limits=c(4, 16))
graph3 = graph3 + scale_y_continuous(limits=c(4, 16))

# legend:
graph3 = graph3 + 
         scale_colour_hue(name="Subjects", 
         	labels=c("Subject 01", "Subject 02", "Subject 03", "Subject 04"))


# themes and saving
# you can personalize every aspect of the graph: http://docs.ggplot2.org/0.9.2.1/theme.html
graph3 + theme(panel.background = element_rect(colour = "pink"))

graph3 = graph3 + theme_bw()

ggsave("Subject_Condition_SEbars.pdf")



# full list of functions: http://docs.ggplot2.org/0.9.3.1/index.html





# ggplot and R graphing resources: 
http://www.cookbook-r.com/Graphs/
http://ggplot2.org/book/










# summarySE() : 

## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}

