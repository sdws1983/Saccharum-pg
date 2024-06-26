#!/bin/bash

dir="fasta"

fa="/share/home/off_huangyumin/reference/R570/assembly/SofficinarumxspontaneumR570_771_v2.0.chr.primarary.fa"
prefix="nR570"

echo $prefix

bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{{gsub("-","_"); print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/ZZ/GWHEQVP00000000.genome.chr.renamed.fasta"
prefix="ZZ"

echo $prefix

bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{{gsub("-","_"); print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/Np-X/Np-X.3ddna.Chr.v20210804.Chr.fa"
prefix="NpX"

echo $prefix

bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(!/^Contig/){print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#Chr"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/AP85/Sspon.HiC_chr_asm.fasta"
prefix="AP85"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/LA_purple/LAp_v20220608.genome.fasta"
prefix="LAp"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz



fa="/share/home/off_huangyumin/reference/zhongguo/ZG.v20211208.genome.fasta"
prefix="ZG"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/ROC22/ROC22.V0917.geno.fasta"
prefix="ROC22"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""_"substr($1,length($1),length($1)+1)"#1#"substr($1,0,length($1)-1); print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/Srufi/Srufi.v20210930.chr.fasta"
prefix="Srufi"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""#1#"$1; print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz


fa="/share/home/off_huangyumin/reference/Efulvus/Erufi_final_genome.chr.fasta"
prefix="Srufi2"
echo $prefix
bioawk -c fastx '{{print $name"\t"$seq}}' $fa |awk '{if(/^Chr/){print ">""'$prefix'""#1#"$1; print $2}}' > ${dir}/${prefix}.renamed.fasta
bgzip -@ 4 ${dir}/${prefix}.renamed.fasta
samtools faidx ${dir}/${prefix}.renamed.fasta.gz






