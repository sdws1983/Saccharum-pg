<<!
#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=6:ppn=1

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr
!

index="../../calling/vg/"
graph_dir="../../calling/index/"
chromosomes="01,02,03,04,05,06,07,08,09,10"

prefix="LA-2-LF15"
f="LA-2"

mkdir -p $f
~/software/vg map -t 80 -x ${index}/wg.xg -g ${index}/wg.gcsa -f ~/others/ZG/data/Fastp过滤后数据/Merge_data/${prefix}_1.fq.gz -f ~/others/ZG/data/Fastp过滤后数据/Merge_data/${prefix}_2.fq.gz > ${f}/${prefix}.gam

vg stats -a ${f}/${prefix}.gam

~/software/vg filter -r 0.95 -s 2.0 -q 60 -fu ${f}/${prefix}.gam > ${f}/${prefix}.filtered.gam

~/software/vg view -aj ${f}/${prefix}.filtered.gam > ${f}/${prefix}.json

graph_peak_caller split_vg_json_reads_into_chromosomes $chromosomes ${f}/${prefix}.filtered.json $graph_dir
graph_peak_caller estimate_shift $chromosomes $graph_dir/ ${f}/${prefix}.filtered_ 5 100
