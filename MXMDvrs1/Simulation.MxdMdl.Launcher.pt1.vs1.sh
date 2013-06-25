#!/bin/sh

PCS="$1"
i="$2"
POP="$3"

#rm Simulations/${PCS}/${POP}Round$i/qsubout
rm Simulations/${PCS}/CHBCEPHwthnPopwthnPopPermRound${i}/qsubout

for j in {1..843}
#for j in {1..1}
do
	
	LIST1="$HOME/Data/Stranger07/ENSEMBL_CisSNPs_vs2/MultiLists/FileList.rsID.justENSG.group${j}.txt"
	
#	QSUBOUT1="Simulations/${PCS}/${POP}Round$i/qsubout"
	QSUBOUT1="Simulations/${PCS}/CHBCEPHwthnPopwthnPopPermRound${i}/qsubout"

	qsub -cwd -o $QSUBOUT1 -e $QSUBOUT1 -l h_vmem=2g $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/MXMDvrs1/Simulation.MxdMdl.pt1.vs1.tmp2.sh $PCS $i $LIST1 $j $POP

	echo "qsub -cwd -o $QSUBOUT1 -e $QSUBOUT1 -l h_vmem=2g $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/MXMDvrs1/Simulation.MxdMdl.pt1.vs1.tmp2.sh $PCS $i $LIST1 $j $POP" >> $QSUBOUT1

#	bash $HOME/Lab_Stuff/StephensLab/MxdMdlStuff/MXMDvrs/Simulation.MxdMdl.pt2.sh $i $LIST $j

#	sleep 1

done

