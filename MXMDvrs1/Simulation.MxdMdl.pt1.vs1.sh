#!/bin/sh

PCS="$1"
i="$2"
LIST1="$3"
j="$4"
#POP="$5"

DATE1=`date`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~ JobInfo: ${JOB_ID} - ${DATE1} - ${HOSTNAME} - ${PCS} - ${i} - ${j} - ${POP} ~~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


mkdir $TMPDIR/Group$j
#mkdir $TMPDIR/Group$j/Results
cd $TMPDIR/Group$j
#cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/*[0-9].fam $TMPDIR/Group$j/.
#cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/*[0-9].bim $TMPDIR/Group$j/.
#cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/*[0-9].bed $TMPDIR/Group$j/.
#cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/*just${POP}* $TMPDIR/Group$j/.
#cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/*noNorm* $TMPDIR/Group$j/.
cp -p $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/BrkDwnPLINKFiles/Group$j/GEMMA/PopSubsets/*CEPHYRI.wthnPopNorm* $TMPDIR/Group$j/.

for gene in `cat $LIST1`
do

	PLINKFILE1="${TMPDIR}/Group${j}/hapmap_r28_b36_Stranger_all_${gene}.CEPHYRI.wthnPopNorm"
#	PLINKFILE1="${TMPDIR}/Group${j}/hapmap_r28_b36_Stranger_all_${gene}.just${POP}"
	COVARFILE1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.GEMMAformat.CEPHYRI.wthnPopPerm.permuteVs${i}.txt"
#	COVARFILE1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.wPopIdntvs2.GEMMAformat.permuteVs${i}.txt"
#	COVARFILE1="${HOME}/Data/Stranger07/PermutedSex/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.2cols.wSex.GEMMAformat.wthnPopPerm.just${POP}.permuteVs${i}.txt"
#	COVARFILE1="${HOME}/Data/Stranger07/PermutedPCs/GEMMA/beforeCorrection_onlyExpGenes.eigenVectors.${PCS}.wSex.GEMMAformat.permuteVs${i}"
#	COVARFILE1="${HOME}/Data/Stranger07/PermutedPCs/GEMMA/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.eigenVectors.${PCS}.wSex.GEMMAformat.wthPopPerm.permuteVs${i}"
	CVXMTRX1="${HOME}/Data/Stranger07/PermutedCvMtrx/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.CEPHYRI.wthnPopNorm.CovMtrx.wthnPopPerm.permuteVs${i}"
#	CVXMTRX1="${HOME}/Data/Stranger07/PermutedCvMtrx/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.noNorm.CovMtrx.permuteVs${i}"
#	CVXMTRX1="${HOME}/Data/Stranger07/PermutedCvMtrx/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.noNorm.CovMtrx.wthnPopPerm.permuteVs${i}"
#	CVXMTRX1="${HOME}/Data/Stranger07/PermutedCvMtrx/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm.CovMtrx.IdntMtrx0"
#	CVXMTRX1="${HOME}/Data/Stranger07/PermutedCvMtrx/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm.CovMtrx.wthnPopPerm.just${POP}.permuteVs${i}"
	OUTFILE1="hapmap_r28_b36_Stranger_all_${gene}.CEPHYRI"
#	OUTFILE1="hapmap_r28_b36_Stranger_all_${gene}.just${POP}"
#	let PHENOCOL=$i+1
	let PHENOCOL=$i+1+50

	$HOME/Software/Gemma/gemma -bfile $PLINKFILE1 -c $COVARFILE1 -k $CVXMTRX1 -n $PHENOCOL -fa 1 -o $OUTFILE1
#	$HOME/Software/Gemma/gemma -bfile $PLINKFILE1 -c $COVARFILE1 -k $CVXMTRX1 -n $PHENOCOL -maf .1 -fa 1 -o $OUTFILE1
#	$HOME/Software/Gemma/gemma -bfile $PLINKFILE1 -c $COVARFILE1 -k $CVXMTRX1 -n $PHENOCOL -fa 1 -o hapmap_r28_b36_Stranger_all_$gene
#	echo	./$HOME/Software/Gemma/gemma -bfile $PLINKFILE1 -c $COVARFILE1 -k $CVXMTRX1 -n $PHENOCOL -fa 1 -o $OUTFILE1
	echo $HOME/Software/Gemma/gemma -bfile $PLINKFILE1 -c $COVARFILE1 -k $CVXMTRX1 -n $PHENOCOL -fa 1 -o $OUTFILE1


done

gzip $TMPDIR/Group$j/output/*

#mv $TMPDIR/Group$j/output/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/MXMDvrs/Simulations/$PCS/${POP}Round$i/. 
mv $TMPDIR/Group$j/output/* $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/MXMDvrs1/Simulations/$PCS/CEPHYRIwthnPopwthnPopPermRound${i}/. 
