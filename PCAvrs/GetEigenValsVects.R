cmd_args = commandArgs()
#Data1 <- t(read.table(cmd_args[5], header=FALSE))
Data1 <- read.table(cmd_args[5], header=FALSE)
	
Data1 <- Data1[2:length(Data1[,1]),] #Getting rid of top header (first row)

Data1[,4:length(Data1[1,])] <-  apply(Data1[,4:length(Data1[1,])], 2, as.numeric)

#Data2 <- Data1[,4:length(Data1[1,])] #If want to check median of all gene expression data per individual -- commonly done as QC for other dataset checks
#medianRslts <- apply(Data2, 1, median)
#hist(medianRslts)

#for (i in 4:length(Data1[1,])) {		#Quantile-Normalizing each gene
#	Data1[Data1[,3]=="CEPH",i] <- qqnorm(Data1[Data1[,3]=="CEPH",i], plot.it=FALSE)$x
#	Data1[Data1[,3]=="YRI",i] <- qqnorm(Data1[Data1[,3]=="YRI",i], plot.it=FALSE)$x
#	Data1[Data1[,3]=="CHB",i] <- qqnorm(Data1[Data1[,3]=="CHB",i], plot.it=FALSE)$x
#}

#Within-population quantile-normalizing each gene
#Data1[Data1[,3]=="CEPH",4:length(Data1[1,])] <- apply(Data1[Data1[,3]=="CEPH",4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)
#Data1[Data1[,3]=="YRI",4:length(Data1[1,])] <- apply(Data1[Data1[,3]=="YRI",4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)
#Data1[Data1[,3]=="CHB",4:length(Data1[1,])] <- apply(Data1[Data1[,3]=="CHB",4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)

#Quantile-normalizing each gene independent of sub-populations
#Data1[,4:length(Data1[1,])] <- apply(Data1[,4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)

#Quantile-normalizing a random subset of 90, 60 and 60
Seq1 <- sample(1:210)
#Data1[Seq1[1:90],4:length(Data1[1,])] <- apply(Data1[Seq1[1:90],4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)
#Data1[Seq1[91:150],4:length(Data1[1,])] <- apply(Data1[Seq1[91:150],4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)
#Data1[Seq1[151:210],4:length(Data1[1,])] <- apply(Data1[Seq1[151:210],4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)

Data1 <- Data1[,4:length(Data1[1,])] #Getting rid of row headers (first two columns)

Means <- apply(Data1, 2, mean)	#Getting Mean and SD for each column
SDs <- apply(Data1, 2, sd)

#I <- matrix(rep(1, length(Data1[,1])*length(Data1[1,])), nrow=length(Data1[,1]))
#MeanMtrx <- matrix(rep(Means, length(Data1[,1])), byrow=TRUE, nrow=length(Data1[,1]))	#Creating Mean and SD matrices
#SDMtrx <- matrix(rep(SDs, length(Data1[,1])), byrow=TRUE, nrow=length(Data1[,1]))

#Data1 <- (Data1 - MeanMtrx) / SDMtrx	#Centralizing and Standardizing main data matrix

CovMtrx <- (1/length(Data1[1,])) * (as.matrix(Data1) %*% t(as.matrix(Data1)))		#Creating 1/p * covariance matrix

Results1 <- eigen(CovMtrx)		#Getting eigenvectors and eigenvalues

write.table(Results1$vectors, cmd_args[6], quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(Results1$values, cmd_args[7], quote=FALSE, row.names=FALSE, col.names=FALSE)


##############
###Data log###
##############

#> Data1 <- read.table("/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wHPMPid.gz", header=FALSE)
#> Data1[1:5,1:5]
#   V1      V2  V3              V4              V5
#   1 FID     IID POP ENSG00000187634 ENSG00000187961
#   2   1 NA18524 CHB         6.42588         9.00134
#   3   2 NA18526 CHB         6.34857         8.68707
#   4   3 NA18529 CHB         6.46448         8.76156
#   5   4 NA18532 CHB         6.37794         9.17925
#   > Data1 <- Data1[2:length(Data1[,1]),] #Getting rid of top header (first row)
#   >
#   > Data1[,4:length(Data1[1,])] <-  apply(Data1[,4:length(Data1[1,])], 2, as.numeric)
#   >
#   > Data1[1:5,1:5]
#     V1      V2  V3      V4      V5
#     2  1 NA18524 CHB 6.42588 9.00134
#     3  2 NA18526 CHB 6.34857 8.68707
#     4  3 NA18529 CHB 6.46448 8.76156
#     5  4 NA18532 CHB 6.37794 9.17925
#     6  5 NA18537 CHB 6.39174 8.70063
#     > Data1[,4:length(Data1[1,])] <- apply(Data1[,4:length(Data1[1,])], 2, function(y) qqnorm(y, plot.it=FALSE)$x)
#     > Data1[1:5,1:5]
#       V1      V2  V3         V4         V5
#       2  1 NA18524 CHB -0.4770404  0.5039654
#       3  2 NA18526 CHB -1.0781824 -0.6156959
#       4  3 NA18529 CHB -0.1497620 -0.3470265
#       5  4 NA18532 CHB -0.8501565  1.0570776
#       6  5 NA18537 CHB -0.7201566 -0.5589579
#       > Data1 <- Data1[,4:length(Data1[1,])] #Getting rid of row headers (first two columns)
#       >
#       > Means <- apply(Data1, 2, mean)  #Getting Mean and SD for each column
#       > SDs <- apply(Data1, 2, sd)
#       >
#       > #I <- matrix(rep(1, length(Data1[,1])*length(Data1[1,])), nrow=length(Data1[,1]))
#       > MeanMtrx <- matrix(rep(Means, length(Data1[,1])), byrow=TRUE, nrow=length(Data1[,1]))   #Creating Mean and SD matrices
#       > SDMtrx <- matrix(rep(SDs, length(Data1[,1])), byrow=TRUE, nrow=length(Data1[,1]))
#       >
#       > #Data1 <- (Data1 - MeanMtrx) / SDMtrx   #Centralizing and Standardizing main data matrix
#       >
#       > CovMtrx <- (1/length(Data1[1,])) * (as.matrix(Data1) %*% t(as.matrix(Data1)))           #Creating 1/p * covariance matrix
#       >
#       > Results1 <- eigen(CovMtrx)              #Getting eigenvectors and eigenvalues
#       > CovMtrx[1:5,1:5]
#                  2          3           4           5          6
#		  2 0.95511276  0.0540701  0.06472216  0.47045660 0.08949228
#		  3 0.05407010  1.3437347  0.60808475 -0.05819240 0.55403112
#		  4 0.06472216  0.6080847  1.26739125 -0.06139981 0.36951139
#		  5 0.47045660 -0.0581924 -0.06139981  0.79545792 0.01013631
#		  6 0.08949228  0.5540311  0.36951139  0.01013631 0.76484822
#		  > beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm
#		  > write.table(Results1$vectors, "beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.txt" , quote=FALSE, row.names=FALSE, col.names=FALSE)
#		  > write.table(Results1$values, "beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenValues.txt" , quote=FALSE, row.names=FALSE, col.names=FALSE)
#		  > write.table(CovMtrx, "beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm" , quote=FALSE, row.names=FALSE, col.names=FALSE)

