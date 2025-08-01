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

### 05. Simulate reads and map them to line genome and graph pangenome
for fq in *.chr.fa; do
    base=$(basename "$fq" .chr.fa)
	art_illumina  -ss HS25 -i ${fq} -p -l 150 -f 20 -m 400 -s 10 -na -o ${base}_20X && gzip ${base}_20X1.fq &&  gzip ${base}_20X2.fq
done

vg autoindex --threads 20 --workflow giraffe -r ZY10.fa -p cotton_pggb   -v  merged_rename.vcf.gz

for i in ./output/*X1.fq.gz; do
    base=$(basename "$fq1" X1.fq.gz)
    fq1_local="${base}X1.fq.gz"
    fq2_local="${base}X2.fq.gz"
    vg giraffe -t 10 -p -Z cotton_pggb.giraffe.gbz -m cotton_pggb.min -d cotton_pggb.dist -f ${fq1_local} -f ${fq2_local} 1>${base}.gam 2>${base}.log
done


bwa index ZY10.fa
input_dir=./pres/
output_dir=./
for fq1 in $input_dir/*X1.fq; do
    [ ! -f "$fq1" ] && continue
    base=$(basename "$fq1" X1.fq)
    fq2="${input_dir}/${base}X2.fq"
    fq1_path="${input_dir}/${base}X1.fq"
    sam_out="${output_dir}/${base}.bam"
    log_out="${output_dir}/${base}.log"
    bwa mem -t 40 ZY10.fa \"$fq1_path\" \"$fq2\" | samtools view -b > \"$sam_out\" 2> \"$log_out\"
done

### 06. Rna-seq analyse based on graph pangenome
vg autoindex --threads 24 --workflow mpmap --workflow rpvg --prefix catton  --ref-fasta ZY10.chr.fa  -v merged_rename.vcf.gz \
--tx-gff ZY10.chr.gene.gff3 -T ./ --gff-tx-tag Parent
GRAPH="catton.spliced.xg"
GCSA="catton.spliced.gcsa"
DIST_INDEX="catton.spliced.dist"
for r1 in ../fq/*.fastq.gz; do
        base=$(basename "$r1" .fastq.gz)
		echo "vg mpmap -t 10   -x ${GRAPH} -g ${GCSA} -d ${DIST_INDEX} -f $r1  1>${out_folder_graphs}/$base.gamp 2>$base.log "

hisat2-build -p 50 ZY10.chr.fa ZY
for r1 in ../fq/*.fastq.gz; do
		base=$(basename "$r1" .fastq.gz)
		hisat2 -p 50 -x ZY    --dta   -U $r1   | samtools sort -@ 10 -o  ${base}.bam
done
