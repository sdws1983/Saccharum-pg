#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -q comput

cd $PBS_O_WORKDIR

#  map_reads_mpmap.sh
#  
# map reads using vg mpmap
#

##
# inputs
##
GRAPH="Srufi.combined.spliced.xg"
GCSA="Srufi.combined.spliced.gcsa"
DIST_INDEX="Srufi.combined.spliced.dist"
READS_1="roc1-10_FRAS190026461-1a_1.fq.gz"
READS_2="roc1-10_FRAS190026461-1a_2.fq.gz"
NUMCPU=24
REF_PATHS="reference_paths.txt"

##
# outputs
##
GAMP="XTTL-1.gamp"
BAM="XTTL-1.gamp.bam"


# map to graph
~/software/vg mpmap -x "$GRAPH" -g "$GCSA" -d "$DIST_INDEX" -f "$READS_1" -f "$READS_2" > "$GAMP"


~/software/vg view --threads $NUMCPU -K -G $GAMP > ${GAMP}.gam
~/software/vg stats --threads $NUMCPU -a ${GAMP}.gam > ${GAMP}.gam.stats

# project down to linear reference
#~/software/vg surject -x "$GRAPH" -t "$NUMCPU" -m -b -S -A -F "$REF_PATHS" "$GAMP" > "$BAM"