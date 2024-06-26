#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=30

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1

#bcftools merge --threads 60 -o all.combined.raw.sh.vcf.gz -O z ../../sh/*gz

vcftools --gzvcf all.combined.raw.sh.vcf.gz \
        --recode-INFO-all \
        --max-alleles 2 \
        --min-alleles 2 \
        --max-missing 0.8 \
        --out all.combined.Sh.biallelic.max-missing0.8 \
        --recode
       
awk '{if(/^#/){print}else{t1=0;t2=0;for(i=10;i<=NF;i++){split($i,a,":");if(a[3]!="."){split(a[3],b,",");t1+=(b[1]+b[2]);t2+=b[2]}};if(((t2/t1)>=0.05)&&((t2/t1)<=0.95)){print}}}' all.combined.Sh.biallelic.max-missing0.8.recode.vcf > all.combined.Sh.biallelic.max-missing0.8.maf0.05.vcf 
