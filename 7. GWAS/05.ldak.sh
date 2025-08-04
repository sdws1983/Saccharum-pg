~/software/ldak6.1.linux --bgen plink2.bgen --sample plink2.sample --cut-weights snps --window-prune 0.98
~/software/ldak6.1.linux --bgen plink2.bgen --sample plink2.sample --calc-weights-all snps --max-threads 48 

for j in {-20..10}; do
alpha=`echo $j | awk '{print $1/20}'`; echo $alpha
~/software/ldak6.1.linux --calc-kins-direct LDAK-Thin-snp-$alpha --bgen plink2.bgen --sample plink2.sample --weights snps/weights.short --power $alpha
done


for i in {1..8};
do seq -20 10| awk '{print $1/20}'| parallel -j 10 "~/software/ldak6.1.linux --reml ./reml/alpha{}_T${i}_snp --pheno phenofile.sugar --mpheno ${i} --constrain YES --grm LDAK-Thin-snp-{} --covar emmax_in.pca5.txt"
for j in {-20..10}; do alpha=`echo $j | awk '{print $1/20}'`; grep Alt_Likelihood ./reml/alpha${alpha}_T${i}_snp.reml |awk -v alpha=${alpha} '{print alpha, $2}' >> ${i}_snp_Alt_Likelihood.txt ; done
~/software/ldak6.1.linux --find-gaussian ${i}_snp_alpha --likelihoods ${i}_snp_Alt_Likelihood.txt
done

for i in {1..8};
do seq -20 10| awk '{print $1/20}'| parallel -j 10 "~/software/ldak6.1.linux --reml ./reml2/alpha{}_T${i}_snp --pheno phenofile.leaf --mpheno ${i} --constrain YES --grm LDAK-Thin-snp-{} --covar emmax_in.pca5.txt"
for j in {-20..10}; do alpha=`echo $j | awk '{print $1/20}'`; grep Alt_Likelihood ./reml2/alpha${alpha}_T${i}_snp.reml |awk -v alpha=${alpha} '{print alpha, $2}' >> ${i}_snp_Alt_Likelihood2.txt ; done
~/software/ldak6.1.linux --find-gaussian ${i}_snp_alpha2 --likelihoods ${i}_snp_Alt_Likelihood2.txt
done