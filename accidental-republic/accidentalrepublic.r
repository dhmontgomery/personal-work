# R code to visualize the factions in the 1870s French National Assembly, to accompany a presentation called "The Accidental Republic: A Case Study in History and Democracy," delivered on Jan. 10, 2017 to the "Let's Nerd Out Twin Cities" event.
# Code will create five different graphs offering different looks at the 1870s assemblies, especially the Assembly elected in 1871.
# Data comes from Wikipedia: https://en.wikipedia.org/wiki/French_legislative_election,_1871, https://en.wikipedia.org/wiki/French_legislative_election,_1876 and https://en.wikipedia.org/wiki/French_legislative_election,_1877.
# Learn more about the presentation at http://dhmontgomery.com/2017/02/the-accidental-republic-nerd-out.
# Code and presentation by David H. Montgomery, released under the MIT License: https://github.com/dhmontgomery/personal-work/blob/master/LICENSE


source("https://gist.githubusercontent.com/jslefche/eff85ef06b4705e6efbc/raw/736d3dc9fe71863ea62964d9132fded5e3144ad7/theme_black.R") # Load a ggplot theme.

# Load necessary libraries
library(ggplot2)
library(scales)
library(dplyr)

# Graph 1: 1871 election, by broad faction
assemblee <- data.frame(bloc=c("Republicans","Bonapartists","Monarchists"), delegates = c(222,20,396)) # Create the data
assemblee$bloc <- factor(assemblee$group, levels=c("Republicans", "Monarchists", "Bonapartists"),ordered=T) # Try to get the groups into the right order. I'm not sure if this actually works.

ggplot(assemblee, aes(x = bloc, delegates)) + # Create the graph 
	geom_col(fill=c("green","blue","red")) + # Assign colors to the factions
	geom_hline(yintercept = 319, color = "white",size=1.5) + # Draw the 50% line
	coord_flip() + # Horizontal instead of vertical bars
	theme_black() + # Apply the black theme we previously loaded
	scale_y_continuous(limits = c(0,400)) + # Set the scale for the new x axis (labeled as the y axis here because we flipped the chart)
	theme(
		panel.grid = element_blank(), # Remove gridlines
		panel.border = element_blank(), # Remove the border
		axis.ticks = element_blank(), # Remove axis ticks
		axis.text.x = element_text(size=35), # Enlarge axis labels
		axis.text.y = element_text(size=50),
		axis.title.x = element_text(size=50, margin = margin(t=20)), # Enlarge and position axis title
		plot.title = element_text(size=60, margin=margin(b=20))) + # Enlarge and position plot title
	labs(title = "1871 Assemblée nationale", x="", y = "Delegates") # Set the plot title and horizontal axis label
ggsave("assemblee.png", height=10, width=20)


# Graph 2: 1871 election, with monarchists distinguished
assemblee2 <- data.frame(group=c("Republicans","Bonapartists","Orléanists","Légitimists"), delegates = c(222,20,214,182),bloc=c("Republicans","Bonapartists","Monarchists","Monarchists"))
cols2 <- c("Republicans" = "red","Orléanists" = "light blue", "Légitimists" = "blue", "Bonapartists" = "green")

assemblee2$group <- factor(assemblee2$group, levels=c("Republicans", "Monarchists", "Bonapartists"),ordered=T)
assemblee2$bloc <- factor(assemblee2$bloc, levels=c("Republicans","Orléanists","Légitimists","Bonapartists"), ordered=T)

ggplot(assemblee2, aes(x = bloc, delegates, fill=group)) + 
	geom_col(position="stack") +
	geom_hline(yintercept = 319, color = "white",size=1.5) +
	coord_flip() +
	scale_y_continuous(limits = c(0,400)) +
	scale_fill_manual(values = cols2, breaks = c("Republicans", "Orléanists","Légitimists", "Bonapartists"), guide= FALSE) +
	theme_black() +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.ticks = element_blank(),
		axis.text.x = element_text(size=35),
		axis.text.y = element_text(size=50),
		axis.title.x = element_text(size=50, margin = margin(t=20)),
		plot.title = element_text(size=60, margin=margin(b=20))) +
	labs(title = "1871 Assemblée nationale", x="", y = "Delegates")
ggsave("assemblee2.png", height=10, width=20)

