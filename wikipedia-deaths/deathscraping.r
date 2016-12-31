library(dplyr)
library(tidyr)
library(rvest)
library(jsonlite)

# Scraping the list of deaths in each year.
deaths <- data.frame() # Create an empty dataframe
for(i in 1990:2016) { # Cycle through each year using Wikipedia's API
    deathyear <- i
    cont <- "page%7C27273d3757274107044b2f4133273703424b2f413327370427273d375727410122018f7e8f808f808f0a%7C9346268" # Store a unique field Wikipedia's API uses to move between blocs of responses when you query it.
    deathscode <- expression(fromJSON(paste0("https://en.wikipedia.org/w/api.php?action=query&format=json&list=categorymembers&continue=-%7C%7C&cmtitle=Category%3A",deathyear,"_deaths&cmnamespace=0&cmlimit=max&cmcontinue=",cont))) # Generate the API query
    deathsapi <- eval(deathscode) # Evaluate the API query
    tmp <- deathsapi$query$categorymembers # Extract the result we want
    while(!is.null(deathsapi$continue$cmcontinue)) { # Keep cycling until we run out of new responses
        cont <- deathsapi$continue$cmcontinue # Store the new continuation variable
        deathsapi <- eval(deathscode) # Evaluate the new API query with our new `cont` value.
        tmp <- rbind( # Store it in a temporary dataframe.
            tmp,
            deathsapi$query$categorymembers)
    }
    tmp$year <- deathyear # Add a column marking the year.
    deaths <- rbind(deaths,tmp) # Add the temporary data to the full data.
} # Repeat the cycle
deaths <- select(deaths,-ns) # Delete a column we don't care about.   

# Scraping the length in bytes of each death article. 
# This will take a very long time if you run it on the whole dataset. I spent at least 12 hours.
for(i in 1:nrow(deaths)) { # Cycle through the list of deaths
    deaths$bytes[i] <- fromJSON(paste0("https://en.wikipedia.org//w/api.php?action=query&format=json&prop=revisions&rvprop=size&pageids=",deaths[i,1]))$query$pages[[1]][[4]] # Look up the article in the API from the page ID, take its length in bytes, and store it in a new 'bytes' column.
}
deaths$bytes <- as.numeric(deaths$bytes) # Convert the bytes data from a list format to numbers.
write.csv(deaths,"deaths.csv", row.names=FALSE) # Write the data to a CSV.

# To update the dataset change the `write.csv()` code above to write to a file called "deaths2016.csv", and change the years for the loop from `1990:2016` to `2016:2016`. 
# Run the edited code. Then save it as a new object:
# deaths2016 <- deaths
# Then reload the CSV with the full dataset:
# deaths <- read.csv("deaths.csv",stringsAsFactors = F)
# Purge the old 2016 data:
# deaths <- deaths %>% filter(year != 2016)
# And merge the two together: 
# deaths <- bind_rows(deaths, deaths2016)