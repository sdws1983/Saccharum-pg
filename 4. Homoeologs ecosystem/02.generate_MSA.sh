#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=2

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1
for i in 0.4;do
	mkdir -p msas_proteins_${i}
	mkdir -p msas_dna_${i}
	python3 ~/software/PanPA/scripts/alignment_validation/move_1seq_file_to_msa.py clusters_proteins_${i} msas_proteins_${i}
	python3 ~/software/PanPA/scripts/alignment_validation/move_1seq_file_to_msa.py clusters_dna_${i} msas_dna_${i}
	for f in `ls -1 clusters_proteins_${i}/`;do 
		clustalo --in clusters_proteins_${i}/$f > msas_proteins_${i}/$f
	done
	for f in `ls -1 clusters_dna_${i}/`;do 
		mafft --auto clusters_dna_${i}/$f  > msas_dna_${i}/$f
	done
done
