# convert to plink2 dosage format (bgen-1.2)

zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.vcf.gz | \
	awk '{if(/^#/){print}else{exit}}'|tail -1|xargs -n1|tail -n+10|awk '{print $0" "$0" 0 0 0 -9"}' > SGG1.1.fam

zcat all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.vcf.gz | \
	awk '{print $1"."$2"\t"$4"\t"$5}' > all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.pos

awk 'BEGIN{printf "rsID\tA1\tA2"}{printf "\t"$1"+"$2}END{printf "\n"}' ../emmax.filtered/emmax_in.tfam  > SGG1.1.dosage.head
paste all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.pos <(cut -f5- ../emmax.filtered/emmax_in.tped) | \
	awk 'BEGIN{OFS="\t"}{for(i=4;i<=NF;i++){if($i==9){$i="NA"}else{$i=($i/2)}}; print $0}' > SGG1.1.dosage.body

awk '{split($1,a,".");split(a[1],b,"Chr"); print int(b[2])"\t"$1"\t0\t"a[2]}' all.combined.Sh.biallelic.max-missing0.8.maf0.05.filtered.pos > SGG1.1.info

~/software/plink2 --allow-extra-chr --double-id \
	--import-dosage SGG1.1.dosage format=1 id-delim=+ --export bgen-1.2 id-delim=+ \
	--map SGG1.1.info --psam SGG1.1.fam --threads 20 --pca 20


```
