#!/bin/sh

#########

# - Note (10/22/2012): $i is essentially $PHENOCOL (minus 1). Vs0 in files refers to non-permuted values,mthough in $PHENOCOL 1 is the non-permuted value. Going
#   through the .pheno file columns, 1-51 is for the explicit covariate versions, whereas 52-107 is for the residual versions. 52, 63, 74, 85 and 96 are the  
#   non-permuted versions for the residual runs (and note, for the explicit covariate version, the code returns to column 1 of the .pheno file for each set of
#   PCs used as covariates).
#
# - Command ranges: Covar, 0PCs 1, 10PCs 2-11, 20PCs 12-21, 30PCs 22-31, 40PCs 32-41, 50PCs 42-51
#                   Resid, 10PCs 52-62, 20PCs 63-73, 30PCs 74-84, 40PCs 85-95, 50PCs 96-106
#
#
#
#########

DATE1=`date`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~ ${JOB_ID} - ${DATE1} - ${HOSTNAME} ~~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

##$PCS $ROUND $LIST $i

COVAR1=""
VERS="$1"
PCS="$2"
PHENOCOL="$3"
GROUPNUM="$5"
declare -i j
declare -i k=0

mkdir $TMPDIR/$1_$2_$5
mkdir $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0
if [ "$PHENOCOL" -gt 1 ]; then
		mkdir $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL
fi

for gene in `cat $4`
do
	BED1="${HOME}/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group${5}/hapmap_r28_b36_Stranger_all_${gene}.allPopNorm.wthnPopPerm.bed"
	BIM1="${HOME}/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group${5}/hapmap_r28_b36_Stranger_all_${gene}.allPopNorm.wthnPopPerm.bim"
	FAM1="${HOME}/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group${5}/hapmap_r28_b36_Stranger_all_${gene}.noPheno.fam"
	PHENO1="${HOME}/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group${5}/hapmap_r28_b36_Stranger_all_${gene}.allPopNorm.wthnPopPerm.CovarResids.PLINKrdy.pheno"
	OUTFILE1=""

	if [ "$VERS" == "Covar" ]; then
		let j=$PHENOCOL-1
#		COVAR1="${HOME}/Data/Stranger07/PermutedPCs/beforeCorrection_onlyExpGenes.eigenVectors.${PCS}.wSex.PLINKrdy.permuteVs${j}"	
		COVAR1="${HOME}/Data/Stranger07/PermutedPCs/Covar/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.${PCS}.wSex.PLINKrdy.wthnPopPerm.permuteVs${j}"
