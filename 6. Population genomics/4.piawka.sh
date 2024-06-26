bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 10000 -s 2000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w10k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 100000 -s 20000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w100k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 500000 -s 100000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w500k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 1000000 -s 200000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w1M.bed


time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w10k.bed -g all.line -v ../combined.vcf.gz > w10k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w100k.bed -g all.line -v ../combined.vcf.gz > w100k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w500k.bed -g all.line -v ../combined.vcf.gz > w50k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w1M.bed -g all.line -v ../combined.vcf.gz > w1M.pi


