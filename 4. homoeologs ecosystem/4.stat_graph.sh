echo "id segments links arcs mrank totalseg avgseg s mdegree avgdegree" > graphs_proteins.stat; for i in `ls graphs_proteins/`;do gfatools stat graphs_proteins/${i} | awk -F ': ' 'BEGIN{print "'$i'"}{print $2}'|xargs -n 10 >> graphs_proteins.stat;done 2>e &

echo "id segments links arcs mrank totalseg avgseg s mdegree avgdegree" > graphs_dna.stat; for i in `ls graphs_dna/`;do gfatools stat graphs_dna/${i} | awk -F ': ' 'BEGIN{print "'$i'"}{print $2}'|xargs -n 10 >> graphs_dna.stat;done 2>e &

for i in `ls graphs_dna/`;do odgi stats -s -i graphs_dna/${i}|tail -1|paste - <(echo -e "$i");done|awk 'BEGIN{print "path\tin_node_space\tin_nucleotide_space\tsum_nodes\tsum_nucleotides\tnum_penalties\tid"}{print}' > graphs_dna.sumpaths


### vg 1.40.0
for i in `ls graphs_proteins`;do (if [ $(grep -c "^L" graphs_proteins/${i}) -eq 0 ]; then cp graphs_proteins/${i} ./t.gfa; else vg ids -c graphs_proteins/${i} > t.gfa; fi) && (odgi stats -s -i t.gfa|tail -1|paste - <(echo -e "$i"));done|awk 'BEGIN{print "path\tin_node_space\tin_nucleotide_space\tsum_nodes\tsum_nucleotides\tnum_penalties\tid"}{print}' > graphs_proteins.sumpaths

echo "id paths" > graphs_dna.paths;for i in `ls graphs_dna/`;do paste -d" " <(echo $i) <(fgrep -w "P" graphs_dna/${i} |wc -l);done >> graphs_dna.paths &
echo "id paths" > graphs_proteins.paths;for i in `ls graphs_proteins/`;do paste -d" " <(echo $i) <(grep "^P" graphs_proteins/${i} |wc -l);done >> graphs_proteins.paths &

echo "id length" > graphs_dna.length;for i in `ls graphs_dna/`;do paste -d" " <(echo $i|sed 's/.gfa/.fasta') <(bioawk -c fastx '{print length($2); exit}' msas_dna_0.4/${i});done >> graphs_dna.length 
echo "id length" > graphs_proteins.length;for i in `ls graphs_proteins/`;do paste -d" " <(echo $i|sed 's/.gfa/.fasta') <(bioawk -c fastx '{print length($2); exit}' msas_proteins_0.4/${i});done >> graphs_proteins.length


python3 parse_alignlen.py msas_proteins_0.4/ graphs_proteins.length
python3 parse_alignlen.py msas_dna_0.4/ graphs_dna.length &


paste graphs_dna.stat graphs_dna.paths graphs_dna.length > graphs_dna.combined

paste graphs_proteins.stat graphs_proteins.paths graphs_proteins.length graphs_proteins.sumpaths bubble/graphs_proteins.bubble > graphs_proteins.combined
paste graphs_dna.stat graphs_dna.paths graphs_dna.length graphs_dna.sumpaths bubble/graphs_dna.bubble > graphs_dna.combined


cut -f1 all_proteins_cluster_0.4_cluster.tsv|sort|uniq -c |awk '{print $2"\t"$1}' > all_proteins_cluster_0.4_cluster.clu
