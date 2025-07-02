i=1 # chromosome
start=123 # start node ID
end=456 # end node ID
output="test" # output prefix

# subgraphs by node range

vg find -x ../calling/pggb/vg/Chr${i}.mod.vg -r $((start - 200)):$((end + 200)) -c 0 > temp_graph.${i}

# convert vg to gfa

vg view -Vg temp_graph.${i} > temp_graph.${i}.gfa

# get alignments to the provided subgraph

vg find -A temp_graph.${i} -l SES-1-LF15.filtered.sorted.gam > temp_gamvg.${i}

# fetch node coverage for subgraph

vg pack -x temp_graph.${i} -g temp_gamvg.${i} -d | awk 'BEGIN{ OFS = "\t" } NR ==1 {print $2,$4}; NR > 1 { node_nuc[$2]++; node_cov[$2] += $4 } END{ for(node in node_nuc) { print node,node_cov[node]/node_nuc[node] } }' |sort -nk 1 > temp_gamvg.cov.${i}

# rename

mv temp_graph.${i}.gfa ${output}.gfa
mv test.nodehap.${i} ${output}.nodehap
mv temp_gamvg.cov.${i} ${output}.cov