#		COVAR1="${HOME}/Data/Stranger07/PermutedPCs/Covar/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.noNorm.eigenVectors.${PCS}.wSex.wPopIdnt.PLINKrdy.wthnPopPerm.permuteVs${j}"	
#		COVAR1="${HOME}/Data/Stranger07/PermutedPCs/Covar/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.eigenVectors.40PCs.wSex.PLINKrdy.wthnPopPerm.permuteVs${j}"	
#		COVAR1="${HOME}/Data/Stranger07/PermutedPCs/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.40PCs.wSex.PLINKrdy.permuteVs{$j}"	

		if [ "$PCS" == "0PCs" ]; then	
			if [ "$PHENOCOL" == "0" ]; then
				COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.wthnPopPerm.permuteVs0.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			elif [ "$PHENOCOL" -gt 1 ]; then
				COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.wthnPopPerm.permuteVs${j}.txt"
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound${PHENOCOL}/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno $PHENOCOL --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			else
				"Error1b - \$PHENOCOL ($PHENOCOL) is neither 1 or greater than 1"	
			fi
		else
			if [ "$PHENOCOL" -gt 1 ]; then
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound${PHENOCOL}/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno $PHENOCOL --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
#				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 107 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
#				echo plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno $PHENOCOL --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "2" ]; then
#			if [ "$PHENOCOL" == "3" ]; then
#				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.10PCs.wSex.PLINKrdy.txt"	
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.10PCs.wSex.PLINKrdy.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "12" ]; then
#				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.20PCs.wSex.PLINKrdy.txt"	
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.20PCs.wSex.PLINKrdy.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "22" ]; then
#				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.30PCs.wSex.PLINKrdy.txt"	
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.30PCs.wSex.PLINKrdy.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "32" ]; then
#			if [ "$PHENOCOL" == "2" ]; then
#				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.40PCs.wSex.PLINKrdy.txt"	
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.noNorm.eigenVectors.40PCs.wSex.PLINKrdy.txt"	
#				COVAR1="${HOME}/Data/Stranger07/PermutedPCs/Covar/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.40PCs.wSex.wPopIdnt.PLINKrdy.wthnPopPerm.permuteVs0"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "42" ]; then
#				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.50PCs.wSex.PLINKrdy.txt"	
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.50PCs.wSex.PLINKrdy.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
			if [ "$PHENOCOL" == "51" ]; then
				COVAR1="${HOME}/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.allPopNorm.eigenVectors.60PCs.wSex.PLINKrdy.txt"	
				OUTFILE1="${TMPDIR}/${1}_${2}_${5}/AllPopwthnPopPermRound0/hapmap_r28_b36_Stranger_all_${gene}"
				plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno 1 --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
			fi
			
		fi

	elif [ "$VERS" == "Resid" ]; then

		if [ "$PHENOCOL" -lt 63 ] ; then
			k=1
		elif [ "$PHENOCOL" -lt 74 ] ; then
			k=2
		elif [ "$PHENOCOL" -lt 85 ] ; then
			k=3
		elif [ "$PHENOCOL" -lt 96 ] ; then
			k=4
		elif [ "$PHENOCOL" -lt 107 ] ; then
			k=5
		else 
			echo "Error1b - \$PHENOCOL ($PHENOCOL) is not less than 63, 74, 85, 96 or 107"
		fi

		let j=$PHENOCOL-51-$k
		
		COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs${j}.txt"	

		if [ "$PHENOCOL" == "52" ] ; then
			COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs0.txt"	
		fi

		if [ "$PHENOCOL" == "63" ] ; then
			COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs0.txt"	
		fi

		if [ "$PHENOCOL" == "74" ] ; then
			COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs0.txt"	
		fi

		if [ "$PHENOCOL" == "85" ] ; then
			COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs0.txt"	
		fi

		if [ "$PHENOCOL" == "96" ] ; then
			COVAR1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.PLINKrdy.permuteVs0.txt"	
		fi

		OUTFILE1="${TMPDIR}/${1}_${2}_${5}/Round${PHENOCOL}/hapmap_r28_b36_Stranger_all_${gene}"
				
		plink --bed $BED1 --bim $BIM1 --fam $FAM1 --pheno $PHENO1 --mpheno $PHENOCOL --covar $COVAR1 --maf .01 --geno .05 --nonfounders --linear --silent --hide-covar --allow-no-sex --out $OUTFILE1
		
	else
		echo "Error1a - \$VERS ($VERS) neither Covar or Resid"
	fi
done

if [ "$PCS" == "0PCs" ]; then
	if [ "$PHENOCOL" == "0" ]; then
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi

	if [ "$PHENOCOL" -gt 1 ]; then
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound$PHENOCOL/.  
	fi

else
	if [ "$PHENOCOL" == "2" ]; then
#	if [ "$PHENOCOL" == "3" ]; then
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi
	if [ "$PHENOCOL" == "12" ]; then
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi
	if [ "$PHENOCOL" == "22" ]; then 
		:
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi
	if [ "$PHENOCOL" == "32" ]; then
#	if [ "$PHENOCOL" == "2" ]; then
		:
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi
	if [ "$PHENOCOL" == "42" ]; then
		:
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi
	if [ "$PHENOCOL" == "51" ]; then
		:
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound0/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound0/.  
	fi

	if [ "$PHENOCOL" -gt 1 ]; then
		rm -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/*nosex
		gzip -f $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/*
		mv $TMPDIR/$1_$2_$5/AllPopwthnPopPermRound$PHENOCOL/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs2/Simulations/$VERS/$PCS/AllPopwthnPopPermRound$PHENOCOL/. 
	fi
fi

rm -r $TMPDIR/$1_$2_$5 
