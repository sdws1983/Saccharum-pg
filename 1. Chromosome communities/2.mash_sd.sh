#!/bin/bash

zcat $(ls fasta/*renamed.fasta.gz | tr '\n' ' ') |bgzip -@ 24 -c > fasta/Saccharum_genus.fasta.gz
samtools faidx fasta/Saccharum_genus.fasta.gz 

fa="fasta/Saccharum_genus.fasta.gz"
prefix=`echo $fa|awk -F '.fasta' '{print $1}'`

echo $prefix

mash triangle -i -s 10000 -p 40 $fa > ${prefix}.dis
sed 's/#1#Chr/#/g' ${prefix}.dis > ${prefix}.dis2

fneighbor -datafile ${prefix}.dis2 -outfile ${prefix}.dis.tree.out1.txt -matrixtype s -treetype n -outtreefile ${prefix}.dis.tree.out2.tre
sed -i 's/#/#Chr/g' fasta/Saccharum_genus.dis.tree.out2.tre
sed -i 's/Chr0/Chr/g' fasta/Saccharum_genus.dis.tree.out2.tre