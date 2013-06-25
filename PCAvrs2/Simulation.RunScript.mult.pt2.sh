#!/bin/sh

VERS="$1"
PCS="$2"
ROUND="$3"

#if [ "$PCS" == "0PCs" ]; then
#	ROUND=0
#fi

#COVARFILE="/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.eigenVectors.${PC}.txt"
#PERMUTEFILE1="/mnt/lustre/home/mturchin20/Lab_Stuff/StephensLab/MxdMdlStuff/PCAvrs/${PC}/Round${ROUND}/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm.Permute${PC}Round${ROUND}"

rm Simulations/${VERS}/${PCS}/AllPopwthnPopPermRound${ROUND}/qsubout

#for list in `cat $HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/MultiLists/FileList.rsID.justENSG.groupAll.txt` 
for i in {1..843}
#for i in {1..2}
do

        LIST="$HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/MultiLists/FileList.rsID.justENSG.group${i}.txt"

	QSUBOUT1="Simulations/${VERS}/${PCS}/AllPopwthnPopPermRound${ROUND}/qsubout"

	qsub -cwd -o $QSUBOUT1 -e $QSUBOUT1 -l h_vmem=2g Simulation.RunScript.mult.pt3.sh $VERS $PCS $ROUND $LIST $i
#	qsub -cwd -o Simulations/$VERS/$PCS/Round$ROUND/qsubout -e Simulations/$VERS/$PCS/Round$ROUND/qsubout -l h_vmem=1g,bigio=1 Simulation.RunScript.mult.pt3.sh $VERS $PCS $ROUND $LIST $i

	echo "qsub -cwd -o $QSUBOUT1 -e $QSUBOUT1 -l h_vmem=2g Simulation.RunScript.mult.pt3.sh $VERS $PCS $ROUND $LIST $i" >> $QSUBOUT1

#	sleep 1

done

#rm PermutePhenoOutput
