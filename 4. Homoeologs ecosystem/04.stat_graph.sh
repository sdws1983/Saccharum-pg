echo `gettime`"calculate graph complexity..."

echo "id segments links arcs mrank totalseg avgseg s mdegree avgdegree" > ${based}/graphs.stat; for i in `ls ${based}/graphs/`;do gfatools stat ${based}/graphs/${i} | awk -F ': ' 'BEGIN{print "'$i'"}{print $2}'|xargs -n 10 |awk '{sub(/\.gfa$/, "", $1); print}' >> ${based}/graphs.stat;done 2>${based}/logs/gfatools.log

python3 ${script_dir}/scripts/parse_alignlen.py ${based}/msas/ ${based}/graphs.length

mkdir -p ${based}/bubble

python3 ${script_dir}/scripts/parse_bubble.py ${based}/graphs ${based}/bubble/graphs.bubble ${based}/bubble/graphs.bubble.log > ${based}/logs/logs.bubble

paste ${based}/graphs.stat ${based}/graphs.length <(awk '{sub(/\.gfa$/, "", $1); print}' ${based}/bubble/graphs.bubble) |sed 's/[[:space:]]\+/\t/g' | awk '{if($1==$11&&$1==$15){print}else{print "Error: Inconsistent values found in line " NR ": " $0;exit 1;}}' | cut -f1-10,12-14,16- > ${based}/graphs.combined


if [ $? -ne 0 ]; then
    echo "Script terminated due to inconsistent values."
    exit 1
fi


awk -F "\t" 'BEGIN { OFS="\t" } 
function harmonic_series(n) {
    if (n <= 0) return 0
    sum = 0
    for (i = 1; i <= n; i++) {
        sum += 1 / i
    }
    return sum
}
NR == 1 {
    print $0, "indicatorL", "indicatorB"
} 
NR > 1 {
    h = harmonic_series($13)
    indicatorL = $3 / ($11 * h)
    indicatorB = $17 / $11
    print $0, indicatorL, indicatorB
}' ${based}/graphs.combined > ${based}/graphs.complexity.txt
