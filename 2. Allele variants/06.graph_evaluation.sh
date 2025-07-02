# graph-based vcf preprocessing

vcfbub -l 0 -a 100000 --input ../../assessment/variants/pggb/vcfs/NpX.s20000.Chr1.smooth.final.NpX_A.vcf.gz | ~/software/vcflib/build/vcfwave -I 1000 -t 48 | bgzip -@ 16 > vcf/ref.chr1.vcf.gz
bash ~/software/pggb/scripts/vcf_preprocess.sh vcfs/ref.chr1.vcf.gz NpX_B 1 data/Chr1A.fasta

# NUCMER-based SNP identification

nucmer -t 40 -p output/Chr1A-1B Chr1A.fasta Chr1B.fasta
show-snps -CTlr out/Chr1A-1B.fasta.delta > out/Chr1A-1B.fasta.var.txt
Rscript ~/software/pggb/scripts/nucmer2vcf.R out/Chr1A-1B.fasta.var.txt NpX_B data/Chr1A.fasta 4.0.0beta2 vcfs/chr1.NpX_B.vcf
bgzip -@ 24 vcfs/chr1.NpX_B.vcf

# run RTG

~/software/rtg-tools-3.12.1/rtg format -o data/Chr1A.sdf Chr1A.fasta
~/software/rtg-tools-3.12.1/rtg vcfeval -t data/Chr1A.sdf -b t.vcf.gz -c ref.chr1.NpX_B.norm.vcf.gz -T 16 -o y4
~/software/rtg-tools-3.12.1/rtg vcfeval -t data/Chr1A.sdf -b vcfs/chr1.NpX_B.vcf.gz -c vcfs/ref.chr1.NpX_B.max1.vcf.gz -T 16 \
	-e <(bedtools intersect -a <(bedtools merge -d 1000 -i vcfs/chr1.NpX_B.vcf.gz) \
	-b <(bedtools merge -d 1000 -i vcfs/ref.chr1.NpX_B.max1.vcf.gz )) -o vcfeval/Chr1A-1B.out