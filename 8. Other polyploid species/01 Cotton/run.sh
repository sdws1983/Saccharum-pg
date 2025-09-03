### 01. Estimate genetic distance by mash

for i in merge_haplotype*gz; do mash triangle ${i} > ${i}_mash_triangle.txt;done

### 02. Constract graph pangenome by PGGB
#!/bin/bash
out_folder_graphs=/public1/home/stu_zhangyixing/workspace/pangenome/high_cotton/build_pangenome/
# PGGB 参数配置
t=10
POA=asm20
O=0.03
p=94
s=10000
k=47
G=13033,13177
ref=ZY10
# 输入目录（当前路径）
f=.
header="#!/bin/bash -x
#PBS -q comput
#PBS -j oe
#PBS -l nodes=1:ppn=10

cd \$PBS_O_WORKDIR
source activate pggb
"
for fq in ./input_data/merged.35hap.*.fa.gz; do
    base=$(basename "$fq" .fa.gz)

    if [ ! -f ${fq}.fai ]; then
        samtools faidx $fq
    fi

    n=$(wc -l < ${fq}.fai)
    l=$(echo "$s * 5" | bc)

    out=${base}_p${p}.s${s}.l${l}.n${n}.k${k}.POA${POA}.O${O}.G$(echo $G | tr ',' '-').$ref
    script=run_pggb.${out}.sh

    echo "$header" > $script
    #echo "pggb -i $fq -p $p -s $s -l $l -n $n -k $k -P $POA -O $O -G $G -t $t -V ${ref}:# -o ${out_folder_graphs}/${out} -m" >> $script
	echo "pggb -i $fq -p $p -s $s -l $l -n $n  -t $t -V ${ref}:# -o ${out_folder_graphs}/${out} -m" >> $script
done
for i in run_pggb*.sh; do qsub ${i};done


### 03. Count PAV by odgi

bedtools makewindows -g  <(cut -f 1,2 ZY10.chr.fa.fai) -w 50000 > pav_50000bin.bed
odgi pav -t 40 -P -i merge.og  -b  pav.bed  > catton.pavs.tsv

### 04. Pangenome growth curve

grep -e '^W' combine.Walk.gfa | cut -f2-6 | awk '{ print $1 "#" $2 "#" $3 ":" $4 "-" $5 }' > paths.txt
grep -ve 'ZY10' paths.txt > paths.haplotypes.txt
for i in node edge bp;do
RUST_LOG=info ./panacus histgrowth -t10 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -a  -c $i -s  paths.haplotypes.txt  combine.WW.gfa > pggb.histgrowth.${i}.tsv
./panacus-visualize.py pggb.histgrowth.${i}.tsv > pggb.histgrowth.${i}.pdf
done


### 05. Rna-seq analyse based on graph pangenome
# romove complex variants
bcftools view -i 'strlen(REF)<1000 && strlen(ALT)<1000'  merged_rename.vcf.gz    -o merged_rename.filtered.vcf
bgzip -@ 10 merged_rename.filtered.vcf
vg autoindex --threads 24 --workflow mpmap --workflow rpvg --prefix catton  --ref-fasta ZY10.chr.fa  -v merged_rename.filtered.vcf.gz \
--tx-gff ZY10.chr.gene.gff3 -T ./ --gff-tx-tag Parent
GRAPH="../cotton.spliced.xg"
GCSA="../cotton.spliced.gcsa"
DIST_INDEX="../cotton.spliced.dist"
for r1 in ../fq/*_1.fastq.gz; do
	base=$(basename ${r1}  _1.fastq.gz)
    r2="${r1/_1.fastq.gz/_2.fastq.gz}"
	echo "vg mpmap -t 20  -x ${GRAPH} -g ${GCSA} -d ${DIST_INDEX} -f $r1 -f $r2 1>$base.gamp 2>$base.log"

for r1 in ../fq/*_1.fastq.gz; do
	base=$(basename ${r1}  _1.fastq.gz)
	r2="${r1/_1.fastq.gz/_2.fastq.gz}"
		echo "hisat2 -p 50 -x ROC22.V0917    --dta   -1 $r1 -2 $r2   | samtools sort -@ 10 -o  ${base}.bam "
done

