#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=4

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1
mkdir -p graphs_proteins
mkdir -p graphs_dna

PanPA build_gfa -d msas_proteins_0.4/ -c 4 -o graphs_proteins

#<<!
for i in `ls msas_dna_0.4`;do
	ii=`echo $i | sed 's/fasta/gfa/g'`
	vg construct -m 999999999 -M msas_dna_0.4/${i} | ~/software/vg convert -f - > graphs_dna/${ii}
done
#!


