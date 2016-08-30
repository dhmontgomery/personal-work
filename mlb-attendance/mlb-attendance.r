
# Load libraries
library(rvest)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(scales)
library(grid)
source("http://peterhaschke.com/Code/multiplot.R") # Load a function to plot multiple ggplot charts

# Download attendance data
url <- "http://www.espn.com/mlb/attendance" # Set the URL of the page
attendance <- url %>% 
  read_html() %>%
  html_nodes(xpath='//*[@id="my-teams-table"]/div/div/table') %>% # Select the table
  html_table()
attendance <- attendance[[1]] # Extract the data frame from the text

colnames(attendance) <- c("Rank2016","Team","HomeGames","HomeTotal","HomeAverage","HomePct","RoadGames","RoadAverage","RoadPct","OverallGames","OverallAverage","OverallPct") # Label the columns
attendance <- attendance[-c(1:2),] # Drop the now-redundant first two rows
rownames(attendance) <- 1:nrow(attendance) # Renumber the labels

# Download ballpark capacity
url <- "https://en.wikipedia.org/wiki/List_of_Major_League_Baseball_stadiums"
capacity <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/table[2]') %>%
  html_table()
capacity <- capacity[[1]]
# Remove some footnoted brackets
capacity[,3] <- gsub("\\[[^\\]]*\\]", "",capacity[,3], perl=TRUE)
capacity[,6] <- gsub("\\[[^\\]]*\\]", "",capacity[,6], perl=TRUE)

# Sort the two tables to get them in the same order
capacity <- capacity %>% arrange(Team)
attendance <- attendance %>% arrange(Team)

attendance$Capacity <- capacity[,3] # Copy the capacity column into the attendance table
# Delete commas from numbers in the tables, to make them numbers instead of strings
for (i in c(4,5,8,11,13)) { attendance[,i] <- as.numeric(gsub(",","",attendance[,i])) }
attendance$HomePct <- attendance$HomeAverage / attendance$Capacity # Calculate home attendance as a percentage of capacity

# Add three-letter labels for each team, for the plotting.
attendance$Abbrev <- c("ARI","ATL","BAL","BOS","CHC","CHW","CIN","CLE","COL","DET","HOU","KCR","LAA","LAD","MIA","MIL","MIN","NYM","NYY","OAK","PHI","PIT","SDP","SFG","SEA","STL","TBR","TEX","TOR","WSN") 

a <- ggplot(attendance, aes(HomeAverage,HomePct)) + # Make the first graph, attendance vs. percent attendance
    geom_point(size=1) + # Tiny points
    geom_text_repel( # This plots the labels, but around the points.
    	aes(label=Abbrev), 
    	size = 3) + # Set the font size
		
    ggtitle(paste0( # Title the plot dynamically
    	year(Sys.Date()), # The current year
    	" MLB home attendance vs. capacity (through ",
    	strftime(Sys.Date()-1, format = "%m/%d"), # Yesterday
    	")")) +
    scale_x_continuous(
        name="", # No x-axis title
        labels=comma, # Insert commas into the x-axis labels
        breaks=c(15000,25000,35000,45000,55000)) + # Set the breaks
    scale_y_continuous(
        name="Attendance as percent of capacity",
        labels=percent) # Convert the y-axis into percentages.

b <- ggplot(attendance, aes(HomeAverage,Capacity)) + # Make the second graph, attendance vs. capacity
    geom_point(size=1) + # Tiny points
    geom_text_repel( #Plot labels
    	aes(label=Abbrev), 
    	size = 3) + #Set the font size
    scale_x_continuous(
        name="Average home attendance",
        labels=comma, 
        breaks=c(15000,25000,35000,45000,55000)) +
    scale_y_continuous(
        name="Ballpark capacity", 
        labels=comma,
        limits=c(30000,60000)) +
    annotate( # Add a byline
        geom="text", 
        label="By David Montgomery, github.com/dhmontgomery",
        x=max(attendance$HomeAverage), # Position the byline in the lower right corner
        y=min(attendance$Capacity),
        size=2.5, 
        hjust=1) # Justify right

# Save as a square PNG
try( # Suppress an apparently harmless error message
	ggsave("attendance.png",plot=multiplot(a,b), device="png", height=10, width=10),
	silent = T) 