# Graph 3: 1871 election with monarchists split into separate bars
ggplot(assemblee2, aes(x = group, delegates)) + 
	geom_col(fill=c("green","blue","light blue","red")) +
	geom_hline(yintercept = 319, color = "white",size=1.5) +
	coord_flip() +
	theme_black() +
	scale_y_continuous(limits = c(0,400)) +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.ticks = element_blank(),
		axis.text.x = element_text(size=35),
		axis.text.y = element_text(size=50),
		axis.title.x = element_text(size=50, margin = margin(t=20)),
		plot.title = element_text(size=60, margin=margin(b=20))) +
	labs(title = "1871 Assemblée nationale", x="", y = "Delegates")
ggsave("assemblee3.png", height=10, width=20)

# Graph 4: 1871 election with republican factions distinguished
assemblee4 <- data.frame(group=c("Radical Republicans","Moderate Republicans","Conservative Republicans","Bonapartists","Orléanists","Légitimists"), delegates = c(38,112,72,20,214,182),bloc=c("Republicans","Republicans","Republicans","Bonapartists","Orléanists","Légitimists"))

cols3 <- c("Radical Republicans" = "red","Moderate Republicans" = "pink", "Conservative Republicans" = "yellow", "Orléanists" = "light blue", "Légitimists" = "blue", "Bonapartists" = "green")

ggplot(assemblee4, aes(x = bloc, delegates, fill=group)) + 
	geom_col(position="stack") +
	geom_hline(yintercept = 319, color = "white",size=1.5) +
	coord_flip() +
	scale_y_continuous(limits = c(0,400)) +
	scale_fill_manual(values = cols3, breaks = c("Radical Republicans","Moderate Republicans","Conservative Republicans","Bonapartists","Orléanists","Légitimists"), guide= FALSE) +
	theme_black() +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.ticks = element_blank(),
		axis.text.x = element_text(size=35),
		axis.text.y = element_text(size=50),
		axis.title.x = element_text(size=50, margin = margin(t=20)),
		plot.title = element_text(size=60, margin=margin(b=20))) +
	labs(title = "1871 Assemblée nationale", x="", y = "Delegates")
ggsave("assemblee4.png", height=10, width=20)

# Graph 5: 1871, 1876 and 1877 elections, compared
assemblee5 <- assemblee2[,-3]
assemblee5$year <- 1871
assemblee5 <- rbind(
	assemblee5,
	data.frame(group = c("Republicans","Orléanists","Légitimists","Bonapartists"), delegates = c(393,40,24,76), year = c(1876,1876,1876,1876)))
assemblee5 <- rbind(
	assemblee5,
	data.frame(group = c("Republicans", "Orléanists", "Légitimists", "Bonapartists", "Other"), delegates = c(260, 11, 44, 104, 49), year = c(1877,1877,1877,1877, 1877)))
cols4 <- c("Republicans" = "red","Orléanists" = "light blue", "Légitimists" = "blue", "Bonapartists" = "green", "Other" = "grey")
	
assemblee5 <- within(assemblee5, year <- ordered(year, levels = rev(sort(unique(year)))))
assemblee5$group <- factor(assemblee5$group, levels=c("Other","Bonapartists", "Légitimists", "Orléanists", "Republicans"),ordered=T)

a <- ggplot(assemblee5, aes(as.factor(year), delegates, fill=group)) +
	geom_col(position="fill") +
	theme_black() +
	geom_hline(yintercept = .5, color = "white", size = 1.5) +
	scale_y_continuous("Share of delegates", labels = percent) +
	coord_flip() +
	scale_fill_manual(
		name = "",
		values = cols4, 
		breaks = c("Republicans", "Orléanists","Légitimists", "Bonapartists", "Other")
	) +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.ticks = element_blank(),
		axis.text.x = element_text(size=35),
		axis.text.y = element_text(size=50),
		axis.title.x = element_text(size=50, margin = margin(t=20)),
		plot.title = element_text(size=60, margin=margin(b=20)),
		legend.title = element_text(size=50),
		legend.text = element_text(size=35),
		legend.key.size = unit(3.5, "lines"),
		legend.key = element_blank()
	) +
	labs(title = "1870s Assemblée nationale elections", x="")
ggsave("assemblee5.png", height=10, width=20)