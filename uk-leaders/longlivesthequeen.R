# Code to analyze and graph data about British monarchs and prime ministers
# Written by David H. Montgomery
# Data from Wikipedia and U.K. Office of National Statistics
# Code released under an MIT license with mandatory credit: https://github.com/dhmontgomery/personal-work/blob/master/LICENSE

# Load libraries
library(tidyverse)
library(scales)
library(lubridate)
library(RColorBrewer)
library(DescTools)
library(ggthemes)
library(knitr)
library(grid)
library(gridExtra)

# Create first graphic

# Load the population data
pop <- read_csv("https://github.com/dhmontgomery/personal-work/raw/master/uk-leaders/uk-pop-pyramid.csv") %>%
	gather(key, pop, 2:5) %>% # Convert to tall format
	separate(key, c("Sex", "Year"), sep = "-") %>% # Separate gender and time to distinct variables
	mutate(Sex = str_remove_all(Sex, " Mid")) %>% # Clean up verbiage
	group_by(Year) %>% # Group
	mutate(pop_pct = pop/sum(pop)) # Go from raw counts to percentages

# Create the graphic for the popiulation pryamid
p1 <- ggplot(pop %>% filter(Year == "2016"), # Restrict to just the most recent count
			 # Set aesthetics, including making male population figures negative on the fly
			 aes(Age, ifelse(Sex == "Males", -pop_pct, pop_pct), fill = Sex, color = Sex)) +
	geom_col() + # Add columns
	# Draw a line around Elizabeth's reign
	geom_area(data = pop %>% filter(Year == "2016", Age >= 64), color = "black") + 
	annotate("text", x = 90, y = -0.0045, label = "Born before\nElizabeth's reign") + # Add label
	# Add an arrow. Note you may need to tinker with the x- and y-coordinates
	geom_segment(aes(x = 86, y = -.00295, xend = 86, yend = -.0024), color = "black", arrow = arrow(length = unit(0.2, "cm"))) +
	scale_y_continuous(labels = percent) + # Format y-axis
	scale_x_continuous(limits = c(0, 100)) + # Format x-axis
	coord_flip() + # Rotate the chart
	theme_bw() + # Add a theme (though not the custom theme I used)
	# Tweak the theme
	theme(axis.title = element_text(),
		  legend.position = "top",
		  panel.border = element_blank(),
		  plot.background = element_blank()) +
	# Label the graph
	labs(title = "Population structure of the U.K.",
		 subtitle = "Year: 2016. Source: Office for National Statistics",
		 y = "")


# Create a bar chart expressing the above as a percent
p2 <- pop %>% filter(Year == "2016", Age >= 64) %>% select(Year, pop_pct) %>% summarize(o64 = sum(pop_pct)) %>%
	left_join(pop %>% filter(Year == "2016", Age < 64) %>% select(Year, pop_pct) %>% summarize(u64 = sum(pop_pct)), by = "Year") %>%
	gather(age, pct, 2:3) %>%
	ggplot(aes(1, pct, fill = age)) +
	geom_col() +
	scale_y_continuous(labels = percent, expand = c(0,0)) +
	scale_fill_brewer(name = "", labels = c("Before", "During"), palette = "Dark2") +
	theme_bw() +
	theme(axis.ticks.x = element_blank(), axis.text.x = element_blank(),
		  legend.position = "top",
		  panel.border = element_blank(),
		  plot.background = element_blank()) +
	labs(title = "Percent of British\npopulation born in\nElizabeth's reign",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 x = "",
		 y = "")

# Combine our two plots into a single image
grid.arrange(p1, p2, widths = 2:1)
# Draw a border
grid::grid.rect(width = 1, height = 1, gp = gpar(lwd = 7, col = "black", fill = NA))


# Load data on British monarchs and prime ministers

pms <- read_csv("https://raw.githubusercontent.com/dhmontgomery/personal-work/master/uk-leaders/uk_prime_ministers.csv") %>% 
	mutate(
		# Fill in the blank death dates for living PMs on the fly to today
		deathdate = ifelse(is.na(deathdate), today(), deathdate) %>% as_date(),
		# Calculate their livespan through today in days
		lifespan_days = (deathdate - birthdate) %>% as.interval(birthdate) %>% as.numeric("days"))

