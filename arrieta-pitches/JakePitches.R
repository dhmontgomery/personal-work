## This will download MLB data for 2015 and produce 12 graphs in your working directory of the pitch location and speed of Jake Arrieta's pitches by outcome.
## Created based on a tutorial by Bill Petti: http://www.hardballtimes.com/a-short-ish-introduction-to-using-r-for-baseball-research/

require(pacman)
library(pacman)
p_load(Lahman, dplyr, pitchRx)

data(gids,package="pitchRx") ## Load the dataset of Gameday IDs
cubsa <- gids[grep("2015_[0-9]{2}_[0-9]{2}_chnmlb*",gids)] ## Extract 2015 Cubs away game IDs
cubsh <- gids[grep("2015_[0-9]{2}_[0-9]{2}_......_chnmlb",gids)] ## Extract 2015 Cubs home game IDs
cubsa <- cubsa[18:99] ## Remove Spring Training
cubsh <- cubsh[17:100] ## Remove Spring Training
cubs <- append(cubsh,cubsa) ## Combine to get all 2015 Cubs game IDs
dat <- scrape(game.ids = cubs) ## Scrape data for all 2015 Cubs games. This could take a while.
locations <- select(dat$pitch, pitch_type, start_speed, px, pz, des, num, gameday_link) ## Extract certain PitchFX data
names <- select(dat$atbat, pitcher, batter, pitcher_name, batter_name, num, gameday_link, event, stand) ## Extract some play-by-play data
data <- names %>% filter(pitcher_name == "Jake Arrieta") %>% inner_join(locations, ., by=c("num", "gameday_link")) ## Combine the PitchFX and play data and limit it to just Arrieta.

Arrieta <- data[,c(1:5,12:13)] ## Pare down our columns

ArrietaSwing <- filter(Arrieta, grepl("Swinging", des))
ArrietaTake <- filter(Arrieta, grepl("Called", des))
ArrietaBall <- filter(Arrieta, grepl("Ball", des))
ArrietaFoul <- filter(Arrieta, grepl("Foul", des))

ArrietaSwingL <- subset(ArrietaSwing, stand == "L")
ArrietaSwingR <- subset(ArrietaSwing, stand == "R")
ArrietaTakeL <- subset(ArrietaTake, stand == "L")
ArrietaTakeR <- subset(ArrietaTake, stand == "R")
ArrietaBallL <- subset(ArrietaBall, stand == "L")
ArrietaBallR <- subset(ArrietaBall, stand == "R")
ArrietaFoulL <- subset(ArrietaFoul, stand == "L")
ArrietaFoulR <- subset(ArrietaFoul, stand == "R")

## Plotting Jake's four results, for both hands

## Plot of all swinging strikes
p <- ggplot(ArrietaSwing, aes(px,pz,color=start_speed))
p <- p + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Swinging Strikes, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p <- p + geom_point(size = 3, alpha = .65)
p <- p + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_swing.png", width=600)
p
dev.off()

## Plot of all called strikes
c <- ggplot(ArrietaTake, aes(px,pz,color=start_speed))
c <- c + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Called Strikes, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c <- c + geom_point(size = 3, alpha = .65)
c <- c + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_take.png", width=600)
c
dev.off()

## Plot of all foul balls
f <- ggplot(ArrietaFoul, aes(px,pz,color=start_speed))
f <- f + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Fouled Balls, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f <- f + geom_point(size = 3, alpha = .65)
f <- f + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_foul.png", width=600)
f
dev.off()

## Plot of all called balls
b <- ggplot(ArrietaBall, aes(px,pz,color=start_speed))
b <- b + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Balls, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b <- b + geom_point(size = 3, alpha = .65)
b <- b + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_ball.png", width=600)
b
dev.off()

##Now left-handed batters only

## Plot of all swinging strikes
p_l <- ggplot(ArrietaSwingL, aes(px,pz,color=start_speed))
p_l <- p_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Swinging Strikes v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_l <- p_l + geom_point(size = 3, alpha = .65)
p_l <- p_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_swingL.png", width=600)
p_l
dev.off()

## Plot of all called strikes
c_l <- ggplot(ArrietaTakeL, aes(px,pz,color=start_speed))
c_l <- c_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Called Strikes v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_l <- c_l + geom_point(size = 3, alpha = .65)
c_l <- c_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_takeL.png", width=600)
c_l
dev.off()

## Plot of all foul balls
f_l <- ggplot(ArrietaFoulL, aes(px,pz,color=start_speed))
f_l <- f_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Fouled Balls v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_l <- f_l + geom_point(size = 3, alpha = .65)
f_l <- f_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_foulL.png", width=600)
f_l
dev.off()

## Plot of all called balls
b_l <- ggplot(ArrietaBallL, aes(px,pz,color=start_speed))
b_l <- b_l + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Balls v. LHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_l <- b_l + geom_point(size = 3, alpha = .65)
b_l <- b_l + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_ballL.png", width=600)
b_l
dev.off()


## Now for all right-handed batters

p_r <- ggplot(ArrietaSwingR, aes(px,pz,color=start_speed))
p_r <- p_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Swinging Strikes v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
p_r <- p_r + geom_point(size = 3, alpha = .65)
p_r <- p_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_swingR.png", width=600)
p_r
dev.off()

## Plot of all called strikes
c_r <- ggplot(ArrietaTakeR, aes(px,pz,color=start_speed))
c_r <- c_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Called Strikes v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
c_r <- c_r + geom_point(size = 3, alpha = .65)
c_r <- c_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_takeR.png", width=600)
c_r
dev.off()

## Plot of all foul balls
f_r <- ggplot(ArrietaFoulR, aes(px,pz,color=start_speed))
f_r <- f_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Fouled Balls v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
f_r <- f_r + geom_point(size = 3, alpha = .65)
f_r <- f_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_foulR.png", width=600)
f_r
dev.off()

## Plot of all called balls
b_r <- ggplot(ArrietaBallR, aes(px,pz,color=start_speed))
b_r <- b_r + scale_x_continuous(limits = c(-3,3)) + scale_y_continuous(limits = c(0,5)) + annotate("rect", xmin = -1, xmax = 1, ymin = 1.5, ymax = 3.5, color = "black", alpha = 0) + labs(title = "Jake Arrieta: Balls v. RHB, 2015") + ylab("Vertical Location (ft.)") + xlab("Horizontal Location (ft): Catcher's View") + labs(color = "Velocity (mph)")
b_r <- b_r + geom_point(size = 3, alpha = .65)
b_r <- b_r + theme(axis.title = element_text(size = 15, color = "black", face = "bold")) + theme(plot.title = element_text(size = 25, face = "bold", vjust = 1)) + theme(axis.text = element_text(size = 13, face = "bold", color = "black")) + theme(legend.title = element_text(size = 12)) + theme(legend.text = element_text(size = 12))
png("Arrieta_ballR.png", width=600)
b_r
dev.off()