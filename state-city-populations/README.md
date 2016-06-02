# Logarithmic populations and ranks for all cities in each state
I <a href="http://dhmontgomery.com/2014/03/primates-of-the-states/">analyzed each state by the share of its population contained in each city</a>.

This repository contains a CSV (`logs.csv`) containing for each state the population of each official city on a logarithmic scale, and the population rank of each state's city on a logarithic scale. It also contains R code (`state-log-population.R`) to produce a small multiple graph showing the log of the population of each state's cities vs. the log of the population rank of each state's cities.

To run, the working directory must first be set to the folder containing `logs.csv`.

Output:

![State graphs](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/state-city-populations/stateplot.png)
