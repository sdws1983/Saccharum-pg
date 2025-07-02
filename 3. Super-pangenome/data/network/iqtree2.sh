#!/bin/bash
#PBS -q FAFU1
#PBS -l nodes=1:ppn=6


source /public/home/off_huangyumin/.bashrc

conda activate

cd $PBS_O_WORKDIR

echo "1"

~/software/iqtree-2.4.0-Linux-intel/bin/iqtree2 -s Saccharum_genus.re.community.0.SNP.max-missing0.7.min4.phy -S partition.txt --prefix Genetree/loci -T AUTO
