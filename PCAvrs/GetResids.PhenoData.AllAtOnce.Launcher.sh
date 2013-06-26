#!/bin/sh

PCS="$1"
OUTFILE1="/mnt/lustre/home/mturchin20/Data/Stranger07/beforeCorrection_onlyExpGenes.txt.pedOrder.Transposed.wthnPopNorm.${PCS}Resid"

R --vanilla --slave --args < GetResids.PhenoData.AllAtOnce.R $PCS > $OUTFILE1
