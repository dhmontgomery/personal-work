# 1872 French literacy rates, by department

Frederick Martin's <i>The Statesman’s Year-Book: Statistical and Historical Annual of the States of the Civilised World: Handbook for Politicians and Merchants for the year 1876</i> included, on page 60, a [table of literacy rates from the 1872 French census](https://books.google.com/books?id=xG8EAAAAQAAJ&pg=PA60#v=onepage&q&f=false). That census, taken immediately following the Franco-Prussian War and the fall of the Second Empire, showed striking trends with as many as 60 percent of the population of some French departments unable to read or write, and as few as six percent of others illiterate.

I mapped that literacy rate, and drew on several books about the time period to expand on the particualr tensions as France expanded universal, secular public education under the Third Republic in the late 19th Century. My essay, <i>[Alphabétisation](http://dhmontgomery.com/2015/07/alphabetisation/)</i>, also has an interactive version of this map:

![1872 French literacy](https://raw.githubusercontent.com/dhmontgomery/personal-work/master/1872-french-literacy/literacyfrance.png)

`illiteracy.csv` contains the raw data, taken from Martin's almanac. Department names in the spreadsheet are those existing in France in 1872, which are largely the same as the current departments, but with some exceptions:

- Territory lost to the Germans in 1871, and then regained after World War I, is missing. That means the modern-day departments of Bas-Rhin, Alsace and Moselle do not exist.
- Corsica was a single department, rather than being divided into Corse-du-Sud and Haute-Corse as it is today
- The modern-day Parisian departments of Paris, Hauts-de-Seine, Seine-Saint-Denis and Val-de-Marne were part of a single Seine department- The modern-day departments of Yvelines, Val-d'Oise and Essonne (along with a small portion of Val-de-Marne) were part of a Seine-et-Oise department.
- Several departments have the same boundaries but have been renamed, usually with the idea of eliminating potentially pejorative names like "inferior" and "lower."
  - Alpes-de-Haute-Provence was Basses-Alpes
  - Charente-Maritime was Charente-Inférieure
  - Côtes-d'Armor was Côtes-du-Nord
  - Loire-Atlantique was Loire-Inférieure
  - Pyrénées-Atlantiques was Basses-Pyrénées
  - Seine-Maritime was Seine-Inférieure

To create the map, I used QGIS to combine several sources of GIS map data:
- The background map of pre-World War I European boundaries was a map of Europe in 1900 from the [Max Planck Institute For Demographic Research Population History GIS Collection](http://censusmosaic.org/web/data/historical-gis-files)
- For French departments I used a map of modern-day departmental boundaries from the [GADM database](http://gadm.org), and edited the map to make the changes above.
  - This has led to one minor inaccuracy in the map: the boundaries of the Seine and Seine-et-Oise departments reflect the present-day boundaries of the departments they were split into. Therefore the small portion of Val-de-Marne that was part of Seine-et-Oise appears on this map as part of Seine.
