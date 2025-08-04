dir="emmax.filtered"
out="res.filtered"

mkdir -p $out

for i in `seq -w 1 10`;do
#for t in GZZTF ZXWF TCD ZGD ZZZTF HYTF SCD ZLCD;do
for t in Elongation2 Elongation3 Elongation4 Seedling2 Seedling3 Mature2 Mature3 Mature4;do
~/software/emmax-intel64 -t ${dir}/emmax_in.Chr${i} -o ${out}/emmax.Chr${i}.${t}.qk -p traits.${t}.txt -k kinship/emmax_in.BN.kin -c emmax_in.cov.txt -Z
done
done