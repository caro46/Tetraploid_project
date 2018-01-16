#!/usr/bin/perl

#########################################################
#Creating the metafile file for lordec, 1 inputfile/line#
#########################################################

#For now, not using 180bp 2nd library because lower quality
#and issues with this data in the past when used in other softwares 

use strict;
use warnings;
my @files;
my @files_R1_180_1;
my @files_R1_180_2;
my @files_R1_400;
my @files_R1_1000;
my @files_R1_6000_1;
my @files_R1_6000_2;
my @files_R1_10000;
my $path_to_data;
$path_to_data = "/home/cauretc/scratch/HiSeq_data/";
my $output = "/home/cauretc/scratch/lordec_analysis/input_metalist.txt";

unless(open FILE, '>'.$output) {
	die "\nUnable to create $output\n";
}

##1st 180bp library
@files_R1_180_1 = glob($path_to_data."BenEvansBJE3652_180bp_Library_GTTTCG*.fastq.gz");
my $y;

for ($y=0; $y<=$#files_R1_180_1; $y ++) {
	#print FILE "180bp_1_",$y,",Illumina_180bp,", $files_R1_180_1[$y],"\n";
	print FILE $files_R1_180_1[$y],"\n";
}

##2nd 180bp library: not used for now for correction
#@files_R1_180_2 = glob($path_to_data."Ben_Evans_BJE3652_180_BP_Library_2nd_Sequence*.fastq.gz");
#for ($y=0; $y<=$#files_R1_180_2; $y ++) {
#	print FILE $files_R1_180_2[$y],"\n";
#}

##400bp library
@files_R1_400 = glob($path_to_data."BenEvansBJE3652_400bp*.fastq.gz");
for ($y=0; $y<=$#files_R1_400; $y ++) {
	print FILE $files_R1_400[$y],"\n";
}

##1kb library
@files_R1_1000 = glob($path_to_data."BenEvansBJE3652_1000bp_Library*.fastq.gz");
for ($y=0; $y<=$#files_R1_1000; $y ++) {
	print FILE $files_R1_1000[$y],"\n";
}

##1st 6kb library
@files_R1_6000_1 = glob($path_to_data."Ben-Evans-BJE3652-6kb_NoIndex_*.fastq.gz");
for ($y=0; $y<=$#files_R1_6000_1; $y ++) {
	print FILE $files_R1_6000_1[$y],"\n";
}

##2nd 6kb library
@files_R1_6000_2 = glob($path_to_data."Ben_Evans_BJE3652_6kb_2nd_Sequencing*.fastq.gz");
for ($y=0; $y<=$#files_R1_6000_2; $y ++) {
	print FILE $files_R1_6000_2[$y],"\n";
}

#10 kb library
@files_R1_10000 = glob($path_to_data."Ben_Evans_BJE3652_10kb_Mate_Pair_Library*.fastq.gz");
for ($y=0; $y<=$#files_R1_10000; $y ++) {
	print FILE $files_R1_10000[$y],"\n";
}

close FILE;
