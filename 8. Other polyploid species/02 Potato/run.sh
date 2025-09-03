### 01. Estimate genetic distance by mash
for i in merge_haplotype*gz; do mash triangle ${i} > ${i}_mash_triangle.txt;done

### 02. Constract graph pangenome by PGGB
for i in $(seq -w 1 12); do
  pggb -i ../input/merged.40hap.chr${i}.fa.gz \
  -p 92 -m -s 10000 -n 48 -P asm20 -k 23 -t 64 -V WhR_A:# \
  -o ./chr${i}
done

### 03. Count PAV by odgi
bedtools makewindows -g  <(cut -f 1,2 *.fai) -w 50000 > pav_50000bin.bed
odgi pav -t 40 -P -i merge.og  -b  pav.bed  > catton.pavs.tsv

### 04. Pangenome growth curve
grep -e '^W' Potatoes.combine.gfa | cut -f2-6 | awk '{ print $1 "#" $2 "#" $3 ":" $4 "-" $5 }' > paths.txt
grep -ve 'Ack_A' paths.txt > paths.haplotypes.txt
source activate  py310
for i in node edge bp;do
#RUST_LOG=info ./panacus histgrowth -t10 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -a  -c $i -s  paths.haplotypes.txt  Potatoes.combine.gfa > pggb.histgrowth.${i}.tsv
./panacus-visualize.py pggb.histgrowth.${i}.tsv > pggb.histgrowth.${i}.pdf
done

### 05.Rna-seq analyse
bcftools view -i 'strlen(REF)<1000 && strlen(ALT)<1000' -o merge.filtered.vcf merge.vcf
bgzip -@ 80 merge.filtered.vcf
vg autoindex --threads 128  --workflow mpmap  --prefix potato \
--ref-fasta WhR_A.fa   -v merge.filtered.vcf.gz  \
--tx-gff WhR_A_hap1_liftoff.gff3  -T ./ --gff-tx-tag Parent -f CDS

GRAPH="potato.spliced.xg"
GCSA="potato.spliced.gcsa"
DIST_INDEX="potato.spliced.dist"
for r1 in ../*_1.fq.gz; do
    r2="${r1/_1.fq.gz/_2.fq.gz}"
		echo "vg mpmap -t 20  -x ${GRAPH} -g ${GCSA} -d ${DIST_INDEX} -f $r1 -f $r2 1>${out_folder_graphs}/$base.gamp 2>$base.log"
done

# haplotype
hisat2-build -p 50   WhR.fa  ref_haptype
for r1 in ./fqs/*_1.fq.gz; do
    r2="${r1/_1.fq.gz/_2.fq.gz}"
    base=$(basename "$r1" .trimmed_1.fq.gz)
		echo "hisat2 -p 50 -x ref_haptype     --dta -1 $r1 -2 $r2 | samtools sort -@ 10 -o ${out_folder_graphs}/$base.sorted.bams   2>${out_folder_graphs}/$base.log"
done
# monoploid
hisat2-build -p 50   WhR.1.fa  ref_haptype
for r1 in ./fqs/*_1.fq.gz; do
    r2="${r1/_1.fq.gz/_2.fq.gz}"
    base=$(basename "$r1" .trimmed_1.fq.gz)
		echo "hisat2 -p 50 -x ref_haptype     --dta -1 $r1 -2 $r2 | samtools sort -@ 10 -o ${out_folder_graphs}/$base.sorted.bams   2>${out_folder_graphs}/$base.log"
done


