## This will download MLB PitchFX data for a given pitcher in a given seasn, and produce 18 graphs in your working directory of the pitch location and speed of pitches by pitch outcome.
## The function takes three parameters, all expressed inside quotation marks:
## - "pitchyear", a four-digit year. PitchFX debuted in 2007 and gradually expanded; the further back in time, the greater the chance of errors or missing data.
## - "team", a three-character string reflecting the team's city: "bos", "sea", etc. For two-team cities, the third digit reflects the league: for example, "chn" instead of "chc"; "lan" instead of "lad".
## "pitchername", the generally recognized first and last name of a pitcher. For example, "Jake Arrieta" instead of "Jacob Arrieta."
## Created based on a tutorial by Bill Petti: http://www.hardballtimes.com/a-short-ish-introduction-to-using-r-for-baseball-research/

pitchviz <- function(pitchyear, team, pitchername) {
require(pitchRx)
require(dplyr)

data(gids,package="pitchRx") ## Load the dataset of Gameday IDs
away <- gids[grep(paste0(pitchyear,"_[0-9]{2}_[0-9]{2}_",team,"mlb*"),gids)] ## Create a variable with the three-letter team code plus the letter "a", and define it was the list of the Gameday IDs for that team in a given year.
home <- gids[grep(paste0(pitchyear,"_[0-9]{2}_[0-9]{2}_......_",team,"mlb"),gids)] ## Do the same for home games.
allgames <- append(home, away) ## Combine to get all Gameday IDs for a given year.
dat <- scrape(game.ids = allgames) ## Scrape data for all relevant games. This could take a while.
locations <- select(dat$pitch, pitch_type, start_speed, px, pz, des, num, gameday_link) ## Extract certain PitchFX data
names <- select(dat$atbat, pitcher, batter, pitcher_name, batter_name, num, gameday_link, event, stand) ## Extract some play-by-play data
data <- names %>% filter(pitcher_name == pitchername) %>% inner_join(locations, ., by=c("num", "gameday_link")) ## Combine the PitchFX and play data and limit it to just your given pitcher.

data_slim <- data[,c(1:5,12:13)] ## Pare down our columns

## Create data frames for our four pitch outcomes
data_slim_Swing <- filter(data_slim, grepl("Swinging", des))
data_slim_Take <- filter(data_slim, grepl("Called", des))
data_slim_Ball <- filter(data_slim, grepl("Ball", des))
data_slim_Foul <- filter(data_slim, grepl("Foul", des))
data_slim_Out <- filter(data_slim, grepl("In play, out", des))
data_slim_Hits <- filter(data_slim, grepl("(In play, r)|(In play, n)", des))

## Split by handedness
data_slim_SwingL <- subset(data_slim_Swing, stand == "L")
data_slim_SwingR <- subset(data_slim_Swing, stand == "R")
data_slim_TakeL <- subset(data_slim_Take, stand == "L")
data_slim_TakeR <- subset(data_slim_Take, stand == "R")
data_slim_BallL <- subset(data_slim_Ball, stand == "L")
data_slim_BallR <- subset(data_slim_Ball, stand == "R")
data_slim_FoulL <- subset(data_slim_Foul, stand == "L")
data_slim_FoulR <- subset(data_slim_Foul, stand == "R")
data_slim_OutL <- subset(data_slim_Out, stand == "L")
data_slim_OutR <- subset(data_slim_Out, stand == "R")
data_slim_HitsL <- subset(data_slim_Hits, stand == "L")
data_slim_HitsR <- subset(data_slim_Hits, stand == "R")

## Plotting the pitcher's six results, for both hands

## Plot of all swinging strikes
p <- ggplot(data_slim_Swing, aes(px,pz,color=start_speed))
p <- p + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Swinging Strikes, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p <- p + geom_point(size = 3, alpha = .65)
p <- p + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_swing.png"), width=700)
print(p)
dev.off()

## Plot of all called strikes
c <- ggplot(data_slim_Take, aes(px,pz,color=start_speed))
c <- c + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Strikes, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c <- c + geom_point(size = 3, alpha = .65)
c <- c + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_take.png"), width=700)
print(c)
dev.off()

## Plot of all foul balls
f <- ggplot(data_slim_Foul, aes(px,pz,color=start_speed))
f <- f + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Fouled Balls, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f <- f + geom_point(size = 3, alpha = .65)
f <- f + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_foul.png"), width=700)
print(f)
dev.off()

## Plot of all called balls
h <- ggplot(data_slim_Ball, aes(px,pz,color=start_speed))
h <- h + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Balls, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
h <- h + geom_point(size = 3, alpha = .65)
h <- h + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_ball.png"), width=700)
print(h)
dev.off()

## Plot of all batted outs
o <- ggplot(data_slim_Out, aes(px,pz,color=start_speed))
o <- o + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Batted outs, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
o <- o + geom_point(size = 3, alpha = .65)
o <- o + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_outs.png"), width=700)
print(o)
dev.off()

## Plot of all hits
h <- ggplot(data_slim_Hits, aes(px,pz,color=start_speed))
h <- h + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Hits, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
h <- h + geom_point(size = 3, alpha = .65)
h <- h + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_hits.png"), width=700)
print(h)
dev.off()


##Now left-handed batters only

## Plot of all swinging strikes
p_l <- ggplot(data_slim_SwingL, aes(px,pz,color=start_speed))
p_l <- p_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Swinging Strikes v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_l <- p_l + geom_point(size = 3, alpha = .65)
p_l <- p_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_swingL.png"), width=700)
print(p_l)
dev.off()

## Plot of all called strikes
c_l <- ggplot(data_slim_TakeL, aes(px,pz,color=start_speed))
c_l <- c_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Strikes v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_l <- c_l + geom_point(size = 3, alpha = .65)
c_l <- c_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_takeL.png"), width=700)
print(c_l)
dev.off()

## Plot of all foul balls
f_l <- ggplot(data_slim_FoulL, aes(px,pz,color=start_speed))
f_l <- f_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Fouled Balls v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_l <- f_l + geom_point(size = 3, alpha = .65)
f_l <- f_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_foulL.png"), width=700)
print(f_l)
dev.off()

## Plot of all called balls
b_l <- ggplot(data_slim_BallL, aes(px,pz,color=start_speed))
b_l <- b_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Balls v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_l <- b_l + geom_point(size = 3, alpha = .65)
b_l <- b_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_ballL.png"), width=700)
print(b_l)
dev.off()

## Plot of all batted outs
o_l <- ggplot(data_slim_OutL, aes(px,pz,color=start_speed))
o_l <- o_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Batted outs v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
o_l <- o_l + geom_point(size = 3, alpha = .65)
o_l <- o_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_outsL.png"), width=700)
print(o_l)
dev.off()

## Plot of all hits
h_l <- ggplot(data_slim_HitsL, aes(px,pz,color=start_speed))
h_l <- h_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Hits v. LHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
h_l <- h_l + geom_point(size = 3, alpha = .65)
h_l <- h_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_hitsL.png"), width=700)
print(h_l)
dev.off()



## Now for all right-handed batters

p_r <- ggplot(data_slim_SwingR, aes(px,pz,color=start_speed))
p_r <- p_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Swinging Strikes v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_r <- p_r + geom_point(size = 3, alpha = .65)
p_r <- p_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_swingR.png"), width=700)
print(p_r)
dev.off()

## Plot of all called strikes
c_r <- ggplot(data_slim_TakeR, aes(px,pz,color=start_speed))
c_r <- c_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Strikes v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_r <- c_r + geom_point(size = 3, alpha = .65)
c_r <- c_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_takeR.png"), width=700)
print(c_r)
dev.off()

## Plot of all foul balls
f_r <- ggplot(data_slim_FoulR, aes(px,pz,color=start_speed))
f_r <- f_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Fouled Balls v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_r <- f_r + geom_point(size = 3, alpha = .65)
f_r <- f_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_foulR.png"), width=700)
print(f_r)
dev.off()

## Plot of all called balls
b_r <- ggplot(data_slim_BallR, aes(px,pz,color=start_speed))
b_r <- b_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Called Balls v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_r <- b_r + geom_point(size = 3, alpha = .65)
b_r <- b_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_ballR.png"), width=700)
print(b_r)
dev.off()

## Plot of all batted outs
o_r <- ggplot(data_slim_OutR, aes(px,pz,color=start_speed))
o_r <- o_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Batted outs v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
o_r <- o_r + geom_point(size = 3, alpha = .65)
o_r <- o_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_outsR.png"), width=700)
print(o_r)
dev.off()

## Plot of all hits
h_r <- ggplot(data_slim_HitsR, aes(px,pz,color=start_speed))
h_r <- h_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = paste0(pitchername,": Hits v. RHB, ", pitchyear)) + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
h_r <- h_r + geom_point(size = 3, alpha = .65)
h_r <- h_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png(paste0(pitchername,pitchyear,"_hitsR.png"), width=700)
print(h_r)
dev.off()


}