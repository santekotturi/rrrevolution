rm(list = ls())

install.packages(c("twitteR", "ROAuth", "plyr", "stringr", "ggplot2"), dependencies = T)

library(twitteR)
library(ROAuth)
library(plyr)
library(stringr)
library(ggplot2)

# only Windows users need to do this:
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

cred <- OAuthFactory$new(consumerKey='<my key>',
						 consumerSecret='<Dont-you-want-to-know>',
					     requestURL='https://api.twitter.com/oauth/request_token',
						 accessURL='https://api.twitter.com/oauth/access_token',
						 authURL='https://api.twitter.com/oauth/authorize')
#mac && ?linux
cred$handshake()

#windows, I think these should work, but I can't test them
cred$handshake(cainfo= system.file("CurlSSL", "cacert.pem", package="RCurl"))
cred$handshake(cainfo="cacert.pem")
save(cred, file="twitter authentication.Rdata")

registerTwitterOAuth(cred)   # should return TRUE

# let's see how has a PR problem...

gTweets = searchTwitter("#google", n=1000)
iTweets = searchTwitter("#apple", n=1000)
#mTweets = searchTwitter("#micrsoft", n=1000)

gDF = twListToDF(gTweets)
iDF = twListToDF(iTweets)

write.csv(gDF, "gTweets.csv", row.names = F)
write.csv(iDF, "iTweets.csv", row.names = F)

gDF = read.csv("gTweets.csv", header = T, stringsAsFactors = F)
# gDF$text = as.factor(gDF$text)
iDF = read.csv("iTweets.csv", header = T)
# iDF$text = as.factor(iDF$text)

source("sentiment.r")

posWords = scan("positive-words.txt", what="character", comment.char=";")
negWords = scan("negative-words.txt", what="character", comment.char=";")

gSentiment = score.sentiment(gDF$text, posWords, negWords, .progress = "text")
iSentiment = score.sentiment(iDF$text, posWords, negWords, .progress = "text" )

# now for the vis:
library(ggplot2)
library(reshape2)

scores = as.data.frame(cbind(gSentiment$score,iSentiment$score))
colnames(scores) = c("google", "apple")
scores = melt(scores)

qplot(value, data=scores, geom="histogram")

q = ggplot(scores, aes(x=value)) + 
	geom_histogram(binwidth = 0.5) + 
	facet_grid(. ~ variable)


table(gSentiment$score)
table(iSentiment$score)

# there are exactly the same number of negative nancy's out there, 124 for each G and A. 
# however, the Google haters hate G more fervently than iSheep hate Apple. 



























