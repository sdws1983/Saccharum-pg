### subsampling to a diploid state for inputfile format


python3 subsampling.py ../../all.combined.SNP.biallelic.max-missing0.6.maf0.05.recode.vcf all.combined.SNP.biallelic.max-missing0.6.maf0.05.subsampling.vcf 

awk '{if(/^#CHRO/){print; exit}else{print}}' all.combined.SNP.biallelic.max-missing0.6.maf0.05.subsampling.vcf  > header
shuf -n 1000000 all.combined.SNP.biallelic.max-missing0.6.maf0.05.subsampling.vcf > shuf.1M
grep -v "^#" shuf.1M |sort -k1,1 -k2,2n |cat header - > shuf.1M.vcf


### plink

plink --vcf shuf.1M.vcf -recode12 --out plink_out --allow-extra-chr --double-id --id-delim + --threads 20
plink --noweb --file plink_out --make-bed --out QC --allow-extra-chr --double-id --id-delim + --threads 20


### run faststructure

../../fastStructure -K 3 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 4 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 5 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 6 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 7 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 8 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 9 --input=QC --output=QC_output_simple --cv=5 --prior=simple
../../fastStructure -K 10 --input=QC --output=QC_output_simple --cv=5 --prior=simple
