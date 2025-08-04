### prepare discrete genotypes for pcadapt input (https://github.com/bcm-uga/pcadapt/issues/50)
### 0,1,2,3,4,5,6,7,8 represent dosage; 9 represent NA

zcat ../covertvcf/ss.vcf.gz | awk '!/^#/{printf $1"_"$2" "; for(i=10;i<=NF;i++){if($i=="./././././././."){printf 9" "}else{split($i,a,"\/");al=0;for(e=1;e<=length(a);e++){if(a[e]==1){al+=1}};printf al" "}}; printf "\n"}' | awk '{a=substr($0,1,length($0)-1); print a}' | awk '{delete a; s=0; t=0; for(i=2;i<=NF;i++){a[$i]+=1; if($i!=9){s+=$i; t+=8}}; if(a[9]>=47){next}; if(s/t>0.95||s/t<0.05){next}; print}' > ss.pcadapt.raw &
zcat ../covertvcf/so.vcf.gz | awk '!/^#/{printf $1"_"$2" "; for(i=10;i<=NF;i++){if($i=="./././././././."){printf 9" "}else{split($i,a,"\/");al=0;for(e=1;e<=length(a);e++){if(a[e]==1){al+=1}};printf al" "}}; printf "\n"}' | awk '{a=substr($0,1,length($0)-1); print a}' | awk '{delete a; s=0; t=0; for(i=2;i<=NF;i++){a[$i]+=1; if($i!=9){s+=$i; t+=8}}; if(a[9]>=23){next}; if(s/t>0.95||s/t<0.05){next}; print}' > so.pcadapt.raw &
wait

cut -d" " -f2- ss.pcadapt.raw > ss.pcadapt
cut -d" " -f2- so.pcadapt.raw > so.pcadapt

### run pcadapt

Rscript pcadapt.r