# World Series ratings visualizer

An R script that will scrape data about World Series ratings from Wikipedia, and then graph it.

It will produce two ggplot charts: one [graphing the total viewers](https://github.com/dhmontgomery/personal-work/blob/master/series-ratings/ratings.png) of each World Series game, and one [faceted](https://github.com/dhmontgomery/personal-work/blob/master/series-ratings/ratings-facet.png) by which game of the Series it was.

![Base plot](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/series-ratings/ratings-small.png)

![Facet plot](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/series-ratings/ratings-facet-small.png)

Note that this script requires Version 2.2 of ggplot2 to properly handle subtiles and captions; an install package link is included in the script. Once this is officially released I will update this package to point to the stable version.
