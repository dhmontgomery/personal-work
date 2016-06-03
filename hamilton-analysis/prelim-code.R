## Preliminary work to process the lyrics for further analysis and visualization.

require(tm)
require(qdap)
require(stringr)
require(RColorBrewer)
require(koRpus)
require(SnowballC)
require(wordcloud)

##First, set your working directory to the folder containing your lyric data. 

hamdata = read.csv("hamiltonr.csv")

##
## Begin the process of preparing the data:
##

## Subset out each singer's group of lyrics and collapse it into text.
ensembletxt = paste(subset(hamdata, ENSEMBLE==1, select =Lyric)[,1], collapse = " ")
extratxt = paste(subset(hamdata, EXTRA==1, select =Lyric)[,1], collapse = " ")
hamiltontxt = paste(subset(hamdata, HAMILTON==1, select =Lyric)[,1], collapse = " ")
burrtxt = paste(subset(hamdata, BURR==1, select =Lyric)[,1], collapse = " ")
washingtontxt = paste(subset(hamdata, WASHINGTON==1, select =Lyric)[,1], collapse = " ")
lafayettetxt = paste(subset(hamdata, LAFAYETTE==1, select =Lyric)[,1], collapse = " ")
mulligantxt = paste(subset(hamdata, MULLIGAN==1, select =Lyric)[,1], collapse = " ")
laurenstxt = paste(subset(hamdata, LAURENS==1, select =Lyric)[,1], collapse = " ")
jeffersontxt = paste(subset(hamdata, JEFFERSON==1, select =Lyric)[,1], collapse = " ")
madisontxt = paste(subset(hamdata, MADISON==1, select =Lyric)[,1], collapse = " ")
philiptxt = paste(subset(hamdata, PHILIP==1, select =Lyric)[,1], collapse = " ")
angelicatxt = paste(subset(hamdata, ANGELICA==1, select =Lyric)[,1], collapse = " ")
elizatxt = paste(subset(hamdata, ELIZA==1, select =Lyric)[,1], collapse = " ")
peggytxt = paste(subset(hamdata, PEGGY==1, select =Lyric)[,1], collapse = " ")
mariatxt = paste(subset(hamdata, MARIA==1, select =Lyric)[,1], collapse = " ")
georgetxt = paste(subset(hamdata, GEORGE==1, select =Lyric)[,1], collapse = " ")

## Combine all the lyrics into a single object and write it into a file, with each character's lyrics on a single massive line.
alltext = paste(ensembletxt,extratxt,hamiltontxt,burrtxt,washingtontxt,lafayettetxt,mulligantxt,laurenstxt,jeffersontxt,madisontxt,philiptxt,angelicatxt,elizatxt,peggytxt,mariatxt,georgetxt, sep = "\n")
write(alltext, "alltext.txt")

## Create a separate folder with a text file for each character, for later.
wd <- getwd() ## Store the current working directory for ease of use later.
dir.create("cmeans") ## Create the folder in the working directory. If it already exists, it will throw an error but continue.
setwd("cmeans") ## Set this folder as our working directory.

## Write the text files
write(ensembletxt,"ensembletxt.txt")
write(extratxt,"extratxt.txt")
write(hamiltontxt,"hamiltontxt.txt")
write(burrtxt,"burrtxt.txt")
write(washingtontxt,"washingtontxt.txt")
write(lafayettetxt,"lafayettetxt.txt")
write(mulligantxt,"mulligantxt.txt")
write(laurenstxt,"laurenstxt.txt")
write(jeffersontxt,"jeffersontxt.txt")
write(madisontxt,"madisontxt.txt")
write(philiptxt,"philiptxt.txt")
write(angelicatxt,"angelicatxt.txt")
write(elizatxt,"elizatxt.txt")
write(georgetxt,"georgetxt.txt")

## Return to the prior working directory.
setwd(wd)