# SGG1.0

~/software/vg autoindex --threads 40 --workflow giraffe -T ./ -r ~/reference/Srufi/Srufi.v20210930.chr.fasta \
	-v Saccharum_genus.re.community.0.vcfbub.vcf.gz -v Saccharum_genus.re.community.1.vcfbub.vcf.gz -v Saccharum_genus.re.community.2.vcfbub.vcf.gz \
	-v Saccharum_genus.re.community.3.vcfbub.vcf.gz -v Saccharum_genus.re.community.4.vcfbub.vcf.gz -v Saccharum_genus.re.community.5.vcfbub.vcf.gz \
	-v Saccharum_genus.re.community.6.vcfbub.vcf.gz -v Saccharum_genus.re.community.7.vcfbub.vcf.gz -v Saccharum_genus.re.community.8.vcfbub.vcf.gz \
	-v Saccharum_genus.re.community.9.vcfbub.vcf.gz -p SGG1.0.combined

# SGG1.1

### filter maf and missing

for i in `seq -w 1 10`;do
	bcftools view --threads 48 -r Chr${i} SGG1.0.merged.SO-SS-SH.final.biallelic.vcf.gz | bcftools filter --threads 48 -e 'F_MISSING > 0.50 || AC[0]/AN[0] < 0.01' -Oz -o SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.vcf.gz 
	tabix -p vcf SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.vcf.gz
done

### convert to dip genotypes (optional)

for i in `seq -w 1 10`;do
	python3 ploy2dip.py SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.vcf.gz SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.dip.vcf.gz &
done

### filter SVs

for i in `seq -w 1 10`;do
	bcftools filter --threads 48 -e 'LEN >= 50' -Oz -o SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.dip.SNPINDEL.vcf.gz SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr${i}.dip.vcf.gz
done

### de-dup SGG1.0 sites

for i in `seq 0 9`;do zcat Saccharum_genus.re.community.${i}.vcfbub.vcf.gz|awk '!/^#/'|cut -f1,2 > Saccharum_genus.re.community.${i}.vcfbub.vcf.sites;done
zcat pop/SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr01.dip.SNPINDEL.vcf.gz | fgrep -w -v -f Saccharum_genus.re.community.0.vcfbub.vcf.sites - | bgzip -@ 24 > SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr01.dedup.dip.SNPINDEL.vcf.gz

### generate artificial haplotypes for population-only variants

vg autoindex --threads 128 --workflow giraffe -T ./ -r ~/reference/Erufi/Srufi.v20210930.chr.fasta \
	-v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr01.dedup.dip.SNPINDEL.vcf.gz -v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr02.dedup.dip.SNPINDEL.vcf.gz \
	-v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr03.dedup.dip.SNPINDEL.vcf.gz -v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr04.dedup.dip.SNPINDEL.vcf.gz \
	-v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr05.dedup.dip.SNPINDEL.vcf.gz -v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr06.dedup.dip.SNPINDEL.vcf.gz \
	-v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr07.dedup.dip.SNPINDEL.vcf.gz -v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr08.dedup.dip.SNPINDEL.vcf.gz \
	-v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr09.dedup.dip.SNPINDEL.vcf.gz -v SGG1.0.merged.SO-SS-SH.final.biallelic.maf0.01.Chr10.dedup.dip.SNPINDEL.vcf.gz \
	-p maf0.01.poponly

vg snarls --threads 24 maf0.01.poponly.giraffe.gbz > maf0.01.poponly.snarls
vg deconstruct -r maf0.01.poponly.snarls maf0.01.poponly.giraffe.gbz > maf0.01.poponly.deconstruct.vcf
bgzip -@ 24 maf0.01.poponly.deconstruct.vcf && tabix -p vcf maf0.01.poponly.deconstruct.vcf.gz

### merge vcfs from SGG1.0

for i in `seq -w 1 10`;do
bcftools view --threads 48 -r Chr${i} maf0.01.poponly.deconstruct.vcf.gz | awk '{if(/^#/){print}else{OFS="\t"; $3=$1"."$2; print $0}}' | bgzip -@ 24 > maf0.01.poponly.deconstruct.Chr${i}.vcf.gz
tabix -p vcf maf0.01.poponly.deconstruct.Chr${i}.vcf.gz
done

bcftools merge --threads 48 ../../Saccharum_genus.re.community.0.vcfbub.vcf.gz maf0.01.poponly.deconstruct.Chr01.vcf.gz | bcftools sort --temp-dir ./ | bgzip -@ 24 -c > SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr01.vcf.gz && tabix -p vcf SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr01.vcf.gz

### giraffe autoindex

mkdir -p maf0.01.remerged.poponly
~/software/vg autoindex --threads 128 --workflow giraffe -T ./ -r ~/reference/Erufi/Srufi.v20210930.chr.fasta \
	-v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr01.vcf.gz -v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr02.vcf.gz \
	-v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr03.vcf.gz -v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr04.vcf.gz \
	-v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr05.vcf.gz -v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr06.vcf.gz \
	-v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr07.vcf.gz -v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr08.vcf.gz \
	-v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr09.vcf.gz -v SGG1.1.merged.final.biallelic.maf0.01.remerged.Chr10.vcf.gz \
	-p maf0.01.remerged.poponly/SGG1.1.combined
~/software/vg snarls --threads 24 maf0.01.remerged.poponly/SGG1.1.combined.giraffe.gbz > maf0.01.remerged.poponly/SGG1.1.combined.snarls

