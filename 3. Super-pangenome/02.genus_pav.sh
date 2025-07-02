#!/bin/bash

header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=2

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

echo \"\${PBS_JOBID}.\${PBS_JOBNAME}.\${PBS_O_WORKDIR}\" > ~/qsub_task/job.\`date +\"%Y-%m-%d_%H-%M-%s%N\"\`

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr

"

para="s20000"
ref="Srufi"
outdir="pavs"
win=10000


mkdir -p ${outdir}
for i in `seq 0 9`; do 
	path="../graph_2024/genus.community.${i}_*"
	line=`ls ${path}/*.og`

	echo "$header" > run_odgipav_chr${i}.sh
	echo -e "odgi paths -i ${line} -f -P -t 40| fgrep \"${ref}\" -A 1 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.sh
	echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.sh
	echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai | fgrep \"${ref}#\") -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.sh
	echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.sh
	echo -e "odgi pav -t 40 -P -M -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.matrix" >> run_odgipav_chr${i}.sh

done

