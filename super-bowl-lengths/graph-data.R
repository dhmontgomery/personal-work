# Produces three graphs of Super Bowl durations
# Data is acquired by calling another script

library(tidyverse)
library(scales)
library(lubridate)

source("https://raw.githubusercontent.com/dhmontgomery/personal-work/master/super-bowl-lengths/scrape-data.R") # Run the data-scraper

# Plot durations by year
ggplot(superbowls, aes(year, duration, color = ot)) +
	geom_point() +
	# theme_dhm() + # Personal ggplot theme still in development
	scale_x_continuous(breaks = seq(2000, 2018, 2)) + # Set x-axis scale
	# Add a legend for OT games
	scale_color_manual(values = c("black", "red"), breaks = "OT", labels = "Game went into overtime") +
	labs(title = "Length of Super Bowls 2000-2018",
		 subtitle = "Source: Pro Football Reference",
		 y = "Duration (hours)",
		 x = "Year game was played",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 color = "")

# Plot durations vs. total yards
superbowls %>% 
	filter(year != 2013) %>% # Remove "Blackout Bowl" outlier
	# Each game has rows for both teams, so we have to combine them
	group_by(year, duration) %>%
	summarize(yards = sum(yards)) %>%
	# Plot
	ggplot(aes(yards, duration)) +
	geom_point() + 
	geom_smooth() + # Add smoothing line
	# theme_dhm() + # Personal ggplot theme still in development
	labs(title = "Super Bowl duration vs. total yardage",
		 subtitle = "Source: Pro Football Reference. 2013 'Blackout Bowl' omitted.",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 x = "Total yardage",
		 y = "Duration (hours)")

# Plot durations vs. total plays
superbowls %>% 
	filter(year != 2013) %>% # Remove "Blackout Bowl" outlier
	# Each game has rows for both teams, so we have to combine them
	group_by(year, duration) %>% 
	summarize(off_plays = sum(off_plays)) %>%
	ggplot(aes(off_plays, duration)) +
	geom_point() +
	geom_smooth() + # Add smoothing line
	# theme_dhm() + # Personal ggplot theme still in development
	labs(title = "Super Bowl duration vs. total plays",
		 subtitle = "Source: Pro Football Reference. 2013 'Blackout Bowl' omitted.",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 x = "Total plays",
		 y = "Duration (hours)")