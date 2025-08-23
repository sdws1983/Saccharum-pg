# construct SES pangenome  &&  build index 
minigraph -cxggs -l50k AA.fa  BB.fa  CC.fa  DD.fa -t 40 > out.gfa
methylGrapher PrepareGenome -gfa out.gfa  -prefix index_methy -t 30

# calculate the methylation level
source ~/../stu_zhangyixing/.bash_profile
work_dir="./mature_leaf"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
$methylGrapher Align -t 50 -fq1 ./SES_merge_WGBS_data/SES-m-L.R1.fastq.gz  -fq2 ./SES_merge_WGBS_data/SES-m-L.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

source ~/../stu_zhangyixing/.bash_profile
work_dir="./mature_stem"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
$methylGrapher Align -t 50 -fq1  ./SES_merge_WGBS_data/SES-m-S.R1.fastq.gz  -fq2 ./SES_merge_WGBS_data/SES-m-S.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

source ~/../stu_zhangyixing/.bash_profile
work_dir="./prem_leaf"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
#$methylGrapher Align -t 50 -fq1  ./SES_merge_WGBS_data/SES-prem-L.R1.fastq.gz  -fq2 ./SES_merge_WGBS_data/SES-prem-L.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

source ~/../stu_zhangyixing/.bash_profile
work_dir="./prem_stem"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
#$methylGrapher Align -t 70 -fq1  ./SES_merge_WGBS_data/SES-prem-S.R1.fastq.gz  -fq2 ./SES_merge_WGBS_data/SES-prem-S.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 70 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

# construct ZG pangenome  &&  build index
minigraph -cxggs -l50k A.fa  B.fa  C.fa  D.fa  E.fa  F.fa  G.fa  H.fa  -t 40 > out.gfa
methylGrapher PrepareGenome -gfa out.gfa  -prefix index_methy -t 30

# calculate the methylation level
work_dir="./mature_leaf"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
$methylGrapher Align -t 50 -fq1 ./B48_ZG_merge_WGBS_data/B48-m-L.R1.fastq.gz  -fq2 ./B48_ZG_merge_WGBS_data/B48-m-L.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

export PATH=/public1/home/stu_zhangyixing/mminiconda3/bin/:$PATH
work_dir="./mature_stem"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
#$methylGrapher Align -t 40 -fq1  ./B48_ZG_merge_WGBS_data/B48-m-S.R1.fastq.gz  -fq2 ./B48_ZG_merge_WGBS_data/B48-m-S.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

export PATH=/public1/home/stu_zhangyixing/mminiconda3/bin/:$PATH
work_dir="./prem_leaf"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
#$methylGrapher Align -t 40 -fq1  ./B48_ZG_merge_WGBS_data/B48-prem-L.R1.fastq.gz  -fq2 ./B48_ZG_merge_WGBS_data/B48-prem-L.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

export PATH=/public1/home/stu_zhangyixing/mminiconda3/bin/:$PATH
work_dir="./prem_stem"
genome_prefix="index_methy"
methylGrapher="methylGrapher"
# 2. Alignment
#$methylGrapher Align -t 70 -fq1  ./B48_ZG_merge_WGBS_data/B48-prem-S.R1.fastq.gz  -fq2 ./B48_ZG_merge_WGBS_data/B48-prem-S.R2.fastq.gz  -index_prefix $genome_prefix -work_dir $work_dir -directional Y
# 3. Methylation Extraction
# -minimum_mapq should be used for real data
$methylGrapher MethylCall -t 50 -index_prefix $genome_prefix -work_dir $work_dir -cg_only N  -genotyping_cytosine Y # -minimum_mapq 10
# 4. Merge CpG
$methylGrapher MergeCpG -index_prefix $genome_prefix -work_dir $work_dir

# stats
for bam in *gaf; do
    out="${bam%.gaf}.level"
    cut -f 12 "$bam" | sort -n | uniq -c > "$out"
for file in *methyl; do
    out="${file%.methyl}"
	cut -f 6 ${file} | sort | uniq -c > ${out}.converage
	cut -f 8 ${file} | sort | uniq -c > ${out}.density
    awk '{c=$6;ctx=$4;if(c>5)gt[ctx]++;else if(c<=5)lt[ctx]++}END{for(k in gt)print k"\t"gt[k]"\t"lt[k]}' ${file} > ${out}.per_methy

done

