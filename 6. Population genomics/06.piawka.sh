### convert to discrete genotypes for input

vcftools --vcf - --remove-indels --max-alleles 2 --min-alleles 2 --stdout --recode | \
awk '{
    if (/^#/) {
        print
    }
    else {
        for (i = 1; i <= 8; i++) {
            printf "%s\t", $i
        }

        printf "GT"

        for (i = 10; i <= NF; i++) {
            # Split the genotype info
            split($i, a, ":")
            # get the allele counts
            split(a[3], b, ",")

            # handle missing
            if (a[1] == "./.") {
                printf "\t./././././././."
            }
            else {
                # Compute allele counts scaled by ploidy (8 here)
                aa = sprintf("%.0f", b[1] / (a[2] / 8))
                bb = sprintf("%.0f", b[2] / (a[2] / 8))

                printf "\t"

                # Print “0” aa times
                for (ii = 1; ii <= aa; ii++) {
                    printf "0"
                    if (ii < aa || bb > 0) {
                        printf "/"
                    }
                }

                # Print “1” bb times
                for (ii = 1; ii <= bb; ii++) {
                    printf "1"
                    if (ii < bb) {
                        printf "/"
                    }
                }
            }
        }
        printf "\n"
    }
}' | bgzip -@ 24 > so.vcf.gz


bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 10000 -s 2000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w10k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 100000 -s 20000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w100k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 500000 -s 100000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w500k.bed
bedtools makewindows -g ~/reference/Srufi/Srufi.v20210930.chr.fasta.fai -w 1000000 -s 200000 |awk '{print $0"\t"$1"_"$2"_"$3}' > Srufi.v20210930.w1M.bed


time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w10k.bed -g all.line -v ../combined.vcf.gz > w10k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w100k.bed -g all.line -v ../combined.vcf.gz > w100k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w500k.bed -g all.line -v ../combined.vcf.gz > w50k.pi 
time piawka_par_reg.sh -a "-j40 --bar" -p "FST=1" -b Srufi.v20210930.w1M.bed -g all.line -v ../combined.vcf.gz > w1M.pi


