#!/bin/bash

header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=6

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr
"

set -x
set -e

vg="vg"
date

for chr in 01 02 03 04 05 06 07 08 09 10;
do
    echo $chr
    echo "$header" > run_index_split_chr${chr}.sh
#    echo -e "~/software/vg mod -t 80 -X 256 -c ${vg}/Chr${chr}.renamed.vg > ${vg}/Chr${chr}.mod.vg" >> run_index_split_chr${chr}.sh
    echo -e "~/software/vg view --threads 80 -j ${vg}/Chr${chr}.mod.vg > index/${chr}.json" >> run_index_split_chr${chr}.sh
    echo -e "graph_peak_caller create_ob_graph index/${chr}.json" >> run_index_split_chr${chr}.sh
    echo -e "~/software/vg stats --threads 80 -r ${vg}/Chr${chr}.mod.vg  | awk '{print \$2}' > index/node_range_${chr}.txt" >> run_index_split_chr${chr}.sh
    echo -e "graph_peak_caller find_linear_path -g index/${chr}.nobg index/${chr}.json \"Chr${chr}\" index/${chr}_linear_pathv2.interval" >> run_index_split_chr${chr}.sh
    date
done

date



