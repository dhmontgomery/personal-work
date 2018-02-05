# Graphic Super Bowl game lengths

A pair of R scripts to pull down data on each Super Bowl game from [Pro Football Reference](https://www.pro-football-reference.com) and then to graph them.

- `scrape-data.R` will download and process the data from [Pro Football Reference](https://www.pro-football-reference.com/play-index/tgl_finder.cgi?request=1&match=game&year_min=1999&year_max=2017&game_type=P&playoff_round=s&game_num_min=0&game_num_max=99&week_num_min=0&week_num_max=99&temperature_gtlt=lt&c5val=1.0&order_by=duration)
- `graph-data.R` will produce three graphs based on the data. It also will run `scrape-data.R` to acquire the data necessary to make the graphs — no need to run it independently if all you want are the graphs.

Below are the graphs I produced from the scripts. Your output will look different, since these images were created using my personal ggplot theme, which is still in development and hasn't yet been released. 

![Super Bowl lengths graphed](https://github.com/dhmontgomery/personal-work/raw/master/super-bowl-lengths/superbowllengths.png)

![Super Bowl lengths vs. total plays](https://github.com/dhmontgomery/personal-work/raw/master/super-bowl-lengths/superbowlplays.png)

![Super Bowl lengths vs. total yards](https://github.com/dhmontgomery/personal-work/raw/master/super-bowl-lengths/superbowlyards.png)
