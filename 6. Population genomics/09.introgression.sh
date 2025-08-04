### prepare genotypes

bcftools merge --threads 60 -o all.combined.ss-so-sh.raw.vcf.gz -O z ss/*vcf.gz so/*vcf.gz sh/*vcf.gz

vcftools --gzvcf all.combined.ss-so-sh.raw.vcf.gz \
        --recode-INFO-all \
        --max-alleles 2 \
        --min-alleles 2 \
        --max-missing 0.5 \
        --out all.combined.ss-so-sh.max-missing0.5.BI.SNP \
        --recode \
        --remove-indels

awk '{if(/^#/){print}else{t1=0;t2=0;for(i=10;i<=NF;i++){split($i,a,":");if(a[3]!="."){split(a[3],b,",");t1+=(b[1]+b[2]);t2+=b[2]}};if(((t2/t1)>=0.05)&&((t2/t1)<=0.95)){print}}}' all.combined.ss-so-sh.max-missing0.5.BI.SNP.recode.vcf | bgzip -@ 24 -c > all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.recode.vcf.gz


### calculate allele frequency for each species

for i in Ss So Sh;do 
bcftools view --threads 12 -S ${i}.line all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.recode.vcf.gz | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%DP\t[%AD\t]\n' | \
awk '
BEGIN { OFS="\t" }
{
    missing = 0;
    dosage = 0;
    ac = 0;
    ac2 = 0;
    total = NF - 5;       # 总样本数 = 总字段数减去前两列（CHROM, POS）
    if($4 ~ /,/){
    for(i = 6; i <= NF; i++){
        if($i ~ /\./) missing++;    
        af = "NA";
        ac = "NA";
        LEN = "NA";
    }
    }else{
    LEN = max = (length($3) > length($4)) ? length($3) : length($4);
    for(i = 6; i <= NF; i++){
        if($i ~ /\./){missing++}else{split($i,a,","); ac2+=a[1]; ac+=a[2]; dosage+=(a[2]/(a[1]+a[2]))};
    }
    }
    miss_rate = (total>0 ? missing/total : 0);
    af = (ac != "NA" ? dosage/(total-missing) : "NA");
    print $1, $2, $3, $4, $5, LEN, missing, total, miss_rate, ac/(ac+ac2), af;
}
' | bgzip -@ 24 -c > all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.${i}.stats.gz 
done


### combine and calculate windowed Dxy

paste <(zcat all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.Ss.stats.gz | cut -f1,2,3,4,11) \
        <(zcat all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.So.stats.gz | cut -f1,2,3,4,11) \
        <(zcat all.combined.ss-so-sh.max-missing0.5.maf0.05.BI.SNP.Sh.stats.gz | cut -f1,2,3,4,11) | \
        cut -f1-5,10,15 | fgrep -v -w "NA" | \
        awk 'BEGIN{print "chr\tpos\tSS-SH\tSO-SH"}{d1=($5*(1-$7)+(1-$5)*$7); d2=($6*(1-$7)+(1-$6)*$7);print $1"\t"$2"\t"d1"\t"d2}' | \
        bgzip -@ 24 -c > SGG1.0.SO-SS-SH.Dxy.txt.gz

bedtools map -a Srufi.v20210930.chr.50kb.bed \
        -b <(zcat SGG1.0.SO-SS-SH.Dxy.txt.gz |awk 'NR>1{print $1"\t"$2"\t"$2+1"\t"$3-$4}') \
        -c 4 -o mean,count |bgzip -@ 24 -c > SGG1.0.SO-SS-SH.Dxy.window.txt.gz

