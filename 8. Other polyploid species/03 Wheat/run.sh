### 01. Estimate genetic distance by mash

for i in merge_haplotype*gz; do mash triangle ${i} > ${i}_mash_triangle.txt;done

### 02. Constract graph pangenome by PGGB

#!/bin/bash
out_folder_graphs=/share3/data_zhangjisen/Person/zhangyixing/Arabidopsis_thaliana/sugarcane_pangenome/high_wheat/build_pangenome
t=40
POA=asm20
O=0.03
p=95
s=50000
k=47
G=13033,13177
ref=ChineseSpring
f=.

header="#!/bin/bash -x
#PBS -q comput
#PBS -j oe
#PBS -l nodes=1:ppn=40,mem=400G

cd \$PBS_O_WORKDIR
export PATH=/public1/home/stu_zhangyixing/mminiconda3/envs/pggb/bin/:$PATH
"


for fq in ./input_data/merged.18hap.*.fa.gz; do
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

bedtools makewindows -g  <(cut -f 1,2 *fai ) -w 500000 > pav_500000bin.bed
og_files=( *og )
bed_file="pav_500000bin.bed"
for og in "${og_files[@]}"; do
    chr=$(echo "$og" | grep -oE 'Chr[0-9]+[ABD]' | sed 's/Chr//')
    chr_bed="tmp_${chr}.bed"
    grep "$chr" "$bed_file" > "$chr_bed"
    out_file="pav_${chr}_50000bin.pavs.tsv"
    odgi pav -t 5 -P -i \"$og\" -b \"$chr_bed\" > \"$out_file\"
done

### 04. Pangenome growth curve

grep -e '^W'  combine.W.gfa  | cut -f2-6 | awk '{ print $1 "#" $2 "#" $3 ":" $4 "-" $5 }' > paths.txt
grep -ve 'ChineseSpring' paths.txt > paths.haplotypes.txt
for i in node edge bp;do
RUST_LOG=info ./panacus histgrowth -t10 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -a  -c $i -s  paths.haplotypes.txt  combine.W.gfa > pggb.histgrowth.${i}.tsv
./panacus-visualize.py pggb.histgrowth.${i}.tsv > pggb.histgrowth.${i}.pdf
done


### 05. Here, the length of the chromosome is greater than 500 MB, so we split the chromosome and renamed it.

REF=Taestivumcv_ChineseSpring.fa
VCF=merged_rename.vcf.gz
OUT_DIR=split_dir
mkdir -p $OUT_DIR

cut -f1,2 ${REF}.fai | while read chr len; do
mid=$((len / 2))

samtools faidx $REF ${chr}:1-${mid} > $OUT_DIR/${chr}_part1.fa
samtools faidx $REF ${chr}:$((mid+1))-${len} > $OUT_DIR/${chr}_part2.fa
# deal with vcf file
bcftools view -r ${chr}:1-${mid} $VCF | \
awk -v newchr="${chr}_part1" 'BEGIN{OFS="\t"} /^#/ {print; next} {$1=newchr; print}'  > $OUT_DIR/${chr}_part1.vcf
# deal with fasta file
bcftools view -r ${chr}:$((mid+1))-${len} $VCF | \
awk -v newchr="${chr}_part2" -v offset="$mid" 'BEGIN{OFS="\t"} /^#/ {print; next} {$1=newchr; $2=$2 - offset; print}' > $OUT_DIR/${chr}_part2.vcf
done
# remove large SV
for i in *vcf;do echo "awk 'length($4)<=50000 && length($5)<=50000' ${i} >${i}.filter.vcf";done

Next, We renamed fasta and vcf

