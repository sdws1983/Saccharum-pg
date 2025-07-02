#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=1

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1
python3 parse_bubble.py graphs_dna bubble/graphs_dna.bubble bubble/graphs_dna.bubble.log 
#python3 parse_bubble.py graphs_proteins bubble/graphs_proteins.bubble bubble/graphs_proteins.bubble.log
#wait
