#!/bin/sh
# *******************************************
# Script to perform DNA seq variant calling
# using a single sample with fastq files
# named 1.fastq.gz and 2.fastq.gz
# *******************************************

# Update with the fullpath location of your sample fastq
set -x
data_dir="$( cd -P "$( dirname "$0" )" && pwd )"
# fastq_1=$data_dir/1.fastq.gz
# fastq_2=$data_dir/2.fastq.gz #If using Illumina paired data
fastq_folder="/share3/data_zhangjisen/Person/zhangyixing/Arabidopsis_thaliana/sugarcane_pangenome/HuangYuMin/potato_population/sra/" ###需要手动修改
fastq_1_suffix="trimmed_1.fq.gz" ###需要手动修改
fastq_2_suffix="trimmed_2.fq.gz" ###需要手动修改
platform="ILLUMINA"

# Update with the location of the reference data files
#fasta=/public2/home/off_huangyumin/reference/sorghum/Sorghum_bicolor.Sorghum_bicolor_NCBIv3.dna.toplevel.fa ###需要手动修改
fasta=/public2/home/off_huangyumin/reference/Potato/WhR/WhR.1.fa ###需要手动修改
# dbsnp=$data_dir/reference/dbsnp_135.hg19_chr22.vcf
# known_1000G_indels=$data_dir/reference/1000G_phase1.snps.high_confidence.hg19_chr22.sites.vcf
# known_Mills_indels=$data_dir/reference/Mills_and_1000G_gold_standard.indels.hg19_chr22.sites.vcf

# Set SENTIEON_LICENSE if it is not set in the environment
SENTIEON_LICENSE=""
export SENTIEON_LICENSE="${SENTIEON_LICENSE}"

#export SENTIEON_LICENSE=172.25.58.47:8990

# Update with the location of the Sentieon software package
SENTIEON_INSTALL_DIR=/share1/biosoft/sentieon-genomics-202503

# Update with the location of temporary fast storage and uncomment
#SENTIEON_TMPDIR=/tmp

# It is important to assign meaningful names in actual cases.
# It is particularly important to assign different read group names.

platform="ILLUMINA" 

# Other settings
nt=10 #number of threads to use in computation

# ******************************************
# 0. Setup
# ******************************************
workdir=$data_dir/result
#mkdir -p $workdir
logfile=$workdir/run.log.$1
exec >$logfile 2>&1
cd $workdir

#Sentieon proprietary compression
#bam_option="--bam_compression 1"

# ******************************************
# 0. Process all samples independently
# ******************************************
#update with the prefix of the fastq files

while IFS=',' read -r id sample;do

#for sample in BDES192031291-1a_L1; do ###需要手动修改
  group=$sample
  mkdir $workdir/$sample
  cd $workdir/$sample

# ******************************************
# 1. Mapping reads with BWA-MEM, sorting
# ******************************************
#The results of this call are dependent on the number of threads used. To have number of threads independent results, add chunk size option -K 10000000 

# speed up memory allocation malloc in bwa
#export LD_PRELOAD=/usr/lib64/libjemalloc.so.2
export LD_PRELOAD=/public2/home/off_huangyumin/miniconda3/lib/libjemalloc.so.2

( $SENTIEON_INSTALL_DIR/bin/sentieon bwa mem -t 20 -M -R "@RG\tID:$group\tSM:$sample\tPL:$platform" -t $nt -K 10000000 $fasta $fastq_folder/${id}.$fastq_1_suffix $fastq_folder/${id}.$fastq_2_suffix || echo -n 'error' ) | samtools view -h -q 20 |  $SENTIEON_INSTALL_DIR/bin/sentieon util sort -r $fasta -o sorted.bam -t $nt --sam2bam -i - #$bam_option

# ******************************************
# 2. Metrics
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i sorted.bam --algo MeanQualityByCycle mq_metrics.txt --algo QualDistribution qd_metrics.txt --algo GCBias --summary gc_summary.txt gc_metrics.txt --algo AlignmentStat --adapter_seq '' aln_metrics.txt --algo InsertSizeMetricAlgo is_metrics.txt

$SENTIEON_INSTALL_DIR/bin/sentieon plot GCBias -o gc-report.pdf gc_metrics.txt
$SENTIEON_INSTALL_DIR/bin/sentieon plot QualDistribution -o qd-report.pdf qd_metrics.txt
$SENTIEON_INSTALL_DIR/bin/sentieon plot MeanQualityByCycle -o mq-report.pdf mq_metrics.txt
$SENTIEON_INSTALL_DIR/bin/sentieon plot InsertSizeMetricAlgo -o is-report.pdf is_metrics.txt

# ******************************************
# 3. Remove Duplicate Reads
# To mark duplicate reads only without removing them, remove "--rmdup" in the second command
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i sorted.bam --algo LocusCollector --fun score_info score.txt
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i sorted.bam --algo Dedup --rmdup --score_info score.txt --metrics dedup_metrics.txt deduped.bam #$bam_option

# ******************************************
# 4. Indel realigner
# This step is optional for haplotyper-based
# caller like HC, but necessary for any
# pile-up based caller. If you want to use
# this step, you need to update the rest of
# the commands to use realigned.bam instead
# of deduped.bam
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam --algo Realigner realigned.bam

# ******************************************
# 5. Base recalibration
# ******************************************

# Perform recalibration
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i realigned.bam --algo QualCal recal_data.table

# Perform post-calibration check (optional)
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i realigned.bam -q recal_data.table --algo QualCal recal_data.table.post
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt --algo QualCal --plot --before recal_data.table --after recal_data.table.post recal.csv   
#$SENTIEON_INSTALL_DIR/bin/sentieon plot QualCal -o recal_plots.pdf recal.csv

# ******************************************
# 5b. ReadWriter to output recalibrated bam
# This stage is optional as variant callers
# can perform the recalibration on the fly
# using the before recalibration bam plus
# the recalibration table
# ******************************************
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam -q recal_data.table --algo ReadWriter recaled.bam


# ******************************************
# 6. HC Variant caller
# Note: Sentieon default setting matches versions before GATK 3.7.
# Starting GATK v3.7, the default settings have been updated multiple times. 
# Below shows commands to match GATK v3.7 - 4.1
# Please change according to your desired behavior.
# ******************************************

# Matching GATK 3.7, 3.8, 4.0
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i realigned.bam -q recal_data.table --algo Haplotyper --ploidy 4 --emit_conf=10 --call_conf=30 --emit_mode gvcf output-hc.vcf.gz

# Matching GATK 4.1
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam -q recal_data.table --algo Haplotyper -d $dbsnp --genotype_model multinomial --emit_conf 30 --call_conf 30 output-hc.vcf.gz

done < "$1"
