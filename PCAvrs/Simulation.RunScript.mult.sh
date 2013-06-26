#!/bin/sh

ROUND="$1"
PC="$2"
SEED1="$3"


COVARFILE="/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.${PC}.txt"
PERMUTEFILE1="/mnt/lustre/home/mturchin20/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs/${PC}/Round${ROUND}/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm.Permute${PC}Round${ROUND}"

R --vanilla --slave --args < GetResids.R 

perl PermutePhenos.pl --file1 $HOME/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm --seed $SEED1 > $PERMUTEFILE1
#PERMUTEFILE1="/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm"

for list in `cat $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/MultiLists/FileList.rsID.justENSG.roundAll.txt` 
do

	if [ "$PC" == "0PCs" ]; then
		qsub -o $PWD/$PC/Round$1/qsubout -e $PWD/$PC/Round$1/qsubout -l h_vmem=2g $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs/Simulation.RunScript.JobShell.sh 0 $list $ROUND $PC $PERMUTEFILE1
	else
		qsub -o $PWD/$PC/Round$1/qsubout -e $PWD/$PC/Round$1/qsubout -l h_vmem=2g $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs/Simulation.RunScript.JobShell.sh 1 $list $ROUND $PC $PERMUTEFILE1 $COVARFILE
	fi

#	sleep 1

done

#rm PermutePhenoOutput
