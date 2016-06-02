logs = read.csv("logs.csv")
attach(logs)
lower_states <- c("ak","al","ar","az","ca","co","ct","de","fl","ga","hi","ia","id","il","in","ks","ky","la","ma","md","me","mi","mn","mo","ms","mt","nc","nd","ne","nh","nj","nm","nv","ny","oh","ok","or","pa","ri","sc","sd","tn","tx","ut","va","vt","wa","wi","wv","wy")
upper_states <- c("AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY")
png("stateplot.png", height=960)
par(mfrow=c(10,5))
par(mar=c(0,0,1,0))
for (i in 1:50){
	plot(
		get(paste0(lower_states[i],"rank")),
		get(paste0(lower_states[i],"pop")),
		main=paste0(upper_states[i]),
		xlab="",
		ylab="",
		pch=16,
		xaxt="n",
		yaxt="n"
		)
	}
dev.off()