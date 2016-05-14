# MLB pitch visualization

An R script that, when given a year, team and pitcher, produces visualizations of every pitch thrown by that pitcher in that year for several different pitch outcomes. 

It will produce 18 different PNG graphs, three for each of six differnet pitch outcomes: called ball, foul, hit, batted out, swinging strike, called strike. For each outcome, it will produce one graph of all pitches, and then one graph each for just matchups vs. left-handed batters and right-handed batters.

The function takes three parameters, all expressed inside quotation marks:
<ul><li><b>"pitchyear"</b>, a four-digit year. PitchFX debuted in 2007 and gradually expanded; the further back in time, the greater the chance of errors or missing data.</li>
<li><b>"team"</b>, a three-character string reflecting the team's city: "bos", "sea", etc. For two-team cities, the third digit reflects the league: for example, "chn" instead of "chc"; "lan" instead of "lad".</li>
<li><b>"pitchername"</b>, the generally recognized first and last name of a pitcher. For example, "Jake Arrieta" instead of "Jacob Arrieta."</li></ul>

The script will take a few minutes to run, due to the large amount of data it needs to download.

Based on <a href="http://www.hardballtimes.com/a-short-ish-introduction-to-using-r-for-baseball-research/">a tutorial</a> by Bill Petti at The Hardball Times.

Examples of the outputs:

`> pitchviz("2015","chn","Jake Arrieta")`

![Jake Arrieta swinging strikes](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/pitchviz/images/Jake%20Arrieta2015_swingR.png)

`> pitchviz("2015","lan","Clayton Kershaw")`

![Kershaw swinging strikes](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/pitchviz/images/Clayton%20Kershaw2015_swingR.png)

`> pitchviz("2015","chn","Jon Lester")`

![Lester LHB balls](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/pitchviz/images/Jon%20Lester2015_ballL.png)
![Lester RHB balls](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/pitchviz/images/Jon%20Lester2015_ballR.png)
