### graph-based

~/software/vg giraffe -t 36 -p -Z PGG1.0.combined.giraffe.gbz -m PGG1.0.combined.min -d PGG1.0.combined.dist -f fq2/Sample_102.trimmed_1.fq.gz -f fq2/Sample_102.trimmed_2.fq.gz > out/Sample_102.gam && ~/software/vg pack --threads 24 -x PGG1.0.combined.giraffe.gbz -g out/Sample_102.gam -o out/Sample_102.pack -Q 5 && ~/software/vg stats --threads 24 -a out/Sample_102.gam > out/Sample_102.stats && ~/software/vg surject -t 24 -x PGG1.0.combined.xg -b out/Sample_102.gam > out/Sample_102.bam && rm out/Sample_102.gam

~/software/vg call --threads 24 PGG1.0.combined.giraffe.gbz -r PGG1.0.combined.snarls -k out/Sample_100.pack -s Sample_100 -z -a | bgzip -@ 12 -c > out/Sample_100.vcf.gz

awk -F '\t' '{if(/^#/){print}else{split($10,a,":");if(a[2]>=8){print}}}' <(zcat Sample_100.vcf.gz) | bgzip -c -f -@ 20 > Sample_100.filtered.vcf.gz && bcftools index Sample_100.filtered.vcf.gz

bcftools merge --threads 60 -o all.combined.raw.sh.vcf.gz -O z ../out/*filtered.vcf.gz
bcftools index all.combined.raw.sh.vcf.gz
bcftools view -m2 -M2 --threads 48 -Oz -o all.combined.BI.sh.vcf.gz all.combined.raw.sh.vcf.gz
bcftools index all.combined.BI.sh.vcf.gz


vcftools --gzvcf all.combined.raw.sh.vcf.gz \
        --recode-INFO-all \
        --max-alleles 2 \
        --min-alleles 2 \
        --max-missing 0.8 \
        --out all.combined.Sh.biallelic.max-missing0.8 \
        --recode
       
awk '{if(/^#/){print}else{t1=0;t2=0;for(i=10;i<=NF;i++){split($i,a,":");if(a[3]!="."){split(a[3],b,",");t1+=(b[1]+b[2]);t2+=b[2]}};if(((t2/t1)>=0.05)&&((t2/t1)<=0.95)){print}}}' all.combined.Sh.biallelic.max-missing0.8.recode.vcf > all.combined.Sh.biallelic.max-missing0.8.maf0.05.vcf


### linear-based

bash sentieon_pipeline.sh samplesaa

qsub GVCFtyper.sh
