#!/bin/bash

header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=1

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

echo \"\${PBS_JOBID}.\${PBS_JOBNAME}.\${PBS_O_WORKDIR}\" > ~/qsub_task/job.\`date +\"%Y-%m-%d_%H-%M-%s%N\"\`

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr

"
para="s20000"
outdir="vcfs"
ref="ROC22_A"
prefix="ROC22"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq 1 10`; do 
	path="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/graphs/ROC22.Chr${i}_*${para}*"
	line=`ls ${path}/*vcf`
	id=$(basename $line)
	echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
	echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
	echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
	echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done


ref="nR570_A"
prefix="R570"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq 1 10`; do
        path="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/nR570/nR570*.Chr${i}_*${para}*"
        line=`ls ${path}/*vcf`
        id=$(basename $line)
        echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done

para="s10000"
ref="ZZ_ref"
prefix="ZZ"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq 1 10`; do
        path="/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/ZZ"
        line=`ls ${path}/*Chr${i}.*ZZ_ref.vcf`
        id=$(basename $line)
        echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done

para="s20000"
ref="NpX_A"
prefix="NpX"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq 1 10`; do
        path="../../growth/_NP-x/graphs_s20k//NpX.Chr${i}_*${para}*"
        line=`ls ${path}/*vcf`
        id=$(basename $line)
        echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done


ref="LAp_A"
prefix="LAp"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq -w 1 10`; do
        path="../../growth/_la/graphs_s20k//LAp.Chr${i}_*${para}*"
        line=`ls ${path}/*vcf`
        id=$(basename $line)
	echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done


ref="ZG_A"
prefix="ZG"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq -w 1 10`; do
        path="../../growth/_zg/graphs_s20k/ZG.Chr${i}_*${para}*"
        line=`ls ${path}/*vcf`
        id=$(basename $line)
        echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done




para="s5000"
ref="AP85_A"
prefix="AP85"

echo "$header" > run_parse_variants.${prefix}.sh
for i in `seq 1 8`; do
        path="../../growth/_ap85/graphs_s5k_p90/AP85.Chr${i}_*${para}*"
        line=`ls ${path}/*vcf`
        id=$(basename $line)
        echo -e "#bgzip -c $line > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz" >> run_parse_variants.${prefix}.sh
        echo -e "#vcfbub -d -l 0 -r 10000000 --input ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.vcf.gz > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "python3 parse_vcf.py ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf" >> run_parse_variants.${prefix}.sh
        echo -e "awk '{if(NR>1){if(\$4>=50){print \">\"\$1\"_\"\$2; print \$3}}}' ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.out > ${outdir}/${prefix}.${para}.Chr${i}.smooth.final.${ref}.filtered.vcf.longest.fasta" >> run_parse_variants.${prefix}.sh
done

