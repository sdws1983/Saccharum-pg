#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -o job.%j.stdout
#PBS -e job.%j.stderr
#PBS -l nodes=s002:ppn=1

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr



for i in `ls ../../rebuild/mc/vg/Chr*.vg|fgrep -v "hap"`;do
	p=`basename $i|sed 's/vg/mod.vg/g'`
	echo $p
	vg mod -t 80 -X 256 $i > vg/${p}
done

vg ids -m mapping -j $(for i in 01 02 03 04 05 06 07 08 09 10; do echo vg/Chr${i}.mod.vg; done)
vg index -x vg/wg.xg $(for i in 01 02 03 04 05 06 07 08 09 10; do echo vg/Chr${i}.mod.vg; done)

for chr in 01 02 03 04 05 06 07 08 09 10;
do
    echo $chr
    #vg prune --threads 80 -r vg/LAp.Chr${chr}.mod.vg > vg/LAp.Chr${chr}.pruned.vg
    vg prune -t 80 -u -a -m mapping vg/Chr${chr}.mod.vg > vg/Chr${chr}.pruned.vg
done

vg index --threads 80 --size-limit 409600 -p -b ./tmp -g vg/wg.gcsa -f mapping $(for i in 01 02 03 04 05 06 07 08 09 10; do echo vg/Chr${i}.pruned.vg; done)
