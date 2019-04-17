# Load libraries
library(rvest)
library(tidyverse)
library(ggrepel)
library(scales)
library(stringr)
library(grid)
library(lubridate)
source("http://peterhaschke.com/Code/multiplot.R") # Load a function to plot multiple ggplot charts

# Download ballpark capacity
url <- "https://en.wikipedia.org/wiki/List_of_Major_League_Baseball_stadiums"
capacity <- url %>%
	read_html() %>%
	html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>%
	html_table() %>%
	`[[`(1) %>%
	mutate_at(vars(3, 6), ~str_remove_all(., "\\[[^\\]]*\\]")) %>%
	mutate_at(vars(3), ~str_remove_all(., ",") %>% as.numeric()) %>%
	arrange(Team)

# Download attendance data
url <- "http://www.espn.com/mlb/attendance" # Set the URL of the page
attendance <- url %>% 
	read_html() %>%
	html_nodes(xpath='//*[@id="my-teams-table"]/div/div/table') %>% # Select the table
	html_table() %>%
	`[[`(1) %>%
	set_names("Rank2016","Team","HomeGames","HomeTotal","HomeAverage","HomePct","RoadGames","RoadAverage","RoadPct","OverallGames","OverallAverage","OverallPct") %>% # Label the columns
	slice(-c(1:2)) %>%
	mutate_at(vars(4, 5, 8, 11), ~str_remove_all(., ",")) %>%
	mutate_at(vars(1, 3:12), as.numeric) %>%
	arrange(Team) %>%
	bind_cols(capacity %>% select(Capacity)) %>%
	mutate(HomePct = HomeAverage / Capacity,
		   Abbrev = c("ARI","ATL","BAL","BOS","CHC","CHW","CIN","CLE","COL","DET","HOU","KCR","LAA","LAD","MIA","MIL","MIN","NYM","NYY","OAK","PHI","PIT","SDP","SFG","SEA","STL","TBR","TEX","TOR","WSN")) # Add three-letter labels for each team, for the plotting

a <- ggplot(attendance, aes(HomeAverage,HomePct)) + # Make the first graph, attendance vs. percent attendance
    geom_point(size=1) + # Tiny points
    geom_text_repel( # This plots the labels, but around the points.
    	aes(label=Abbrev), 
    	size = 3) + # Set the font size
	scale_x_continuous(labels=comma, # Insert commas into the x-axis labels
					   breaks=c(15000,25000,35000,45000,55000)) + # Set the breaks
	scale_y_continuous(labels=percent_format(accuracy = 1)) + # Convert the y-axis into percentages.
	labs(title = paste0( # Title the plot dynamically
		year(Sys.Date()), # The current year
		" MLB home attendance vs. capacity (through ",
		strftime(Sys.Date()-1, format = "%m/%d"), # Yesterday
		")"),
		y = "Attendance as percent of capacity") +
	theme(axis.title.x = element_blank())
    	

b <- ggplot(attendance, aes(HomeAverage,Capacity)) + # Make the second graph, attendance vs. capacity
    geom_point(size=1) + # Tiny points
    geom_text_repel(aes(label=Abbrev), size = 3) + #Set the font size
    scale_x_continuous(labels=comma, breaks=c(15000,25000,35000,45000,55000)) +
	scale_y_continuous(labels=comma_format(scale = 0.001, suffix = "K"), limits=c(20000,60000)) +
	labs(caption = "By David Montgomery, github.com/dhmontgomery",
		 x = "Average home attendance",
		 y = "Ballpark capacity")

# Save as a square PNG
ggsave("attendance.png",plot=multiplot(a,b), device="png", height=10, width=10)
	
attendance %>% select(2:6) %>% write_csv("mlb-attendance.csv")
