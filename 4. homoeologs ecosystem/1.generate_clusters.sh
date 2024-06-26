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

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/reference/Np-X/Np-X.3ddna.Chr.v20210804.pep.primary.fa | sed '/^$/d' > tmp && mv tmp all_proteins.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ~/reference/Np-X/Np-X.3ddna.Chr.v20210804.dna.fa | sed '/^$/d' > tmp && mv tmp all_dna.fasta

for i in 0.4;do
	mmseqs easy-linclust all_proteins.fasta all_proteins_cluster_${i} tmp --min-seq-id $i
	rm -rf tmp
	cut -f1 all_proteins_cluster_${i}_cluster.tsv | uniq > cluster_names_${i}.txt
	mkdir clusters_proteins_${i}
	mkdir clusters_dna_${i}
	python3 ~/software/PanPA/scripts/extract_clusters.py cluster_names_${i}.txt all_proteins_cluster_${i}_all_seqs.fasta clusters_proteins_${i}/
	python3 dna_cluster.py all_proteins_cluster_${i}_cluster.tsv all_dna.fasta > all_dna_cluster_${i}_all_seqs.fasta
	python3 ~/software/PanPA/scripts/extract_clusters.py cluster_names_${i}.txt all_dna_cluster_${i}_all_seqs.fasta clusters_dna_${i}/

done
