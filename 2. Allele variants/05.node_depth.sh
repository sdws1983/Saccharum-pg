#!/bin/bash

header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=1

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr"


para="s20000"
outdir="output"
win=10000

ref="ROC22_A"
prefix="ROC22"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/graphs/ROC22"
for i in `seq 1 10`; do 
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
	echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
	echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done






ref="nR570_A"
prefix="R570"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/nR570/nR570"
for i in `seq 1 10`; do
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done




para="s10000"

ref="ZZ_A"
prefix="ZZ"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/ZZ/ZZ"
for i in `seq 1 10`; do
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done




para="s5000"
outdir="output"
win=10000
#p="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_ap85/graph/AP85"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_ap85/graphs_s5k_p90/AP85"
ref="AP85_A"
prefix="AP85"
for i in `seq 1 8`; do 
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done

para="s20000"
outdir="output"
win=10000

ref="NpX_A"
prefix="NpX"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_NP-x/graphs_s20k/NpX"
for i in `seq 1 10`; do
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done


ref="LAp_A"
prefix="LAp"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_la/graphs_s20k/LAp"
for i in `seq -w 1 10`; do
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done


ref="ZG_A"
prefix="ZG"
p="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_zg/graphs_s20k/ZG"
for i in `seq -w 1 10`; do
        path="${p}.Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -r \"${ref}#1#Chr${i}\" |bedtools makewindows -b - -w $win > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
        echo -e "odgi depth -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.${prefix}.bed |bedtools sort > ${outdir}/${para}.Chr${i}.w${win}.${prefix}.depth.bed" >> run_odgi_depth_chr${i}.${prefix}.sh
done



