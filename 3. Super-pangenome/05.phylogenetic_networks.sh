# prepare genus vcfs

for i in `seq 0 9`;do vcftools --gzvcf Saccharum_genus.re.community.${i}.vcfbub.vcf.gz --recode-INFO-all --remove-indels --max-missing 0.7 --recode --min-alleles 2 --max-alleles 2 --remove remove --stdout | fgrep -v "CONFLICT=" | awk '{if(/^#/){if(/^#CHRO/){print $0"\tSrufi"}else{print}}else{print $0"\t0"}}' | bgzip -@ 24 -c > Saccharum_genus.re.community.${i}.SNP.max-missing0.7.vcf.gz;done

# build tree for each window

for i in `seq 0 9`;do 
python3 ~/software/vcf2phylip/vcf2phylip.py -i Saccharum_genus.re.community.${i}.SNP.max-missing0.7.vcf.gz --nexus
total=$(awk 'NR==1{print $2}' Saccharum_genus.re.community.${i}.SNP.max-missing0.7.min4.phy)
python3 partition.py $total 10000 partition.${i}.txt
~/software/iqtree-2.4.0-Linux-intel/bin/iqtree2 -s Saccharum_genus.re.community.${i}.SNP.max-missing0.7.min4.phy -S partition.${i}.txt --prefix Genetree/loci.${i} -T AUTO
done

# prepare treefile for phylonet input

cat Genetree/*treefile > Genetree/combined.treefile
python3 prepare.py Genetree/combined.treefile ./PhyloNet/locitree_noMan.nex


# run phylonet

bash phylonet.sh