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
gfatools stat ../../pggb/combined_graphs/s20k.graphs.combined.gfa > ROC22.gfa.stats
gfatools stat ../growth/_ap85/graphs_s5k_p90/s5k.graphs.combined.gfa > AP85.gfa.stats
gfatools stat ../growth/pan-growth/la/s20k.graphs.combined.gfa > LAp.gfa.stats
gfatools stat ../growth/pan-growth/NP-x/s20k.graphs.combined.gfa > NpX.gfa.stats
gfatools stat ../growth/pan-growth/zg/s20k.graphs.combined.gfa > ZG.gfa.stats
gfatools stat /share/home/stu_wutingting/execise/workspace/Allele_pangenome/R570/merge/R570.graphs.combined.gfa > R570.gfa.stats
gfatools stat /share/home/stu_wutingting/execise/workspace/Allele_pangenome/ZZ/merge/ZZ.graphs.combined.gfa > ZZ.gfa.stats


echo "id segments links arcs mrank totalseg avgseg s mdegree avgdegree" > all_graphs.stat; for i in AP85 NpX LAp ZG ROC22 ZZ R570;do cat ${i}".gfa.stats" | awk -F ': ' 'BEGIN{print "'$i'"}{print $2}'|xargs -n 10 >> all_graphs.stat;done 2>e
