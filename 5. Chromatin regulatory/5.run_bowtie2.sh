### Bowtie2 mapping

index="LAp_A.fasta"

echo "LAp-2-LF15, hap"
bowtie2 -p 40 --very-sensitive -X 1000 -x $index -1 ~/others/ZG/data/Fastp过滤后数据/Merge_data/LA-2-LF15_1.fq.gz -2 ~/others/ZG/data/Fastp过滤后数据/Merge_data/LA-2-LF15_2.fq.gz|samtools sort -@ 40 -T LA-2-LF1 -o ./bamoutput/LA-2-LF15.hap.bam 
/share/home/off_huangyumin/software/gatk-4.3.0.0/gatk MarkDuplicates -I ./bamoutput/LA-2-LF15.hap.bam -O ./bamoutput/LA-2-LF15.hap.MD.bam -M ./bamoutput/LA-2-LF15.hap.MD.metrics --REMOVE_DUPLICATES true --TMP_DIR bamoutput/ 


index="/share/home/off_huangyumin/reference/LA_purple/LAp_v20220608.genome.fasta"

echo "LAp-2-LF15, all"
bowtie2 -p 40 --very-sensitive -X 1000 -x $index -1 ~/others/ZG/data/Fastp过滤后数据/Merge_data/LA-2-LF15_1.fq.gz -2 ~/others/ZG/data/Fastp过滤后数据/Merge_data/LA-2-LF15_2.fq.gz|samtools sort -@ 40 -T LA-2-LF1 -o ./bamoutput/LA-2-LF15.all.bam 
/share/home/off_huangyumin/software/gatk-4.3.0.0/gatk MarkDuplicates -I ./bamoutput/LA-2-LF15.all.bam -O ./bamoutput/LA-2-LF15.all.MD.bam -M ./bamoutput/LA-2-LF15.all.MD.metrics --REMOVE_DUPLICATES true --TMP_DIR bamoutput/ 


### MACS2 calling

for i in SES LA;do
for j in 1 2;do
samtools view -@ 80 ${i}-${j}-LF15.hap.bam |fgrep "AS:" |fgrep -v "XS:" |cat <(samtools view -H ${i}-${j}-LF15.hap.bam) - |samtools view -@ 40 -bS - > ${i}-${j}-LF15.hap.uniq.bam
done
done

macs2 callpeak -f BAM -t SES-1-LF15.hap.uniq.bam --call-summits --SPMR -B -g $g --nomodel --shift -100 --extsize 200 --keep-dup all -q 0.01 -n SES_1 --outdir SES_1_0.01 1>/dev/null
macs2 callpeak -f BAM -t SES-2-LF15.hap.uniq.bam --call-summits --SPMR -B -g $g --nomodel --shift -100 --extsize 200 --keep-dup all -q 0.01 -n SES_2 --outdir SES_2_0.01 1>/dev/null

macs2 callpeak -f BAM -t LA-1-LF15.hap.uniq.bam --call-summits --SPMR -B -g $g --nomodel --shift -100 --extsize 200 --keep-dup all -q 0.01 -n LA_1 --outdir LA_1_0.01 1>/dev/null
macs2 callpeak -f BAM -t LA-2-LF15.hap.uniq.bam --call-summits --SPMR -B -g $g --nomodel --shift -100 --extsize 200 --keep-dup all -q 0.01 -n LA_2 --outdir LA_2_0.01 1>/dev/null
