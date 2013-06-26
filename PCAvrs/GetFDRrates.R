cmd_args = commandArgs()
Data1 <- read.table(cmd_args[5], header=FALSE)
Data1 <- Data1[order(Data1[,9]),]

FnlRslts <- c()

for (i in c(0, 10, seq(20,40, by=1), 50)) {
	
	File1 <- NULL
	
	if (i %in% c(0, 10, 20, 30, 40, 50)) {
		File1 <- paste(i, "PCs/hapmap_r28_b36_Stranger_all.Round1.AllGenes.assoc.linear.topResults.gz", sep="")
	}
	else {
		File1 <- paste("FinePCs/", i, "PCs/hapmap_r28_b36_Stranger_all.", i, "PCs.Round1.AllGenes.assoc.linear.topResults.gz" ,sep="")
	}		
	
	Data2 <- read.table(File1, header=FALSE)

	Data2 <- Data2[order(Data2[,9]),]	

	FDRs <- c()
	cnt1 <- 0

	for (j in 1:length(Data2[,9])) {
		pVal <- Data2[j,9]
		N0 <- length(Data1[Data1[,9]<=pVal,9]) / 50
		if ((N0 > 0) && (cnt1 < 4)) {
			FDR <- N0 / j
			
			if ((FDR >= .01) && (cnt1 < 1)) {
				FDRs <- c(FDRs, c(pVal, j, N0))
				cnt1 <- cnt1 + 1
			}
			if ((FDR >= .02) && (cnt1 < 2)) {
				FDRs <- c(FDRs, c(pVal, j, N0))
				cnt1 <- cnt1 + 1
			}
			if ((FDR >= .05) && (cnt1 < 3)) {
				FDRs <- c(FDRs, c(pVal, j, N0))
				cnt1 <- cnt1 + 1
			}
			if ((FDR >= .1) && (cnt1 < 4)) {
				FDRs <- c(FDRs, c(pVal, j, N0))
				cnt1 <- cnt1 + 1
			}
		}
		else if (cnt1 >= 4) {
			break
		}
		else {

		}
	}
	
	FnlRslts <- rbind(FnlRslts, FDRs)

}

colnames(FnlRslts) <- c(".01", "N1", "N0", ".02", "N1", "N0", ".05", "N1", "N0", ".1", "N1", "N0")

write.table(FnlRslts, "", quote=FALSE, row.names=FALSE, col.names=TRUE) 
