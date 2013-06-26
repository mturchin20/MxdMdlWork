cmd_args = commandArgs()
Data1 <- read.table("/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm", header=TRUE)
Data2 <- read.table(paste("/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.", cmd_args[5], ".txt", sep=""), header=FALSE)	

for (i in 3:length(Data1[1,])) {
#for (i in 3:10) {
	LnRgRslts <- eval(parse(text = c("lm(Data1[,", i, "] ~ Data2[,1]", paste(" + Data2[,",2:(as.numeric(strsplit(cmd_args[5], "P")[[1]][1])), "]", sep="", collapse=""), ")")))
#	LnRgRslts <- eval(parse(text = c("lm(Data1[,", i, "] ~ Data2[,4]", paste(" + Data2[,",5:(as.numeric(strsplit(c("10PCs"), "P")[[1]][1])+3), "]", sep="", collapse=""), ")")))
	Data1[,i] <- qqnorm(LnRgRslts$residuals, plot.it=FALSE)$x
}

write.table(Data1, "", quote=FALSE, row.names=FALSE, col.names=TRUE)
