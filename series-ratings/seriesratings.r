# R script to scrape World Series ratings off Wikipedia, process the data, and graph it for a historical perspective.
# Created by David H. Montgomery, dhmontgomery.com

library(rvest)
library(tidyverse)
library(stringr)


# Scrape the data
url <- "https://en.wikipedia.org/wiki/World_Series_television_ratings" # Set the URL
ratings <- url %>%
	read_html() %>%
	html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>% # Point to the right table on the page via its xpath ID
	html_table(fill = TRUE) %>% # Fill out any missing cells 
	`[[`(1) %>% # Extract the data frame from the list created above
	filter(Year != 1994) %>% # Remove the cancelled 1994 World Series
	select(-`Avg.`) %>% # Drop average column
	gather("game", "viewers", 4:10) %>% # Reshape data
	# Clean the data
	mutate(viewers = viewers %>% 
		   	str_remove_all("\\[[0-9]{1,2}\\]") %>% # Remove footnoted brackets
		   	str_remove_all("No Game")) %>% 
	# Split up our cell into separate ratings, shares and total viewers
	separate(viewers, c("rating", "share"), sep = "/", fill = "right", convert = TRUE) %>% # Separate on the "/"
	separate(share, c("share", "viewers"), convert = TRUE, sep = "\\(") %>% # Separate on the open parentheses
	separate(viewers, c("viewers"), sep = " ", extra = "drop", convert = TRUE) %>% # Separate on the first space, dropping extras
	separate(viewers, c("viewers"), sep = "\\–", extra = "drop", convert = TRUE) %>% # One year's rating was given as a range. Take the lower number
	filter(!is.na(rating)) # Clean up empty rows

# Graph the ratings
a <- ggplot(ratings, aes(Year, viewers)) + # Plotting year vs. raw numbers
	geom_smooth() + # Add a smoothing line
	geom_point(size = 2, aes(color = game)) + # Increase the point size and color points by which game of the Series they were
	# Add a title, subtitle, caption, y-axis
	labs(title = "World Series ratings (1984-present)",
		 subtitle = "By David H. Montgomery, dhmontgomery.com",
		 caption = "Data from wikipedia.org/wiki/World_Series_television_ratings",
		 y = "Millions of viewers") +
	theme_bw() # Set a clean theme
ggsave("ratings.png", plot = a, width = 10) # Save the file

# Graph it, but faceted by game of the series
b <- ggplot(ratings, aes(Year, viewers)) +
	geom_point(size = 2) + # No smoothing surve. No colors
	labs(title = "World Series ratings (1984-present)",
		 subtitle = "By David H. Montgomery, dhmontgomery.com",
		 caption = "Data from wikipedia.org/wiki/World_Series_television_ratings",
		 y = "Millions of viewers") +
	theme_bw() +
	facet_wrap(vars(game), nrow = 1) # Facet the chart by game
ggsave("ratings-facet.png", plot = b, width = 10) # Save the faceted image file