royals <- read_csv("https://raw.githubusercontent.com/dhmontgomery/personal-work/master/uk-leaders/uk_monarchs.csv") %>% 
	# Fill in days for end-of-reign and death to today for living monarchs (Elizabeth)
	mutate(reign_end = ifelse(is.na(reign_end), today(), reign_end) %>% as_date(),
		   deathdate = ifelse(is.na(deathdate), today(), deathdate) %>% as_date(),
		   # Calculate reign length
		   reign_length = (reign_end - reign_start) %>% as.interval(reign_start) %>% as.numeric("days"),
		   # Calculate lifespan
		   lifespan_days = (deathdate - birthdate) %>% as.interval(birthdate) %>% as.numeric("days"),
		   # Split William & Mary into two "momarchs" — their dual monarchy, and William's solo reign after Mary's death
		   regal_name = replace(as.character(regal_name), regal_name == "Mary II", "William & Mary"),
		   sex = replace(as.character(sex), regal_name == "William & Mary", "both"))
royals[4,3] <- royals[3,4] # Set the start date for William's solo reign to the death of his wife


# Graph each monarch's reign and lifespan

royals %>% # Start with our royals data
	# 
	mutate(order = as.numeric(row.names(royals)),
		   # Undo the William & Mary change we just did. Awkward, I know.
		   regal_name = replace(regal_name, regal_name == "William & Mary", "Mary II") %>% as.factor() %>% fct_reorder(order),
		   reign_start = ifelse(reign_start == as.Date("1694-12-28"), as.Date("1689-02-13"), reign_start) %>% as_date(),
		   # Recalculate reign length and lifespan to account for the changes we just did
		   reign_length = (reign_end - reign_start) %>% as.interval(reign_start) %>% as.numeric("days"),
		   lifespan_days = (deathdate - birthdate) %>% as.interval(birthdate) %>% as.numeric("days")) %>%
	select(regal_name, order, reign_length, lifespan_days) %>%
	# Plot it
	ggplot(aes(fct_reorder(regal_name, reign_length), lifespan_days/365)) + # Sort by reign length
	geom_col(aes(fill = "grey45")) + # Draw grey bars for lifespan
	geom_col(aes(y = reign_length/365, fill = "cyan3")) + # Overlay cyan bars for reign length
	scale_y_continuous(expand = c(0,0), limits = c(0, 100)) + # Format y-axis
	scale_fill_manual(values = c("cyan3", "grey45"), labels = c("Reign length", "Lifespan")) + # Format legend
	coord_flip() + # Flip the graph
	theme_bw() +
	theme(legend.position = "top") +
	labs(title = "Years on the throne for British monarchs",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 subtitle = "Elizabeth II's reign and lifespan are through March 2018",
		 fill = "",
		 x = "",
		 y = "Years")


# A nifty loop to calculate overlaps between prime ministers and monarchs

# Create a new dataframe with basic info on each PM
overlaps <- data.frame("prime_minister" = pms$known_as, "lifespan" = pms$lifespan_days, "order" = as.numeric(row.names(pms)))

for(i in 1:nrow(royals)) { # Cycle through the royals
	for(j in 1:nrow(overlaps)) { # And the PMs
		# Calculate the overlap in days between PMs' lives and royals' reigns
		overlaps[j, i+3] <- Overlap(c(pms$birthdate[j], pms$deathdate[j]), c(royals$reign_start[i], royals$reign_end[i])) # Seriously this is really cool.
	}
}
# Add clean column names to our new dataframe, including filling the full list of monarch names
names(overlaps) <- c("prime_minister", "pm_lifespan", "order", royals$regal_name)
# Reduce prime ministers who served multiple terms to a single entry
overlaps <- distinct(overlaps, prime_minister, .keep_all = TRUE)

# Convert our dataframe to tall format
overlaps_tall <- overlaps %>% 
	gather(monarch, overlap_days, 4:19) %>% 
	filter(overlap_days !=0) %>% 
	arrange(order) %>%
	mutate(pct = overlap_days / pm_lifespan) %>% # Calculate overlap days as a percent of PM lifespajs
	# Add data on monarch sex to our table
	left_join(royals %>% select(regal_name, monarch_sex = sex), by = c("monarch" = "regal_name"))

