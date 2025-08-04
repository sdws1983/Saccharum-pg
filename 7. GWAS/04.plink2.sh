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


# examples:

### input file:

### dosage file
```bash
$ head <(cut -f1-10 SGG1.1.dosage)
rsID    A1      A2      AH1803+AH1803   B8+B8   Badila+Badila   BC2-32+BC2-32   BH10-12+BH10-12 C323-68+C323-68 C529-50+C529-50
Chr01.94344     C       T       0.116279        0.0784315       0       0.0526315       0.130435        0.0322581       0.015873
Chr01.97302     G       A       0.78261 0.565215        0.609375        0.854165        0.910715        0.697675        0.5
Chr01.97358     T       A       0.270834        0.333334        0.310345        0.12069 0.051282        0.280899        0.434783
Chr01.97391     T       G       0.183673        0.394737        0.344828        0.122807        0.0789475       0.259259        0.408164
Chr01.97408     A       ATATATACG       0.195652        0.436619        0.415094        0.173913        0.108434        0.313953        0.38
Chr01.97643     A       G       1       0.875   1       0.882355        0.914285        1       0.89189
Chr01.97693     T       C       0.77778 0.8     1       0.809525        1       0.857145        1
Chr01.97719     A       AA      0.56    0.694445        0.45283 0.533335        0.442308        0.846155        0.63158
Chr01.97837     TAATACTCCAGT    T       0.585365        0.436619        0.25641 0.130435        0.153846        0.60494 0.486486
```

### fam file
```bash
$ head SGG1.1.fam 
AH1803 AH1803 0 0 0 -9
B8 B8 0 0 0 -9
Badila Badila 0 0 0 -9
BC2-32 BC2-32 0 0 0 -9
BH10-12 BH10-12 0 0 0 -9
C323-68 C323-68 0 0 0 -9
C529-50 C529-50 0 0 0 -9
C86-456 C86-456 0 0 0 -9
C88-380 C88-380 0 0 0 -9
C89-147 C89-147 0 0 0 -9
```


### map file
```bash
$ head SGG1.1.info 
1       Chr01.94344     0       94344
1       Chr01.97302     0       97302
1       Chr01.97358     0       97358
1       Chr01.97391     0       97391
1       Chr01.97408     0       97408
1       Chr01.97643     0       97643
1       Chr01.97693     0       97693
1       Chr01.97719     0       97719
1       Chr01.97837     0       97837
1       Chr01.97883     0       97883
```
