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




### 06. Simulate reads and map them to line genome and graph pangenome
for fq in *.chr.fa; do
    base=$(basename "$fq" .chr.fa)
	art_illumina  -ss HS25 -i ${fq} -p -l 150 -f 20 -m 400 -s 10 -na -o ${base}_20X && gzip ${base}_20X1.fq &&  gzip ${base}_20X2.fq
done


vg autoindex --threads 40   -T tem --workflow giraffe -r  chinese_spring.fa   -p wheat   -v  merged.vcf.gz
input_dir=./fq/
output_dir=./
for fq1 in "$input_dir"/*X1.fq; do
    base=$(basename "$fq1" X1.fq)
    fq2="$input_dir/${base}X2.fq"
    fq1_local="${base}X1.fq"
    fq2_local="${base}X2.fq"

    vg giraffe -t 20 -p \
    -d wheat.dist \
    -m wheat.min \
    -Z wheat.giraffe.gbz \
    -f "$input_dir"/"$fq1_local" -f "$input_dir"/"$fq2_local" \
    > \"${base}.gam\" 2>${base}.log
done



input_dir=./pres/
output_dir=./
bwa index chinese_spring.fa
for fq1 in $input_dir/*X1.fq; do
    [ ! -f "$fq1" ] && continue
    base=$(basename "$fq1" X1.fq)
    fq2="${input_dir}/${base}X2.fq"
    fq1_path="${input_dir}/${base}X1.fq"
    sam_out="${output_dir}/${base}.bam"
    log_out="${output_dir}/${base}.log"
    echo "bwa mem -t 40 chinese_spring.fa  \"$fq1_path\" \"$fq2\" | samtools view -b > \"$sam_out\" 2> \"$log_out\""
done

### 07. Rna-seq analyse based on graph pangenome
vg autoindex --threads 24 --workflow mpmap --workflow rpvg --prefix wheat \
--ref-fasta chinese_spring.fa   -v merged.vcf.gz  \
--tx-gff merge.renamed.gff  -T ./ --gff-tx-tag Parent

GRAPH="wheat.spliced.xg"
GCSA="wheat.spliced.gcsa"
DIST_INDEX="wheat.spliced.dist"
for r1 in ../fq/*.fastq.gz; do
        base=$(basename "$r1" .fastq.gz)
		echo "vg mpmap -t 10   -x ${GRAPH} -g ${GCSA} -d ${DIST_INDEX} -f $r1  1>${out_folder_graphs}/$base.gamp 2>$base.log "

hisat2-build -p 50 chinese_spring.fa chinese_spring
for r1 in ../fq/*.fastq.gz; do
		base=$(basename "$r1" .fastq.gz)
		hisat2 -p 50 -x chinese_spring    --dta   -U $r1   | samtools sort -@ 10 -o  ${base}.bam
done
