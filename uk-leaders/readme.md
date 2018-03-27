# Analyzing British monarchs and prime ministers

This sub-repository contains data about British monarchs and prime ministers, and code to analyze it and visualize it. You can read my take on the code in my blog post "[Long lives the queen](http://dhmontgomery.com/2018/03/long-lives-the-queen/)."

All of the code and data here is released under the [MIT License](https://github.com/dhmontgomery/personal-work/blob/master/LICENSE), available for free reuse subject to credit and maintenance of the license.

`uk_monarchs.csv` contains basic bigraphical information for each monarch of England and Breat Britain dating back to the [Restoration](https://en.wikipedia.org/wiki/Restoration_(1660))

`uk_prime_ministers.csv` contains basic biographical information on every prime minister from Robert Walpole through to Theresa May.

Currently living prime ministers and monarchs have no information listed for date of death.

The R script `longlivesthequeen.R` will do several things:

- Load the above spreadsheets and temporarily fill in the current day as the "deathdate" and end of reign/term for all monarchs and prime ministers, then calculate lifespans and reign/term lengths based on that
- Run a nifty loop to calculate how many days each prime minister's lifespan overlapped with each monarch's time on the throne
- Format the data for graphic
- Produce several graphs about the monarchs and prime ministers, versions of which are in the `images` folder, such as:

![Monarch lifespan](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/uk-leaders/images/plot_lifespan.png)

And:

![PM lifespans](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/uk-leaders/images/plot_timeline.png)

Finally, this folder contains `uk-pop-pyramid.csv`, a spreadsheet of the UK population by age [from the Office for National Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationprojections/bulletins/nationalpopulationprojections/2016basedstatisticalbulletin). This data will be used by `longlivesthequeen.R` to create a British population pyramid with those born before and during Queen Elizabeth II's reign broken out:

![UK population pyramid](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/uk-leaders/images/poppyramid.png)
