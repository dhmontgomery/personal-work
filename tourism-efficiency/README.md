# State tourism efficiency data
Piggybacking off <a href="https://www.washingtonpost.com/opinions/best-state-in-america-indiana-for-attracting-tourists/2014/07/31/f672cbd2-1809-11e4-9349-84d4a85be981_story.html">work for the Washington Post</a> by Reid Wilson, I <a href="http://dhmontgomery.com/2014/08/deceptively-efficient-at-attracting-tourism">analyzed which states have the most efficient tourism promotion</a>.
Because of the way tourist data is calculated, there's an almost perfect relationship between a state's population and spending by tourists. So ignoring population and just comparing tourist spending to promotional budgets, as Wilson did, makes larger states look more efficient and smaller states less efficient. I account for this by using per capita figures.
(I also explored whether the population of a state's neighbors correlates with tourist spending, and to my surprise found there was essentially no correlation.)
The spreadsheet "tourismspending.csv" contains the following data for all 50 states:
<ul><li>"state": The two-letter abbreviation for each state.</li>
<li>"fullstate": The full name of each state.</li>
<li>"totalspending": Total tourist spending in 2013, provided by the U.S. Census Bureau from numbers calculated by the U.S. Travel Association, an industry group.</li>
<li>"population": The state's 2010 Census population.</li>
<li>"tourismbudget": The state's Fiscal Year 2012-13 tourism promotion budget, as calculated by the U.S. Travel Association, in dollars. Washington State does not have a tourism promotion budget.</li>
<li>"tourismbudgetk": The "tourismbudget" column, in thousands of dollars.</li>
<li>"spendingpercap": "totalspending" divided by "population."</li>
<li>"spendingperdollar": "totalspending" divided by "tourismbudget."</li>
<li>"percapperdollar": "totalspending" divided by "population" divided by "tourismbudgetk." Numbers should be read as per capita tourist spending per thousand budget dollars.</li>
<li>"borderpop": The population of the state, plus the populations of all states bordering it. Does not include populations living in neighboring countries. For Alaska and Hawaii this population is simply that of the state alone.</li>
