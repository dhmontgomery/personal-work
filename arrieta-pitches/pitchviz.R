## This will download MLB data for a  and produce 12 graphs in your working directory of the pitch location and speed of  pitches by outcome.
## Created based on a tutorial by Bill Petti: http://www.hardballtimes.com/a-short-ish-introduction-to-using-r-for-baseball-research/

pitchviz <- function(pitchyear = "2015", team = "chn", pitcher = "Jake data_slim_") {
require(pitchRx)
require(dplyr)


data(gids,package="pitchRx") ## Load the dataset of Gameday IDs
assign(paste0(team,"a"), gids[grep(paste0(pitchyear,"_[0-9]{2}_[0-9]{2}_chnmlb*"),gids)]) ## Create a variable with the three-letter team code plus the letter "a", and define it was the list of the Gameday IDs for that team in a given year.
assign(paste0(team,"h"), gids[grep(paste0(pitchyear,"_[0-9]{2}_[0-9]{2}_chnmlb*"),gids)]) ## Do the same for home games.
assign(team, append(paste0(team,"a"),paste0(team,"h")) ## Combine to get all Gameday IDs for a given year.
team <- head(team)
dat <- scrape(game.ids = team) ## Scrape data for all relevant games. This could take a while.
locations <- select(dat$pitch, pitch_type, start_speed, px, pz, des, num, gameday_link) ## Extract certain PitchFX data
names <- select(dat$atbat, pitcher, batter, pitcher_name, batter_name, num, gameday_link, event, stand) ## Extract some play-by-play data
data <- names %>% filter(pitcher_name == pitcher) %>% inner_join(locations, ., by=c("num", "gameday_link")) ## Combine the PitchFX and play data and limit it to just your given pitcher.

data_slim <- data[,c(1:5,12:13)] ## Pare down our columns

## Create data frames for our four pitch outcomes
data_slim_Swing <- filter(data_slim_, grepl("Swinging", des))
data_slim_Take <- filter(data_slim_, grepl("Called", des))
data_slim_Ball <- filter(data_slim_, grepl("Ball", des))
data_slim_Foul <- filter(data_slim_, grepl("Foul", des))
## Split by handedness
data_slim_SwingL <- subset(data_slim_Swing, stand == "L")
data_slim_SwingR <- subset(data_slim_Swing, stand == "R")
data_slim_TakeL <- subset(data_slim_Take, stand == "L")
data_slim_TakeR <- subset(data_slim_Take, stand == "R")
data_slim_BallL <- subset(data_slim_Ball, stand == "L")
data_slim_BallR <- subset(data_slim_Ball, stand == "R")
data_slim_FoulL <- subset(data_slim_Foul, stand == "L")
data_slim_FoulR <- subset(data_slim_Foul, stand == "R")

## Plotting Jake's four results, for both hands

## Plot of all swinging strikes
p <- ggplot(data_slim_Swing, aes(px,pz,color=start_speed))
p <- p + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Swinging Strikes, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p <- p + geom_point(size = 3, alpha = .65)
p <- p + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_swing.png"), width=600)
print(p)
dev.off()

## Plot of all called strikes
c <- ggplot(data_slim_Take, aes(px,pz,color=start_speed))
c <- c + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Strikes, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c <- c + geom_point(size = 3, alpha = .65)
c <- c + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_take.png"), width=600)
print(c)
dev.off()

## Plot of all foul balls
f <- ggplot(data_slim_Foul, aes(px,pz,color=start_speed))
f <- f + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Fouled Balls, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f <- f + geom_point(size = 3, alpha = .65)
f <- f + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_foul.png"), width=600)
print(f)
dev.off()

## Plot of all called balls
b <- ggplot(data_slim_Ball, aes(px,pz,color=start_speed))
b <- b + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Balls, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b <- b + geom_point(size = 3, alpha = .65)
b <- b + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_ball.png"), width=600)
print(b)
dev.off()


##Now left-handed batters only

## Plot of all swinging strikes
p_l <- ggplot(data_slim_SwingL, aes(px,pz,color=start_speed))
p_l <- p_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Swinging Strikes v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_l <- p_l + geom_point(size = 3, alpha = .65)
p_l <- p_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_swingL.png"), width=600)
print(p_l)
dev.off()

## Plot of all called strikes
c_l <- ggplot(data_slim_TakeL, aes(px,pz,color=start_speed))
c_l <- c_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Strikes v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_l <- c_l + geom_point(size = 3, alpha = .65)
c_l <- c_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_takeL.png"), width=600)
print(c_l)
dev.off()

## Plot of all foul balls
f_l <- ggplot(data_slim_FoulL, aes(px,pz,color=start_speed))
f_l <- f_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Fouled Balls v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_l <- f_l + geom_point(size = 3, alpha = .65)
f_l <- f_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_foulL.png"), width=600)
print(f_l)
dev.off()

## Plot of all called balls
b_l <- ggplot(data_slim_BallL, aes(px,pz,color=start_speed))
b_l <- b_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Balls v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_l <- b_l + geom_point(size = 3, alpha = .65)
b_l <- b_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_ballL.png"), width=600)
print(b_l)
dev.off()


## Now for all right-handed batters

p_r <- ggplot(data_slim_SwingR, aes(px,pz,color=start_speed))
p_r <- p_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Swinging Strikes v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_r <- p_r + geom_point(size = 3, alpha = .65)
p_r <- p_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_swingR.png"), width=600)
print(p_r)
dev.off()

## Plot of all called strikes
c_r <- ggplot(data_slim_TakeR, aes(px,pz,color=start_speed))
c_r <- c_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Strikes v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_r <- c_r + geom_point(size = 3, alpha = .65)
c_r <- c_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_takeR.png"), width=600)
print(c_r)
dev.off()

## Plot of all foul balls
f_r <- ggplot(data_slim_FoulR, aes(px,pz,color=start_speed))
f_r <- f_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Fouled Balls v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_r <- f_r + geom_point(size = 3, alpha = .65)
f_r <- f_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_foulR.png"), width=600)
print(f_r)
dev.off()

## Plot of all called balls
b_r <- ggplot(data_slim_BallR, aes(px,pz,color=start_speed))
b_r <- b_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitcher,": Called Balls v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_r <- b_r + geom_point(size = 3, alpha = .65)
b_r <- b_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitcher,"_ballR.png"), width=600)
print(b_r)
dev.off()

}