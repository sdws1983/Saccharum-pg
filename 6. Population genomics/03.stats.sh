# mapped genome size

~/software/vg pack -t 24 -x ../SGG1.1.combined.xg -i AH1803.pack -d | awk '$4>0' |wc -l > AH1803.cov

# gene coverage

bedtools coverage -a ~/reference/Erufi/Srufi.v20210930.CDS.merged.bed -b <(bamToBed -i AH1803.sorted.bam|cut -f1-3|sort -k1,1 -k2,2n) > AH1803.sorted.bam.genecov
