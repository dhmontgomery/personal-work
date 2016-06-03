## Create word clouds and a word count table for the Hamilton lyrics. Requires the code in prelim-code.R to have been run first to generate "alltext.txt".

## Load packages.
require(tm)
require(qdap)
require(stringr)
require(RColorBrewer)
require(koRpus)
require(SnowballC)
require(wordcloud)

##Calculate word lengths for each character
newtext <- read.delim(file="alltext.txt", head=FALSE,stringsAsFactors=FALSE, sep="\n") ## Read the file
newtext <- unlist(lapply(newtext, function(x) { str_split(x, "\n")})) ## Prepare for processing.
hamlyrics <- Corpus(VectorSource(newtext)) ## Load it as a corpus for the tm library.

## Process the lyrics for analysis
hamlyrics <- tm_map(hamlyrics, content_transformer(tolower)) ## Make everything lowercase
hamlyrics <- tm_map(hamlyrics, removeWords,stopwords("english")) ## Remove common English words like "and" and "the".
hamlyrics <- tm_map(hamlyrics, removePunctuation) ## Remove punctuation
hamlyrics <- tm_map(hamlyrics, stripWhitespace) ## Strip out unnecessary whitespace.

## Put the lyrics into a matrix and label the columns.
tdm <- TermDocumentMatrix(hamlyrics) ## Put the processed lyrics into a matrix with characters as columns.
tdm <- as.matrix(tdm)
colnames(tdm) <- c("Ensemble","Extra","Hamilton","Burr","Washington","Lafayette","Mulligan","Laurens","Jefferson","Madison","Philip","Angelica","Eliza","Peggy","Maria","George") ## Label the columns.

##
## The data is now prepared and ready to be analyzed.
##

## Produce word counts for each character:
colSums(tdm)

## Create a word cloud of whole show.

png("hamilton_cloud.png", width=600, height=600) ## Create the image file.
layout(matrix(c(1, 2), nrow=2), heights=c(.5, 4)) ## Lay out the image.
par(mar=rep(0, 4))
plot.new() ## Specify a new plot, just in case.
text(x=0.5, y=0.5, "Word frequency in \"Hamilton\" lyrics", cex=2, font=2) ## Title.
text(x=0.5, y=0.1, "By David H. Montgomery, dhmontgomery.com", cex=1) ## Subtitle/credit.
wordcloud(hamlyrics, ## Create the wordcloud
	max.words=250, ## Limit to the top 250 words in the show.
	random.order = FALSE, ## Display in frequency order.
	colors=brewer.pal(8,"Dark2") ## Pick a good ColorBrewer color scheme.
)
dev.off() ## Output the image.

## Now create distinct word clouds for each significant character.

names <- c("Ensemble","Extras","Alexander Hamilton","Aaron Burr","George Washington","Marquis de Lafayette","Hercules Mulligan","John Laurens","Thomas Jefferson","James Madison","Philip Hamilton","Angelica Schuyler","Eliza Schuyler","Peggy Schuyler","Maria Schuyler","King George") ## Put the character names into a list that we can iterate through. Importantly, these are in the same order as the lyrics-by-character in our data.
## Iterate through the 16 characters, creating a word cloud for each one.
for (i in 1:16){
	png(paste0(names[i],".png")) ## For each character, create a PNG file with that character's name.
	layout(matrix(c(1, 2), nrow=2), heights=c(1, 4)) ## Lay out the word cloud.
	par(mar=rep(0, 4)) 
	plot.new() ## Create a new cloud so we don't overwrite the last one.
	text(x=0.5, y=0.8, "Word frequency in \"Hamilton\" lyrics by:", cex=1.5) ## Add a title
	text(x=0.5, y=0.45, names[i], cex=3, font=2) ## Add the character's name from the appropriate position in the list of names.
	text(x=0.5, y=0.1, "By David H. Montgomery, dhmontgomery.com", cex=.8) ## Subtitle/credit.
	wordcloud(hamlyrics[i], ## For each character, draw the word cloud.
		max.words=150, ## Limit to his or her top 150 words. 
		rot.per=0, ## Display all the words horizontally, no rotation.
		random.order = FALSE, ## Sort them by frequency rather than randomly.
		colors=brewer.pal(8,"Dark2") ## Pick a good ColorBrewer color scheme.
	) 
	dev.off() ## Output the image, then loop through the rest of the characters.
	}