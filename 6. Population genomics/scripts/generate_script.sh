#!/bin/bash


mkdir -p out
for (( ii=2; ii<=418; ii++ )); do
    for (( j=ii+1; j<=418; j++ )); do
        
	echo -e "cut -f${ii},${j} all.combined.SNP.biallelic.max-missing0.6.maf0.05.doseage |fgrep -w -v \"-\" |gawk 'NR==1{n=0;tt=0;printf \$0}NR>1{split(\$1,a,\",\");split(\$2,b,\",\");if(a[1]>b[1]){t1=b[1]}else{t1=a[1]}; if(a[2]>b[2]){t2=b[2]}else{t2=a[2]}; o=(1-(t1+t2)); tt+=o; n++}END{printf \"\\\t%.50f %s\\\n\", tt, n}' > out/distance.${ii}.${j}"
    done
done

