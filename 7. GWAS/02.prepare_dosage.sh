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

zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.vcf.gz | awk '{if(/^#/){}else{sum=0;sumsq=0;n=0;for(i=10;i<=NF;i++){if($i~!/^.\/./){split($i,a,":");  sum+=a[2];sumsq+= a[2]*a[2];n+=1 } }; mean=sum/n; stddev = sqrt((sumsq/n)-(mean*mean)) ; print $1"\t"$2"\t"sum"\t"stddev}}' > all.combined.Sh.biallelic.max-missing0.8.maf0.05.sum.std

fgrep -w -f <(awk '{if(($3>=5482)&&($3<=16446)&&($4<=20)){print}}' all.combined.Sh.biallelic.max-missing0.8.maf0.05.sum.std|cut -f1-2) <(zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.vcf.gz) | bgzip -@ 24 > all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.vcf.gz

zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.vcf.gz |awk '!/^#/{printf $1"\t"$1"."$2"\t0\t"$2; for(i=10;i<=NF;i++){split($i,a,":");split(a[3],b,",");if(a[1]==".\/."){printf "\t9"}else{printf "\t"2*b[1]/a[2]}}; printf "\n"}' > emmax/emmax_in.tped

