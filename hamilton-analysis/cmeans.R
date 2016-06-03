## Conduct a fuzzy c-means analysis of the Hamilton lyrics. Requires the code in prelim-code.R to have been run first to generate the "cmeans" folder and the character text files in it. The working directory must be the folder one level above "cmeans" (or the "cmeans" folder itself, though this will throw an error). 

## Load packages.
library(tm)
library(e1071)

setwd("cmeans") ## Set the working directory to the "cmeans" folder.
wd <- getwd() ## Store this working directory.
docs <- Corpus(DirSource(getwd())) ## Define our corpus as all the text files in the "cmeans" folder.

## Process the data: get it lower case, remove punctuation, remove numbers and common words 
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, "applause")
docs <- tm_map(docs, stemDocument, language = "english")

## More processing.
tdm <- TermDocumentMatrix(docs) ## Convert the data into a matrix.
colnames(tdm) <- c("Angelica Schuyler", "Aaron Burr", "Elizabeth Schuyler", "Ensemble", "Extras", "King George", "Alexander Hamilton", "Thomas Jefferson", "LaFayette", "John Laurens", "James Madison", "Hercules Mulligan", "Philip Hamilton", "George Washington") ## Label the columns with character names.
tdm_sparse <- removeSparseTerms(tdm, .7) ## Remove sparse terms. The .7 parameter here is a judgment call, feel free to experiment with different values.

## Produce the cmeans analysis.
c_means <- cmeans(t(tdm_sparse), 3) ## Run the analysis, producing three groups. The 3 parameter can also be experimented with.
c_means$membership ## Display a table containing the characters by groups. Skip this if you want, we will write it to a CSV file in the next two steps.
setwd("..") ## Move the working directory up one level — saving the CSVs in the "cmeans" folder can mess up future runs of the code.
write.csv(c_means$membership, "cmeansmembers.csv") ## Save the groups as a CSV.
write.csv(t(c_means$centers), "cmeanscenters.csv") ## Save the "centers" showing which words fall into each categories. This is useful for figuring out what the different groups mean.
