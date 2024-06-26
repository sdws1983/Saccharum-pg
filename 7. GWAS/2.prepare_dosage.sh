#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=8

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1
zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.vcf.gz |awk '!/^#/{printf $1"\t"$1"."$2"\t0\t"$2; for(i=10;i<=NF;i++){split($i,a,":");split(a[3],b,",");if(a[1]==".\/."){printf "\t9"}else{printf "\t"2*b[1]/a[2]}}; printf "\n"}' > emmax/emmax_in.tped
