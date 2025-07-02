#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=1:ppn=20

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


ref="/share/home/off_huangyumin/reference/LA_purple/LAp_v20220608.genome.fasta"
prefix="LAp"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/Srufi/Srufi.v20210930.chr.fasta"
prefix="Srufi"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/Efulvus/Erufi_final_genome.chr.fasta"
prefix="Erufi"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/Np-X/Np-X.3ddna.Chr.v20210804.Chr.fa"
prefix="NpX"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/zhongguo/ZG.v20211208.genome.chr.fasta"
prefix="ZG"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/AP85/Sspon.HiC_chr_asm.fasta"
prefix="AP85"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/R570/assembly/SofficinarumxspontaneumR570_771_v2.0.chr.primarary.fa"
prefix="R570"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta

ref="/share/home/off_huangyumin/reference/ZZ/GWHEQVP00000000.genome.chr.renamed.fasta"
prefix="ZZ"
java -jar ~/software/NLR-Annotator/NLR-Annotator-v2.1b.jar -i $ref -x ~/software/NLR-Annotator/src/mot.txt -y ~/software/NLR-Annotator/src/store.txt -t 20 -c ${prefix}.output.tsv -o ${prefix}.output.txt -g ${prefix}.output.gff -b ${prefix}.output.bed -m ${prefix}.output.motifs.bed -a ${prefix}.output.nbarkMotifAlignment.fasta
