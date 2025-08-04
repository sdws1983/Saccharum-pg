#!/bin/bash
#PBS -l nodes=1:ppn=20
#PBS -q comput

cd $PBS_O_WORKDIR

# Set SENTIEON_LICENSE if it is not set in the environment
SENTIEON_LICENSE=""
export SENTIEON_LICENSE="${SENTIEON_LICENSE}"

#export SENTIEON_LICENSE=172.25.58.47:8990

# Update with the location of the Sentieon software package
SENTIEON_INSTALL_DIR=/share1/biosoft/sentieon-genomics-202503

# Update with the location of temporary fast storage and uncomment
#SENTIEON_TMPDIR=/tmp

# Update with the location of the reference data files
#fasta=/public2/home/off_huangyumin/reference/sorghum/Sorghum_bicolor.Sorghum_bicolor_NCBIv3.dna.toplevel.fa
fasta=/public2/home/off_huangyumin/reference/Potato/WhR/WhR.1.fa

vcf=""
v=" -v "
for i in `ls result/*/output-hc.vcf.gz`;do
	vcf="${vcf}${v}${i}"
done

#echo $vcf

$SENTIEON_INSTALL_DIR/bin/sentieon driver -t 20 -r $fasta --algo GVCFtyper $vcf output.raw.vcf.gz