for fasta in Chr*_part*.fa; do
  base=$(basename "$fasta" .fa)
  chr=$(echo "$base" | sed -E 's/^Chr([0-9]+)([ABD])_part([12])$/\1/')
  group=$(echo "$base" | sed -E 's/^Chr([0-9]+)([ABD])_part([12])$/\2/')
  part=$(echo "$base" | sed -E 's/^Chr([0-9]+)([ABD])_part([12])$/\3/')
  oldid="Chr${chr}${group}"
  newid="chr$(printf '%02d' "$chr")${group}${part}"


  vcf="${base}.vcf.filter.vcf"
  if [[ -f "$vcf" ]]; then
    echo "$oldid ===>$newid"
    cat "$vcf" | \
      awk -v old="$oldid" -v new="$newid" 'BEGIN{OFS="\t"} /^#/ {print; next} {$1=new; print}' | \
      bgzip -c -@ 10 > "${base}_renamed.vcf.gz"
  fi
done

for vcf in *_renamed.vcf.gz; do   bcftools reheader --fai chineses.fa.fai -o "${vcf%.vcf.gz}_rehead.vcf.gz" "$vcf"; done

# split gff file
FAI="Taestivumcv_ChineseSpring.fa.fai"
GFF="Taestivumcv_ChineseSpring_725_v2.1.gene.gff3"
OUT_DIR="split_gff_dir"
mkdir -p "$OUT_DIR"

while read chr len _; do
  mid=$((len / 2))

  awk -v chr="$chr" -v mid="$mid" -v outchr="${chr}_part1" \
    '$0 ~ "^#" {print; next} 
     $1 == chr && $4 <= mid { $1=outchr; print }' OFS="\t" "$GFF" \
    > "$OUT_DIR/${chr}_part1.gff"

  awk -v chr="$chr" -v mid="$mid" -v outchr="${chr}_part2" \
    '$0 ~ "^#" {print; next} 
     $1 == chr && $4 > mid { $1=outchr; $4=$4-mid; $5=$5-mid; print }' OFS="\t" "$GFF" \
    > "$OUT_DIR/${chr}_part2.gff"

done < "$FAI"
sed -i  's/_part//g' Chr*.gff

### 06. Rna-seq analyse based on graph pangenome
# remove the lengthy variances and variances outside the gene area
awk '$3 == "gene" {print $1"\t"$4-1"\t"$5}' merge.renamed.gff   | bedtools sort > genes.bed
bedtools slop -b 50000 -i genes.bed -g chineses.fa.fai  > genes_expanded.bed
bcftools view   -i 'strlen(REF)<=200 && strlen(ALT)<=200 && REF!="N" && ALT!="N" && REF!~"N" && ALT!~"N"' merged.vcf.gz -Oz -o merged.filted.vcf.gz
bcftools view -R genes_expanded.bed merged.filted.vcf.gz -Oz -o merged.filted.gene_nearby_50000.vcf.gz

# enlarge gcsa-size-limit parameter
vg autoindex --threads 24 --workflow mpmap --workflow rpvg --prefix wheat_50000 \
--gcsa-size-limit 20000000000000 \
--ref-fasta ../chineses.fa   -v ../merged.filted.gene_nearby_50000.vcf.gz  \
--tx-gff ../merge.renamed.gff  -T ./ --gff-tx-tag Parent -f CDS


GRAPH="wheat_50000.spliced.xg"
GCSA="wheat_50000.spliced.gcsa"
DIST_INDEX="wheat_50000.spliced.dist"
out_folder_graphs=./
for r1 in ../../fq/*_1.fastq.gz; do
    r2="${r1/_1.fastq.gz/_2.fastq.gz}"
    if [ -f "$r2" ]; then
        base=$(basename "$r1" _1.fastq.gz)
		echo "vg mpmap -t 20  -x ${GRAPH} -g ${GCSA} -d ${DIST_INDEX} -f $r1 -f $r2 1>${out_folder_graphs}/$base.gamp 2>$base.log"
    else
        echo "Missing pair for: $r1"
    fi
done


hisat2-build -p 50 chinese_spring.fa chinese_spring
for r1 in ../fq/*1.fastq.gz; do
    r2="${r1/1.fastq.gz/2.fastq.gz}"
        base=$(basename "$r1" 1.fastq.gz)
		echo "hisat2 -p 50 -x chineses   --dta   -1 $r1 -2 $r2   | samtools sort -@ 10 -o  ${base}.bam "
done

