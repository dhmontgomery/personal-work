# Hamilton lyrical analysis

An lexical analysis of the lyrics in the cast album for the broadway show "Hamilton," produced for ["With every word, I drop knowledge: A lexical analysis of 'Hamilton'"](http://dhmontgomery.com/2016/03/with-every-word-i-drop-knowledge-a-lexical-analysis-of-hamilton/) at [dhmontgomery.com](http://dhmontgomery.com).

The four pieces of R code here will, given a proper database of "Hamilton" lyrics, produce for each character's lyrics:
* the total number of words
* a word cloud visualizing the most commonly used words
* the reading level of that character's vocabulary

It will also produce a ["fuzzy c-means cluster"](https://en.wikipedia.org/wiki/Fuzzy_clustering) analysis of the lyrics, which categorizes each character's lyrics by similarity and sorts them into a number of groups. (For similar c-means analysis, see my article for the St. Paul Pioneer Press, ["Mark Dayton’s State of the State: Big picture, plenty of data"](http://www.twincities.com/2016/03/08/mark-daytons-state-of-the-state-big-picture-plenty-of-data/) and the [technical explanation](http://www.twincities.com/2016/03/09/what-the-data-says-about-the-state-of-the-state-2/), and my inspiration, David Byler of RealClearPolitics' [analysis of presidential candidate vocabulary](http://www.realclearpolitics.com/articles/2015/07/20/text_mining_the_republican_announcement_speeches_127447.html).)

The `prelim-code.R` file will need to be run first to get the data in the appropriate files and formats. After that, `wordclouds.R`, `reading-level.R` and `cmeans.R` can be run in any order.

![Eliza/Angelica wordcloud](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/hamilton-analysis/eliza-angelica.png)

Note: this code may require an installation of [TreeTagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/) to run the koRpus package properly. i had considerable difficulty installing it, so if you want to run this code or a variant, I'd recommend trying it without TreeTagger first before attempting to install it.

Unfortunately for replicability of this analysis, the "Hamilton" lyrics are copyrighted, so I'm not republishing the database I created. To replicate my results you will need to recreate the dataset by following the steps below, which took me several hours. You can also adapt them to another corpus of words.

Here's how I produced the database you'll need:

1. On the show's [Genius.com page](http://genius.com/albums/Lin-manuel-miranda/Hamilton-original-broadway-cast-recording), I copied and pasted the lyrics into individual text files for each song. I simplified the lyrics in each text file so that each consecutive string of words sung or spoken by a single character was on a single line, headed by the character's name, such as: `[HAMILTON] Pardon me. Are you Aaron Burr, sir?`
2. I concatenated all the songs together into a single text file. (I used the Mac OS Terminal "cat" command.)
3. I converted the text file into a CSV, with the singer of a line in the leftmost column and the lyrics in the second column. In a series of further columns to the right, I hand-coded each line of lyrics by singer — but classified all the lines sung by non-major characters as either "Ensemble" or "Extra" (minor characters such as Seabury). Some lines were sung by more than one character, so a line by both Jefferson and Madison was marked as being a line for each of them. This gave me a spreadsheet called "hamiltonr.csv", the basis for the code in this project. This will need to be placed in your working directory to run the R code.
