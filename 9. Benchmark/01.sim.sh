### run varsim

for i in `seq 1 65`;do 
echo -e "~/software/varsim/varsim.py --id ath_${i} --seed $i --reference ~/reference/ath/Col-PEK1.5_assembly_and_annotation/file1.Col-PEK1.5_Chr1-5_20220523.fasta --vc_num_snp 500000 --vc_num_ins 20000 --vc_num_del 20000 --vc_num_mnp 5000 --vc_num_complex 2500 --vc_min_length_lim 0 --vc_max_length_lim 1000000 --disable_sim --vc_prop_het 0.6 --vc_in_vcf ~/reference/ath/upload_vcf/combined.nor.vcf.gz --disable_rand_dgv --out_dir out_sim_${i} --log_dir log_sim_${i} --work_dir work_sim_${i}";
done

for i in `seq 1 65`;do awk '{if(/^>/){print $0"_""'$i'"}else{print}}' out_sim_${i}/ath_${i}.fa > fasta/ath_${i}.fa; done 

### merge fasta

awk '{print "cat ../fasta/ath_"$1".fa ../fasta/ath_"$2".fa > simp4."NR".fa"}' ../list.p4 |bash -

### merge vcfs

awk '{print "bcftools merge -0 -m all --info-rules - --use-header header ../vcfs/ath_"$1".truth.vcf.gz ../vcfs/ath_"$2".truth.vcf.gz | bgzip -@ 24 -c > vcfs/merged."NR".vcf.gz"}' ../list.p4 > merge_vcf.sh

### convert to geno

for i in `seq 1 32`;do awk '!/^#/{split($10,a,"[|/]"); split($11,b,"[|/]");out=a[1]+b[1]+a[2]+b[2]; print $1"\t"$2"\t"$4"\t"$5"\t"$8"\t"out}' vcfs/merged.${i}.vcf.gz |bgzip -@ 24 -c > vcfs/merged.${i}.geno.gz ;done

### convert to polyploid genotypes

seq 1 32|awk '{print "python3 convert_polyploid.py vcfs/merged."$0".vcf.gz sim4."$0" | bgzip -@ 24 -c > vcfs/merged."$0".polyploid.vcf.gz"}'|bash -

### sim reads
for i in `seq 1 32`;do for j in 5 10 20 30;do echo -e "~/software/art_bin_MountRainier/art_illumina -p -na -l 150 -ss HS25 -i fasta/simp4.${i}.fa -f ${j} -m 500 -s 10 -o ${j}x/sim4.${i}_";done;done > run_art.sh