# For each PM, calculate the percent of their life under queens and kings (and both)
overlaps_by_gender <- overlaps_tall %>%  
	group_by(prime_minister, order, monarch_sex) %>%
	summarize(pct = sum(pct)) %>%
	ungroup() %>%
	mutate(prime_minister = prime_minister %>% as.factor() %>% fct_reorder(order),
		   monarch_sex = monarch_sex %>% as.factor() %>% fct_relevel("female", "male")) %>%
	arrange(order)


# Graph prime ministers by reigning monarch gender
# You'll need to export this with a reasonable height to avoid overlap

ggplot(overlaps_by_gender, 
	   # Create a dynamic fill legend that we'll finish below with scale_fill_manual
	   aes(prime_minister, pct, fill = fct_relevel(monarch_sex, "female", "both", "male"))) +
	geom_col(color = NA, alpha = 0.8) + # Draw semi-transparent bars with no stroke
	coord_flip() + # Roate the chart
	scale_fill_manual(values = brewer.pal(3, "Set1")[c(1, 3, 2)], name = "Reigning monarch:", labels = c("Queen", "Queen & King", "King")) + # Specify colors and color names for the legend
	scale_y_continuous(labels = percent, expand = c(0,0)) + # Format y-axis, including removing buffer space
	theme_bw() + # Add theme
	# Customize theme
	theme(plot.margin = margin(t = 10, r = 20, b = 10, l = 10),
		  legend.position = "top") +
	labs(title = "Share of prime minister's lives under kings & queens",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 x = "",
		 y = "Percent of lifespan (to date)")


# Restructure our PMs dataset for our final and coolest graph
# This will have entries for each PM's birthdate and deathdate (today for living PMs)
pms_tall <- pms %>% 
	mutate(order = as.numeric(row.names(pms)),
		   known_as = as.factor(known_as)) %>%
	select(order, known_as, birthdate, deathdate) %>%
	gather(borndied, date, 3:4)

# Graph each prime minister's lifespan and term of office against reigning monarch gender!
# You'll need to export this with a reasonable height to avoid overlap
ggplot() +
	# Plot each PM's lifespan as a line from birthdate to deathdate
	# I had to do this first to fix a bug, not quite sure why. This will get covered up.
	geom_line(data = pms_tall, aes(x = date, y = fct_reorder(known_as, order))) + 
	# Draw background rectangles, colored by gender of reigning monarch
	geom_rect(data = royals, 
			  aes(xmin = reign_start, xmax = reign_end, 
			  	ymin = -Inf, ymax = Inf, 
			  	fill = fct_relevel(sex, "female", "both", "male")), # Set color by gender
			  inherit.aes = FALSE, alpha = 0.8) +
	# Redraw the PM lifespans, for real this time.
	geom_line(data = pms_tall, aes(x = date, y = fct_reorder(known_as, order)), size = 2) +
	# Draw overlapping white lines for each PM's term in office
	geom_line(data = pms %>% # Start with the database of PMs
			  	mutate(order = as.numeric(row.names(pms)), # Calculate order in office.
			  		   # Repeat PMs appear more than once
			  		   known_as = as.factor(known_as),
			  		   # Calculate end of term for current PM on the fly
			  		   end_of_term = ifelse(is.na(end_of_term), today(), end_of_term) %>% as_date()) %>%
			  	select(order, known_as, start_of_term, end_of_term) %>%
			  	# Convert to tall format
			  	gather(startofterm, date, 3:4), 
			  # Plot this new dataset as white lines on top of the lifespans
			  aes(x = date, 
			  	y = fct_reorder(known_as,order), # Sort PM names by rough order in office
			  	group = order), # "Order" is unique for each term; this keeps multi-term PMs' white bars separate
			  size = 2, color = "white") +
	# Customize color scale for background rectangles
	scale_fill_manual(values = brewer.pal(3, "Set1")[c(1, 3, 2)], name = "Reigning monarch:", labels = c("Queen", "Queen & King", "King")) +
	scale_x_date(expand = c(0,0)) + # Remove chart padding
	theme_bw() + # Add theme
	theme(legend.position = "top") + # Position legend
	labs(title = "Lifespan of every British prime minister",
		 subtitle = "By gender of reigning monarch. White lines indicate terms as prime minister",
		 caption = "Graphic by David H. Montgomery, dhmontgomery.com",
		 x = "Date of birth and death",
		 y = "")
