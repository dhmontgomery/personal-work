library(tidyverse)
library(rvest)
library(lubridate)


superbowls <- "https://www.pro-football-reference.com/play-index/tgl_finder.cgi?request=1&match=game&year_min=1999&year_max=2017&game_type=P&playoff_round=s&game_num_min=0&game_num_max=99&week_num_min=0&week_num_max=99&temperature_gtlt=lt&c5val=1.0&order_by=duration" %>% # Take the URL with the data table
	read_html() %>% # Read it as HTML
	html_nodes(xpath = '//*[@id="results"]') %>% # Identify the part of the page with the actual table
	html_table(header = FALSE) # Convert as HTML. 
	# (No header since the table has a two-line header we need to deal with)

superbowls <- superbowls[[1]] # Extract the table from a list object
# Add column names 
names(superbowls) <- c("rank", "team", "year", "date", "time", "localtime", "X7", "opponent", "week", "g#", "day", "result", "ot", "yards", "off_plays", "yards_play", "def_plays", "d_yards_play", "turnovers", "possession_time", "duration")

# Process the data, which was all imported in character format
superbowls <- superbowls %>% 
	mutate(rank = as.numeric(rank)) %>% # Convert the "rank" column to numeric
	filter(!is.na(rank)) %>% # Remove all rows that don't have numeric ranks, aka non-data
	mutate(year = as.numeric(year) +1, # Convert year to when the game was played, not which season it was for
		   date = as.Date(date), # Convert the date to a date object
		   time = paste0(date, " ", time, " PM") %>% as.POSIXct(tz = "US/Eastern"), # Convert gametime to a time object
		   yards = as.numeric(yards),
		   off_plays = as.numeric(off_plays),
		   yards_play = as.numeric(yards_play),
		   def_plays = as.numeric(def_plays),
		   d_yards_play = as.numeric(d_yards_play),
		   turnovers = as.numeric(turnovers),
		   # Convert possession time and duration to duration objects, then into numerics
		   possession_time = ms(possession_time) %>% as.duration() %>% as.numeric("minutes"),
		   duration = hm(duration) %>% as.duration() %>% as.numeric("hours")
	)