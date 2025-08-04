# genotying the graph

### 0. xg and snarls

~/software/vg convert -x SGG1.0.combined.giraffe.gbz > SGG1.0.combined.xg
~/software/vg snarls --threads 24 SGG1.0.combined.giraffe.gbz > SGG1.0.combined.snarls

### 1. giraffe

~/software/vg giraffe -t 40 -p -Z SGG1.0.combined.giraffe.gbz -m SGG1.0.combined.min -d SGG1.0.combined.dist -f data/AH1803_1.fq.gz -f data/AH1803_2.fq.gz > out/AH1803.gam
~/software/vg pack --threads 24 -x SGG1.0.combined.giraffe.gbz -g out/AH1803.gam -o AH1803.pack -Q 5
~/software/vg stats --threads 24 -a out/AH1803.gam > out/AH1803.stats

### 2. surject

~/software/vg surject -t 24 -x SGG1.0.combined.xg -b out/AH1803.gam > out/AH1803.bam
samtools sort -O BAM -@ 26 -o AH1803.sorted.bam AH1803.bam && samtools index -@ 24 AH1803.sorted.bam && rm AH1803.bam

### 3. genotyping

~/software/vg call --threads 24 SGG1.0.combined.giraffe.gbz -r SGG1.0.combined.snarls -k AH1803.pack -s AH1803 -z -a > AH1803.vcf

### 4. filter read depth
### Er: 6, Ss/So/Srob: 16, Sh: 20

for i in `ls *vcf`;do
	awk -F '\t' '{if(/^#/){print}else{split($10,a,":");if(a[2]>=20){print}}}' $i | bgzip -c -f -@ 20 > ${i}.gz
	bcftools index ${i}.gz
done

### 5. combine

bcftools merge --threads 60 -o all.combined.raw.vcf.gz -O z sr/*vcf.gz ss/*vcf.gz srob/*vcf.gz so/*vcf.gz sh/*vcf.gz

vcftools --gzvcf all.combined.raw.vcf.gz \
        --recode-INFO-all \
        --max-alleles 2 \
        --min-alleles 2 \
        --max-missing 0.6 \
	--stdout \
        --recode \
        --remove-indels | awk '{if(/^#/){print}else{t1=0;t2=0;for(i=10;i<=NF;i++){split($i,a,":");if(a[3]!="."){split(a[3],b,",");t1+=(b[1]+b[2]);t2+=b[2]}};if(((t2/t1)>=0.05)&&((t2/t1)<=0.95)){print}}}' | bgzip -@ 24 -c > all.combined.SNP.biallelic.max-missing0.6.maf0.05.recode.vcf.gz



# de novo variant calling

freebayes-parallel Srufi.w100k.bed 48 -f ~/reference/Erufi/Srufi.v20210930.chr.fasta --use-best-n-alleles 4 -p 10 -g 1000 bams/AH1803.sorted.bam | bgzip -@ 12 -c > mvcfs/AH1803.vcf.gz

