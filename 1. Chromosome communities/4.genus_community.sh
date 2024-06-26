
f="fasta"
#<<!
seq 0 9 | while read i; do
    echo "community $i"
    samtools faidx ${f}/Saccharum_genus.re.fasta.gz $(cat ${f}/Saccharum_genus.re.distances.tsv.edges.weights.txt.community.${i}.txt) | \
    bgzip -@ 24 -c > ${f}/Saccharum_genus.re.community.${i}.fa.gz
    samtools faidx ${f}/Saccharum_genus.re.community.${i}.fa.gz
done
#!
ls fasta/Saccharum_genus.re.community.*.fa.gz | while read CHR_FASTA; do
    echo $CHR_FASTA
    CHROM=$(echo $CHR_FASTA | cut -f 4 -d '.')
    prefix=$(echo $CHR_FASTA | cut -f 1 -d '.')
    mash triangle -p 40 $CHR_FASTA  | sed 1,1d | tr '\t' '\n' | grep -v "Chr" > ${prefix}.re.divergence.${CHROM}.txt
    mash triangle -p 40 -E $CHR_FASTA  > ${prefix}.re.divergence.E.${CHROM}.txt
    MAX_DIVERGENCE=$(mash triangle -p 40 $CHR_FASTA | sed 1,1d | tr '\t' '\n' | grep chr -v | LC_ALL=C  sort -g -k 1nr | uniq | head -n 1)

    echo -e "$CHROM\t$MAX_DIVERGENCE" >> ${prefix}.divergence.txt
done