# build index for genome
bismark_genome_preparation  --bowtie2  --parallel 5   --verbose ./genome/
# mapping 
bismark --bowtie2  --bam -p 40 -o mature_leaf  ./genome/  -1 ./SES_merge_WGBS_data/SES-m-L.R1.fastq.gz  -2 ./SES_merge_WGBS_data/SES-m-L.R2.fastq.gz  
bismark --bowtie2  --bam -p 40 -o mature_stem  ./genome/  -1 ./SES_merge_WGBS_data/SES-m-S.R1.fastq.gz  -2 ./SES_merge_WGBS_data/SES-m-S.R2.fastq.gz 
bismark --bowtie2  --bam -p 40 -o prem_leaf  ./genome/  -1 ./SES_merge_WGBS_data/SES-prem-L.R1.fastq.gz   -2 ./SES_merge_WGBS_data/SES-prem-L.R2.fastq.gz
bismark --bowtie2  --bam -p 40 -o prem_stem  ./genome/  -1 ./SES_merge_WGBS_data/SES-prem-S.R1.fastq.gz  -2 ./SES_merge_WGBS_data/SES-prem-S.R2.fastq.gz
# 
samtools sort -@ 50  SES-m-L.R1_bismark_bt2_pe.bam -o SES-m-L.R1_bismark_bt2_pe.sort.bam
samtools sort -@ 50  SES-m-S.R1_bismark_bt2_pe.bam -o SES-m-S.R1_bismark_bt2_pe.sort.bam
samtools sort -@ 50  SES-prem-L.R1_bismark_bt2_pe.bam -o SES-prem-L.R1_bismark_bt2_pe.sort.bam
samtools sort -@ 50  SES-prem-S.R1_bismark_bt2_pe.bam   -o SES-prem-S.R1_bismark_bt2_pe.sort.bam
# calculate the methylation level
samp=mature_leaf
BatMeth2 calmeth -Q 20 --remove_dup --coverage 4 -nC 1 \
    --Regions 600 --step 50000 \
    --genome ../genome/Sspon.HiC_chr_asm.fasta \
    --binput SES-m-L.R1_bismark_bt2_pe.sort.bam \
    --methratio $samp > ${samp}.log

samp=mature_stem
BatMeth2 calmeth -Q 20 --remove_dup --coverage 4 -nC 1 \
    --Regions 600 --step 50000 \
    --genome ../genome/Sspon.HiC_chr_asm.fasta \
    --binput SES-m-S.R1_bismark_bt2_pe.sort.bam \
    --methratio $samp > ${samp}.log

samp=prem_leaf
BatMeth2 calmeth -Q 20 --remove_dup --coverage 4 -nC 1 \
    --Regions 600 --step 50000 \
    --genome ../genome/Sspon.HiC_chr_asm.fasta \
    --binput SES-prem-L.R1_bismark_bt2_pe.sort.bam  \
    --methratio $samp > ${samp}.log

samp=prem_stem
BatMeth2 calmeth -Q 20 --remove_dup --coverage 4 -nC 1 \
    --Regions 600 --step 50000 \
    --genome ../genome/Sspon.HiC_chr_asm.fasta \
    --binput SES-prem-S.R1_bismark_bt2_pe.sort.bam \
    --methratio $samp > ${samp}.log

# detail information
for file in *methratio.txt; do
    out="${file%.methratio.txt}"
	cut -f 5 ${file} | sort | uniq -c > ${out}.converage
	cut -f 7 ${file} | sort | uniq -c > ${out}.density
    awk 'NR>1{c=$5;ctx=$4;if(c>5)gt[ctx]++;else if(c<=5)lt[ctx]++}END{for(k in gt)print k"\t"gt[k]"\t"lt[k]}' ${file} > ${out}.per_methy
done
for bam in *sort.bam; do
    out="${bam%.bam}.level"
    samtools view  "$bam" | cut -f 5 | sort -n | uniq -c > "$out"
done

