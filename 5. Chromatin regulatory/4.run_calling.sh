#!/bin/bash
#PBS -q workq
#PBS -j oe
#PBS -l nodes=s001:ppn=1

source /share/home/off_huangyumin/.bashrc
cd $PBS_O_WORKDIR

echo "${PBS_JOBID}.${PBS_JOBNAME}.${PBS_O_WORKDIR}" > ~/qsub_task/job.`date +"%Y-%m-%d_%H-%M-%s%N"`

exec 1>job.${PBS_JOBID}.${PBS_JOBNAME}.stdout
exec 2>job.${PBS_JOBID}.${PBS_JOBNAME}.stderr


echo 1

prefix="LA-2-LF15"
f="LA-2"

read_length=60  
fragment_length=200  # Change this number to the fragment length of your raw reads

index="../../calling/vg/"
graph_dir="../../calling/index/"
chromosomes="01,02,03,04,05,06,07,08,09,10"

#unique_reads=$(pcregrep --buffer-size 102400 -o1 '"sequence": "([ACGTNacgtn]{20,})"' filtered.json | sort | uniq | wc -l)
unique_reads=$(graph_peak_caller count_unique_reads $chromosomes $graph_dir ${f}/${prefix}.filtered_|tail -1)
#graph_peak_caller count_unique_reads $chromosomes $graph_dir/ filtered ### use this cmd to count unique reads

#unique_reads=19410942
echo $unique_reads
genome_size=860000000  # Change to correct number for the species you are using

for chromosome in $(echo $chromosomes | tr "," "\n")
do
	echo $chromosome
	graph_peak_caller callpeaks -a True -g $graph_dir/$chromosome.nobg -s ${f}/${prefix}.filtered_${chromosome}.json -n ${f}/${prefix}.filtered_${chromosome} -f $fragment_length -r $read_length -p True -u $unique_reads -G $genome_size &
done
wait


ls *npy |awk '{a=substr($0,1,2);b=substr($0,3,length($0));print "mv "$0" "a"_"b}' | bash -

for chromosome in $(echo $chromosomes | tr "," "\n")
do
	graph_peak_caller callpeaks_whole_genome_from_p_values -d $graph_dir/ -n "" -f $fragment_length -r $read_length $chromosome &
done
wait

for chromosome in $(echo $chromosomes | tr "," "\n")
do
graph_peak_caller peaks_to_linear ${chromosome}_max_paths.intervalcollection ${graph_dir}/${chromosome}_linear_pathv2.interval $chromosome ${chromosome}_linear_peaks.bed > ${chromosome}.linear.log
done
wait

graph_peak_caller concatenate_sequence_files $chromosomes all_peaks.fasta

