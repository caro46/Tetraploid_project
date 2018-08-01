#!/bin/bash
for files in /4/ben/2017_mellotropGBS_from_2015/trimmed_mellotrop_demultiplexed_reads/*.fq; do
	awk 'BEGIN { t=0.0;sq=0.0; n=0;} ;NR%4==2 {n++;L=length($0);t+=L;sq+=L*L;}END{m=t/n;printf(FILENAME " total %d avg=%f stddev=%f\n",n,m,sq/n-m*m);}' $files >>stats_whole_family_single_trimmed_reads_awk.txt;
done
