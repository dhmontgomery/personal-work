# R script to analyze and visualize tweets from @dog_rates.
# Working directory must be in the same folder as `dog_rates_tweets.csv` to function
# Created by David Montgomery, dhmontgomery.com. Released under the MIT License.

# Load libraries
library(tidyverse)
library(stringr)
library(rlist)
library(lubridate)
library(scales)

dogrates <- read.csv("dog_rates_tweets.csv", stringsAsFactors = F) # Load the CSV
dogrates$text <- substr(dogrates$text, 3, nchar(dogrates$text)-1) # Remove some extra characters
dogrates <- filter(dogrates, substr(dogrates$text, 1, 1) != "@") # Remove replies
dogrates <- filter(dogrates, substr(dogrates$text, 1, 2) != "RT") # Remove retweets
dogrates <- dogrates %>% filter(str_detect(text, "/10")) # Remove tweets without ratings out of 10
# Split the text of each tweet along the character string "/10"
dogrates$rate <- str_split_fixed(dogrates$text, "/10", 2) 
dogrates$rate <- lapply(dogrates$rate, list.first)[1:1209] # Select just the first half of each tweet
# Remove some characters that sometimes precede out dog ratings, replacing them with spaces
dogrates$rate <- str_replace_all(dogrates$rate, "n"," ")
dogrates$rate <- str_replace_all(dogrates$rate, "[...]"," ")
dogrates$rate <- str_replace_all(dogrates$rate, "[(]"," ")
dogrates$rate <- word(dogrates$rate, -1) # Select the final word of each string — the numeric rating
dogrates$rate <- as.numeric(dogrates$rate) # Convert this final word from characters to numbers
dogrates$created_at <- as_date(dogrates$created_at) # Convert the data string to data format
dogrates[292,4] <- 9.75 # Hand-code one rating that didn't translate right

dogrates <- filter(dogrates, rate <= 20) %>% arrange(created_at) # Exclude an outlier ("1776/10")
dogrates <- dogrates %>% filter(created_at > "2015-12-31") # Remove a handful at the very end of December 2015 for clarity's sake
# Extract month and year from the date
dogrates <- dogrates %>% mutate(month = format(created_at, "%m"), year = format(created_at, "%Y")) 
# Create a new data frame with monthly results
monthly <- dogrates %>% # Start with the original data frame
    group_by(year, month) %>% # Group by year and month
    summarize(
        average = mean(rate), # Set one column equal to the mean for each month
        nratings = n(), # Set another equal to the total number of raitngs
        u10 = sum(rate < 10), # Set another equal to the number of ratings below 10
        u10pct = u10/nratings) %>%  # Set a final column equal to the percent of ratings under 10 in a given month
    mutate(yearmon = as_date(paste0(year,"-",month,"-01"))) # Create a unique identifier column for each month
# Calculate the average monthly ratings for just ratings 10 or higher
o10monthly <- dogrates %>% filter(rate >= 10) %>% # Exclude ratings below 10
    group_by(year, month) %>% # Group by year and month
    summarize(average = mean(rate), nratings = n()) %>% # Calculate average and total
    mutate(yearmon = as_date(paste0(year,"-",month,"-01"))) %>% # Format the date
    ungroup() # Clean up to avoid an annoying warning message
# Merge this old chart with our original monthly chart
monthly <- monthly %>% # Start with the original chart
    ungroup() %>% # Clean up
    select(yearmon, average, nratings, u10, u10pct) %>% # Select just the key columns
    left_join(o10monthly %>% select(yearmon, o10average = average), by = "yearmon") # Merge
# Convert from a wide spreadsheet into a tall spreadsheet
monthlytall <- monthly %>% select(yearmon, average, o10average) %>% gather(type, average, 2:3)

# First graph: All ratings
ggplot(dogrates, aes(created_at, rate)) +
    geom_hline(yintercept = 10, color = "red", size = 0.7) +
    geom_point(alpha = 0.5, size = 1) +
    #geom_smooth(size = 1, method = "loess", show.legend = TRUE, alpha = 0.7) +
    scale_y_continuous("Rating out of 10", limits = c(0,15)) +
    scale_x_date("Date of rating", date_breaks = "2 months", date_labels = "%m/%Y") +
    labs(title = "WeRateDogs dog ratings, Jan. 1, 2016-March 26, 2017",
         subtitle = "Source: Analysis of @dog_rates tweets.",
         caption = "Graphic and analysis by David H. Montgomery, dhmontgomery.com")

# Second graph: Monthly averages
ggplot(monthly, aes(yearmon, average, group = 1)) +
    geom_line() +
    geom_point() +
    scale_x_date("Date of rating", date_breaks = "2 months", date_labels = "%m/%Y") +
    labs(title = "Monthly average of WeRateDogs dog ratings, Jan. 1, 2016-March 26, 2017",
         subtitle = "Source: Analysis of @dog_rates tweets.",
         caption = "Graphic and analysis by David H. Montgomery, dhmontgomery.com",
         y = "Average rating out of 10")

# Third graph: Percent below 10/10
ggplot(monthly, aes(yearmon, u10pct)) +
    geom_col() +
    scale_y_continuous("Percent", label = percent) +
    scale_x_date("Date of rating", date_breaks = "2 months", date_labels = "%m/%Y") +
    labs(title = "Percent of WeRateDogs ratings below 10/10, by month",
         subtitle = "Source: Analysis of @dog_rates tweets.",
         caption = "Graphic and analysis by David H. Montgomery, dhmontgomery.com")

# Fourth graph: Comparison of all ratings and those >= 10
ggplot(monthlytall, aes(yearmon, average, group = type, color = type)) +
    geom_line() +
    geom_point() +
    scale_x_date("Date of rating", date_breaks = "2 months", date_labels = "%m/%Y") +
    scale_color_discrete(
        "Type of rate",
        labels = c("All ratings","Ratings 10 or higher")) +
    labs(title = "Monthly average of WeRateDogs dog ratings, Jan. 1, 2016-March 26, 2017",
         subtitle = "Source: Analysis of @dog_rates tweets.",
         caption = "Graphic and analysis by David H. Montgomery, dhmontgomery.com",
         y = "Average rating out of 10")

# Fifth graph: Number of ratings and under-10 ratings per month
u10tall <- monthly %>% select(yearmon, nratings, u10) %>% gather(type, count, 2:3) # Get data in tall format
ggplot(u10tall, aes(yearmon, count, group = type, fill = type)) +
    geom_col(position = "stack") +
    scale_x_date("Date of rating", date_breaks = "2 months", date_labels = "%m/%Y") +
    scale_fill_brewer("Type of rate", type = "qual", palette = "Dark2", labels = c("All ratings", "Ratings under 10")) +
    labs(title = "Number of WeRateDogs dog ratings, by month",
         subtitle = "Source: Analysis of @dog_rates tweets.",
         caption = "Graphic and analysis by David H. Montgomery, dhmontgomery.com",
         y = "")