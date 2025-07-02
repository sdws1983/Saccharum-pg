#!/bin/bash

header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=1

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr"


para="s5000"
outdir="pavs_AP85"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_ap85/graphs_s5k_p90/AP85"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="AP85_A"


for i in `seq 1 8`; do 
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done


para="s20000"
outdir="pavs_NpX"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_NP-x/graphs_s20k/NpX"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="NpX_A"


for i in `seq 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done



para="s20000"
outdir="pavs_LAp"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_la/graphs_s20k/LAp"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="LAp_A"


for i in `seq -w 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done



para="s20000"
outdir="pavs_ZG"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/assessment/growth/_zg/graphs_s20k/ZG"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="ZG_A"


for i in `seq -w 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done



para="s20000"
outdir="pavs_ROC22"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/graphs/ROC22"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="ROC22_A"


for i in `seq 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done


para="s20000"
outdir="pavs_R570"
win=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/nR570/nR570"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="nR570_A"


for i in `seq 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done


para="s10000"
outdir="pavs_ZZ"
win=5000
#s=5000
mkdir -p $outdir

og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/ZZ/ZZ"
#og="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/combined_graphs/s20k.graphs.combined.og"
ref="ZZ_A"


for i in `seq 1 10`; do
        path=${og}".Chr${i}_*${para}*"
        line=`ls ${path}/*.og`

        echo "$header" > run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi paths -i ${line} -f -P -t 40 > ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "samtools faidx ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "bedtools makewindows -g <(cut -f 1,2 ${outdir}/${para}.Chr${i}.smooth.final.${ref}.fa.fai) -w ${win} > ${outdir}/${para}.Chr${i}.w${win}.bed" >> run_odgipav_chr${i}.${ref}.sh
        echo -e "odgi pav -t 40 -P -i ${line} -b ${outdir}/${para}.Chr${i}.w${win}.bed > ${outdir}/${para}.Chr${i}.w${win}.pavs.tsv" >> run_odgipav_chr${i}.${ref}.sh

done
