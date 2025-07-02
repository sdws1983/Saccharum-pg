#!/bin/bash

fa="fasta/Saccharum_genus.re.fasta.gz"
prefix=`echo $fa|awk -F '.fasta' '{print $1}'`

echo $prefix

mash dist $fa $fa -s 10000 -i -p 40 > ${prefix}.distances.tsv
python3 ~/software/pggb/scripts/mash2net.py -m ${prefix}.distances.tsv
python3 ~/software/pggb/scripts/net2communities.py -e ${prefix}.distances.tsv.edges.list.txt -w ${prefix}.distances.tsv.edges.weights.txt -n ${prefix}.distances.tsv.vertices.id2name.txt --plot --accurate-detection

