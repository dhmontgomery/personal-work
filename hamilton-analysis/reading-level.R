## Analyze the reading level for the Hamilton lyrics. This requires prelim-code.R to have been run to generate "alltext.txt", a text file with each character's lyrics on a distinct line.

## Load packages.
require(tm)
require(qdap)
require(stringr)
require(RColorBrewer)
require(koRpus)
require(SnowballC)
require(wordcloud)

## Put the character names into a list.
names <- c("Ensemble","Extras","Alexander Hamilton","Aaron Burr","George Washington","Marquis de Lafayette","Hercules Mulligan","John Laurens","Thomas Jefferson","James Madison","Philip Hamilton","Angelica Schuyler","Eliza Schuyler","Peggy Schuyler","Maria Schuyler","King George") 

ll.files <- read.delim(file="alltext.txt", head=FALSE,stringsAsFactors=FALSE, sep="\n")$V1 ## Read the data in, and collapse it from a data frame into a text block. 
ll.files <- unlist(lapply(ll.files, function(x) { str_split(x, "\n") })) ## Process for analysis.
ll.tagged <- lapply(ll.files, tokenize, lang="en", format="obj") ## More processing. This could take a few minutes.
ll.flesch <- lapply(ll.tagged,flesch.kincaid) ## Produce reading level analysis.
list_fk = lapply(ll.flesch, slot, 'Flesch.Kincaid') ## Extract the reading level analysis.
grades = as.data.frame(sapply(list_fk, "[[", "grade")) ## Generate a table with each character's reading level.
colnames(grades) <- "Flesch-Kinkaid score" ## Label the column.
rownames(grades) <- names ## Label the rows with character names.
write.table(grades, "flesch-hamilton.csv", sep = ",") ## Write the table into a CSV.