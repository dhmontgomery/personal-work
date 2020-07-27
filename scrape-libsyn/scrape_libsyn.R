# The podcast host Libsyn has great download stats, but it can be tricky to get the data off Libsyn into a spreadsheet
# In particular, the data I often want in a spreadsheet is downloads per episode per day 
# After some trial and error, I wrote this R function to do that for you
# scrape_libsyn() takes four inputs:
## `show_id`` is a unique ID number for your show that can be tricky to get. 
### I found mine by visiting the Stats page, viewing the source code, and searching for "filterId"
## `state_date` is the first day of stats you want to pull — probably your Episode 1 release date.
### This should be in format "YYYY-MM-DD"
## `username` is the email address you use as your username to log in to Libsyn
## `password` is your password
# The script will save an object, `episode_data`, to your global environment, with each episode's data
# It will save another object, `overall_data`, with summary data for each episode
# It will also write a CSV file to your current working directory, titled `episode_data_YYYY-MM-DD.csv`, with today's date
# This code was written by David H. Montgomery and is released under the MIT License.

# Load necessary libraries
library(tidyverse)
library(lubridate)
library(rvest)
library(jsonlite)

scrape_libsyn <- function(show_id, start_date, username, password) {
	# Log in to Libsyn
	url <- "https://login.libsyn.com/" %>% repair_encoding(from = "ISO-8859-1") # Store & format the login URL
	session <- html_session(url) # Create a browser session and navigate to the page
	form <- rvest:::html_form.session(session)[[2]] # Extract the login fields
	fill_form <- set_values(form, email = username, password = password) # Fill them with our credentials
	fill_form$url <- "/" # You have no idea how long it took me to realize this would fix a weird bug
	submit_form(session, fill_form) # Submit our credentials and log in!
	
	# Download a list of all your episodes and their IDs
	## Build our URL for our overall episode summary data 
	overall_url <- paste0("https://four.libsyn.com/statistics/display-ajax-table-data/data_type/totals/filter_type/show/filter_id/",
						  show_id,
						  "/metric/item/date_begin/",
						  start_date,
						  "/date_end/",
						  today(),
						  "/order/released_date/direction/desc/export/true")
	## Visit our data and process it into a dataframe
	overall_data <<- jump_to(session, overall_url) %>% # Navigate our browser to the data 
		html_nodes(xpath = "/html/body/p") %>% # Locate the data on the page
		str_remove_all("<p>|</p>") %>% # Strip out HTML formatting
		fromJSON() %>% # Extract it from JSON
		as_data_frame() %>% # Convert from matrix to data frame
		set_names("item_id", "title", "released", "downloads") %>% # Name columns
		mutate(mergename = str_remove_all(title, " |:")) %>% # Create a cleanly formatted episode name
		## Extract just the first part of the title, the "Episode X" part without the title
		separate(col = title, into = c("title"), sep = ":", extra = "drop") %>% 
		## Create a column with the unique URL for each episode's stats
		mutate(url = paste0("https://four.libsyn.com/statistics/display-ajax-table-data/data_type/day/filter_type/item/filter_id/",
							item_id,
							"/metric/day/date_begin/",
							start_date,
							"/date_end/",
							today(), 
							"/order/metric/direction/desc/export/true"))
	
	# Download data on all of your episodes
	
	## Iterate through each episode with map() and download its ddata
	## This could take a few minutes if you have lots of episodes
	episode_data <<- map(overall_data$url, ~jump_to(session, .x)) %>% # For each episode, visit its URL
		map(html_nodes, xpath = "/html/body/p") %>% # Navigate to the right part of the page
		map(str_remove_all, "<p>|</p>") %>% # Strip HTML formatting
		map(fromJSON) %>% # Extract from JSON
		map(as_data_frame) %>% # Convert to data frame
		map(set_names, "date", "downloads") %>% # Name columns
		map2(overall_data$title, ~mutate(.x, title = .y)) %>% # Add episode titles to our data
		reduce(bind_rows) %>% # Reduce all our individual episode dataframes into one
		## Join in the the release date
		left_join(overall_data %>% 
				  	select(title, released),
				  by = "title") %>%
		## Formatting and some calculations
		mutate(released = mdy(released)) %>% # Convert release date to date format
		mutate(date = as_date(date)) %>% # Convert download date to date format
		mutate(days = date - released + 1) %>% # Calculate each download date's days since release
		filter(days > 0) %>% # Remove lines before an episode's release
		## Calculate cumulative downloads
		group_by(title) %>% # Group by episode
		arrange(date) %>% # Sort by date
		mutate(cumulative_dl = cumsum(downloads)) # Fill in a cumulative downloads column
	
	# Save episode download data to your working directory
	write_csv(episode_data, paste0("episode_data_", today(), ".csv"))
	
}