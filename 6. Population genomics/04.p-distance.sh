### convert to allele dosage

awk '!/^##/{if(/^#CHRO/){for(i=10;i<=NF;i++){printf "\t"$i};printf "\n"}else{for(i=10;i<=69;i++){if($i~/^\.\/\./){printf "\t-"}else{if($i~/^0\/0/){printf "\t1,0"}else{if($i~/^1\/1/){printf "\t0,1"}else{if($i~/^0\/1/){printf "\t0.5,0.5"}else{printf "\terror"}}}}};for(i=70;i<=NF;i++){if($i~/^\.\/\./){printf "\t-"}else{split($i,a,":");split(a[3],b,",");printf "\t"(b[1]/(b[1]+b[2]))","(b[2]/(b[1]+b[2]))}}; printf "\n"}}' ../../all.combined.SNP.biallelic.max-missing0.6.maf0.05.recode.vcf > all.combined.SNP.biallelic.max-missing0.6.maf0.05.doseage

### generate cmds

bash generate_script.sh > cal_dis.sh

split -l 1500 cal_dis.sh cmds

ls cmds*|awk '{print "ParaFly -c "$0" -CPU 30 -v" > "run_"$0}' 


### cal matrix

python3 mat.py all.pairs all.pairs.mat