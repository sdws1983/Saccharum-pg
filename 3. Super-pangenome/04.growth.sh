#!/bin/bash
#PBS -l nodes=1:ppn=24
#PBS -q fat

source ~/.bashrc 

cd $PBS_O_WORKDIR
for i in node edge bp;do
        echo $i
        RUST_LOG=info panacus ordered-histgrowth -t 24 -q 0,0.1,0.5,1 -S -O genus.samples.sorted s20k.graphs.combined.gfa -c $i > genus_s20k.histgrowth.ordered.${i}.tsv


done

ls *tsv|fgrep "ordered"|fgrep "s20k"|awk '{print "panacus-visualize -e "$0" > "$0".pdf"}' |bash -
