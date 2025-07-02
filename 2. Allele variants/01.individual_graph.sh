#!/bin/bash

# Path to set according to your folders
out_folder_graphs=/share/home/off_huangyumin/ROC22/allele-pangenome/pggb/graphs


t=48
POA=asm20
O=0.03


f=/share/home/off_huangyumin/ROC22/allele-pangenome/data/split
p=90
s=50000
#l=$(echo "$s * 5" | bc)
k=47
G=13033,13177
T=40


header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=20

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr
"


for i in `seq 1 10`; do
	fq=${f}/ROC22.V0917.geno.Chr${i}.fasta.gz
	#samtools faidx $fq
	n=$(wc -l < ${fq}.fai)
	ref=ROC22_A

	so=$s
	

	l=$(echo "$so * 5" | bc)
	out=ROC22.Chr${i}_p$p.s$so.l$l.n$n.k$k.POA$POA.O$O.G$(echo $G | tr ',' '-').$ref
	echo "$header" > run_pggb.${out}.sh
	echo "pggb -i $fq -p $p -s $so -l $l -n $n -k $k -P $POA -O $O -G $G -t $t -V $ref:# -o ${out_folder_graphs}/${out} -m" >> run_pggb.${out}.sh

done