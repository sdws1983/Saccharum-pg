# deconstruct vcf from genus graph

vg deconstruct -P ROC22_A -e -a -t 24 -r ../gfa/Saccharum_genus.re.community.1.smooth.final.snarls ../gfa/Saccharum_genus.re.community.1.*.smooth.final.gfa > Saccharum_genus.re.community.1.ROC22_A.vcf

# find species-specific markers

python3 mark.py $i ZG,LAp NpX,AP85 ${i}.marks

# calculate subgenome proportion

bedtools map -a Chr1.500k.window.bed -b <(awk '{if($9=="SS"){t=0}else{t=1}; print $1"\t"$2"\t"$2+1"\t"t}' Saccharum_genus.re.community.0.ROC22.combined.vcf.marks) -c 4 -o mean,median > Saccharum_genus.re.community.0.ROC22.combined.vcf.marks.win