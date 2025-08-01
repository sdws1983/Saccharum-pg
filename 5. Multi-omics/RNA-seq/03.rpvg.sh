#!/bin/bash -x
#PBS -q comput
#PBS -j oe
#PBS -l nodes=1:ppn=20
cd $PBS_O_WORKDIR
date -R
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-0h-1.gamp -o GT28-ck-0h-1.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-0h-2.gamp -o GT28-ck-0h-2.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-12h-1.gamp -o GT28-ck-12h-1.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-12h-2.gamp -o GT28-ck-12h-2.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-1h-1.gamp -o GT28-ck-1h-1.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-1h-2.gamp -o GT28-ck-1h-2.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-24h-1.gamp -o GT28-ck-24h-1.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-24h-2.gamp -o GT28-ck-24h-2.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-3h-1.gamp -o GT28-ck-3h-1.gamp_rpvg --inference-model haplotype-transcripts 
rpvg -t 15 -g ../index/Srufi.combined.spliced.xg -p  ../index/Srufi.combined.haplotx.gbwt -f ../index/Srufi.combined.txorigin.tsv -a GT28-ck-3h-2.gamp -o GT28-ck-3h-2.gamp_rpvg --inference-model haplotype-transcripts
