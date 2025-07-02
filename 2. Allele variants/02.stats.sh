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

gfatools stat ROC22.graphs.combined.gfa > ROC22.gfa.stats
gfatools stat AP85.graphs.combined.gfa > AP85.gfa.stats
gfatools stat LAp.graphs.combined.gfa > LAp.gfa.stats
gfatools stat NpX.graphs.combined.gfa > NpX.gfa.stats
gfatools stat ZG.graphs.combined.gfa > ZG.gfa.stats
gfatools stat R570.graphs.combined.gfa > R570.gfa.stats
gfatools stat ZZ.graphs.combined.gfa > ZZ.gfa.stats


echo "id segments links arcs mrank totalseg avgseg s mdegree avgdegree" > all_graphs.stat; for i in AP85 NpX LAp ZG ROC22 ZZ R570;do cat ${i}".gfa.stats" | awk -F ': ' 'BEGIN{print "'$i'"}{print $2}'|xargs -n 10 >> all_graphs.stat;done 2>e
