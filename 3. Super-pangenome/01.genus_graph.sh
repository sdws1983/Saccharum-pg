#!/bin/bash

# Path to set according to your folders
out_folder_graphs=/share/home/off_huangyumin/ROC22/genus/pggb/graph_2024


t=48
POA=asm20
O=0.03


#f=/share/home/off_huangyumin/ROC22/genus/communities/fasta
f=/share/home/off_huangyumin/ROC22/genus/pggb/fasta
p=85
s=20000
#l=$(echo "$s * 5" | bc)
k=47
G=13033,13177
T=40


header="#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=10

source /share/home/off_huangyumin/.bashrc
cd \$PBS_O_WORKDIR

echo \"\${PBS_JOBID}.\${PBS_JOBNAME}.\${PBS_O_WORKDIR}\" > ~/qsub_task/job.\`date +\"%Y-%m-%d_%H-%M-%s%N\"\`

exec 1>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stdout
exec 2>job.\${PBS_JOBID}.\${PBS_JOBNAME}.stderr

"


for i in `seq 0 9`; do
	fq=${f}/Saccharum_genus.re.community.${i}.fa.gz
	#samtools faidx $fq
	n=$(wc -l < ${fq}.fai)
	ref=Srufi

	so=$s

	l=$(echo "$so * 5" | bc)
	out=genus.community.${i}_p$p.s$so.l$l.n$n.k$k.POA$POA.O$O.G$(echo $G | tr ',' '-').$ref
	echo "$header" > run.${out}.sh
	echo "pggb -i $fq -p $p -s $so -l $l -n $n -k $k -P $POA -O $O -G $G -t $t -V $ref:# -o ${out_folder_graphs}/${out} -m" >> run.${out}.sh

done


