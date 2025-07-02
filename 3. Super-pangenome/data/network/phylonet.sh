#!/bin/bash
#PBS -q FAFU1
#PBS -l nodes=1:ppn=24


source /public/home/off_huangyumin/.bashrc

conda activate

cd $PBS_O_WORKDIR


java -jar ~/software/PhyloNet.jar PhyloNet/locitree_noMan.nex 
