#!/bin/sh
	

for gene in `cat in $2`
do
	
	GENELIST="/mnt/lustre/home/mturchin20/Data/Stranger07/ENSEMBL_CisSNPs_vs2/MapCisGenes.Stranger07.Gene_${gene}.snpList.rsIDs"
	OUTFILE1="${TMPDIR}/hapmap_r28_b36_Stranger_all.${3}.${4}.${gene}"
	OUTFILE2="/mnt/lustre/home/mturchin20/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs/${PC}/Round${ROUND}/hapmap_r28_b36_Stranger_all.${gene}.assoc.linear.gz"

#	echo $gene
#	echo $5
#	echo $GENELIST
#	echo $OUTFILE1
	
	if [ "$1" == "0" ]; then
	
		plink --bfile $HOME/Data/Stranger07/hapmap_r28_b36_Stranger_all --extract $GENELIST --pheno $5 --pheno-name $gene --linear --silent --out $OUTFILE1
		
		rm $OUTFILE1*nof
		rm $OUTFILE1*nosex
		rm $OUTFILE1*log
	
		cat $OUTFILE1.assoc.linear | perl -lane 'print join("\t", @F), "\t", '$gene';' > $OUTFILE1.assoc.linear.tmp
	
		mv $OUTFILE1.assoc.linear.tmp $OUTFILE1.assoc.linear
	
		rm -f $OUTFILE1.assoc.linear.gz
		gzip -f $OUTFILE1.assoc.linear
	
		mv $OUTFILE1.assoc.linear.gz $OUTFILE2
	
	elif [ "$1" == "1" ]; then
	
		plink --bfile $HOME/Data/Stranger07/hapmap_r28_b36_Stranger_all --extract $GENELIST --pheno $5 --pheno-name $gene --covar $6 --linear --silent --hide-covar --out $OUTFILE1
		
		rm $OUTFILE1*nof
		rm $OUTFILE1*nosex
		rm $OUTFILE1*log
			
		cat $OUTFILE1.assoc.linear | perl -lane 'print join("\t", @F), "\t", '$gene';' > $OUTFILE1.assoc.linear.tmp
	
		mv $OUTFILE1.assoc.linear.tmp $OUTFILE1.assoc.linear
	
		rm -f $OUTFILE1.assoc.linear.gz
		gzip -f $OUTFILE1.assoc.linear
	
		mv $OUTFILE1.assoc.linear.gz $OUTFILE2
	
	else
		echo "Error1"	
	fi


done
