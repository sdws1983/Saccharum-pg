# 0. snarls

~/software/vg snarls --threads 24 Srufi.combined.giraffe.gbz > Srufi.combined.snarls

# 1. giraffe

~/software/vg giraffe -t 40 -p -Z Srufi.v20210930.giraffe.gbz -m Srufi.v20210930.min -d Srufi.v20210930.dist -f data/AH1803_1.fq.gz -f data/AH1803_2.fq.gz | ~/software/vg pack --threads 24 -x Srufi.v20210930.giraffe.gbz -g - -o AH1803.pack -Q 5

# 2. call

~/software/vg call --threads 24 Srufi.v20210930.giraffe.gbz -r Srufi.v20210930.snarls -k AH1803.pack -s AH1803 -z -a > AH1803.vcf

# 3. filter read depth
### Er: 6, Ss/So/Srob: 16, Sh: 20

for i in `ls *vcf`;do
	awk -F '\t' '{if(/^#/){print}else{split($10,a,":");if(a[2]>=20){print}}}' $i | bgzip -c -f -@ 20 > ${i}.gz
	bcftools index ${i}.gz
done

# 4. combine

bcftools merge --threads 60 -o all.combined.raw.vcf.gz -O z sr/*vcf.gz ss/*vcf.gz srob/*vcf.gz so/*vcf.gz sh/*vcf.gz

vcftools --gzvcf all.combined.raw.vcf.gz \
        --recode-INFO-all \
        --max-alleles 2 \
        --min-alleles 2 \
        --max-missing 0.6 \
		--stdout \
        --recode \
        --remove-indels | awk '{if(/^#/){print}else{t1=0;t2=0;for(i=10;i<=NF;i++){split($i,a,":");if(a[3]!="."){split(a[3],b,",");t1+=(b[1]+b[2]);t2+=b[2]}};if(((t2/t1)>=0.05)&&((t2/t1)<=0.95)){print}}}' | bgzip -@ 24 -c > all.combined.SNP.biallelic.max-missing0.6.maf0.05.recode.vcf.gz


