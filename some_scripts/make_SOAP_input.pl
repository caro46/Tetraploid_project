#!/usr/bin/perl

use strict;
use warnings;

my $output = "/home/cauretc/scratch/gap_closer/input_SOAP_conf_no180_2ndlib";

unless(open FILE, '>'.$output) {
	die "\nUnable to create $output\n";
}

my $path_to_data="/home/cauretc/scratch/HiSeq_data/";

my $y;
my $z;
my $x;
my $f;
my $g;
my $h;
my $j;

##180_1stseq_lib
my @files_R1_180;
my @files_R2_180;
my $path_to_data_180;

$path_to_data_180 = $path_to_data;
@files_R1_180 = glob($path_to_data_180."BenEvansBJE3652_180bp_Library_GTTTCG*_R1*_trim_paired.cor.fastq.gz");
@files_R2_180 = glob($path_to_data_180."BenEvansBJE3652_180bp_Library_GTTTCG*_R2*_trim_paired.cor.fastq.gz");

##180_2nseq_lib - not used for gapcloser
#my @files_R1_180_2;
#my @files_R2_180_2;
#my $path_to_data_180_2;

#$path_to_data_180_2 = $path_to_data;
#@files_R1_180_2 = glob($path_to_data_180_2."Ben_Evans_BJE3652_180_BP_Library_2nd_Sequence*_R1*_trim_paired.fastq.gz");
#@files_R2_180_2 = glob($path_to_data_180_2."Ben_Evans_BJE3652_180_BP_Library_2nd_Sequence*_R2*_trim_paired.fastq.gz");

##400bp
my @files_R1_400bp;
my @files_R2_400bp;
my $path_to_data_400bp;

$path_to_data_400bp =$path_to_data;
@files_R1_400bp = glob($path_to_data_400bp."BenEvansBJE3652_400bp_Library_*_R1*_trim_paired.cor.fastq.gz");
@files_R2_400bp = glob($path_to_data_400bp."BenEvansBJE3652_400bp_Library_*_R2*_trim_paired.cor.fastq.gz");

##1000bp
my @files_R1_1000bp;
my @files_R2_1000bp;
my $path_to_data_1000bp;

$path_to_data_1000bp = $path_to_data;
@files_R1_1000bp = glob($path_to_data_1000bp."BenEvansBJE3652_1000bp_Library*_R1*_trim_paired.cor.fastq.gz");
@files_R2_1000bp = glob($path_to_data_1000bp."BenEvansBJE3652_1000bp_Library*_R2*_trim_paired.cor.fastq.gz");


##6KB_Data_first_lane
my @files_R1_6KB;
my @files_R2_6KB;
my $path_to_data_6KB;

$path_to_data_6KB = $path_to_data;
@files_R1_6KB = glob($path_to_data_6KB."Ben-Evans-BJE3652-6kb_NoIndex*_R1*_trim_paired.cor.fastq.gz");
@files_R2_6KB = glob($path_to_data_6KB."Ben-Evans-BJE3652-6kb_NoIndex*_R2*_trim_paired.cor.fastq.gz");

##6KB_Data_2nd_Sequencing
my @files_R1_6KB_2;
my @files_R2_6KB_2;
my $path_to_data_6KB_2;

$path_to_data_6KB_2 =$path_to_data;
@files_R1_6KB_2 = glob($path_to_data_6KB_2."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex*_R1*_trim_paired.cor.fastq.gz");
@files_R2_6KB_2 = glob($path_to_data_6KB_2."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex*_R2*_trim_paired.cor.fastq.gz");

##10KB
my @files_R1_10KB;
my @files_R2_10KB;
my $path_to_data_10KB;

$path_to_data_10KB = $path_to_data;
@files_R1_10KB = glob($path_to_data_10KB."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex*_R1*_trim_paired.cor.fastq.gz");
@files_R2_10KB = glob($path_to_data_10KB."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex*_R2*_trim_paired.cor.fastq.gz");

print FILE "max_rd_len=152","\n","[LIB]","\n",
	"avg_ins=180","\n", "reverse_seq=0","\n","asm_flags=3","\n",
	"rd_len_cutoff=150","\n","rank=1","\n","pair_num_cutoff=3","\n","map_len=32","\n";
		
for ($y=0; $y<=$#files_R1_180; $y ++) {
	print FILE "q1=",$files_R1_180[$y],"\n","q2=",$files_R2_180[$y],"\n";
}

#print FILE "[LIB]","\n","avg_ins=180","\n", "reverse_seq=0","\n","asm_flags=3","\n",
#	"rd_len_cutoff=150","\n","rank=2","\n","pair_num_cutoff=3","\n","map_len=32","\n";

#for ($z=0; $z<=$#files_R1_180_2; $z ++) {
#	"q1=",$files_R1_180_2[$z],"\n","q2=",$files_R2_180_2[$z],"\n";
#}

print FILE "[LIB]","\n","avg_ins=400","\n", "reverse_seq=0","\n","asm_flags=3","\n",
	"rd_len_cutoff=150","\n","rank=3","\n","pair_num_cutoff=3","\n","map_len=32","\n";

for ($j=0; $j<=$#files_R1_400bp; $j ++){
	print FILE "q1=",$files_R1_400bp[$j],"\n","q2=",$files_R2_400bp[$j],"\n";
}

print FILE "[LIB]","\n","avg_ins=1000","\n", "reverse_seq=0","\n","asm_flags=3","\n",
	"rd_len_cutoff=150","\n","rank=4","\n","pair_num_cutoff=5","\n","map_len=35","\n";

for ($g=0; $g<=$#files_R1_1000bp; $g ++){
	print FILE "q1=",$files_R1_1000bp[$g],"\n","q2=",$files_R2_1000bp[$g],"\n";
}

print FILE "[LIB]","\n","avg_ins=6000","\n", "reverse_seq=1","\n","asm_flags=3","\n",
	"rd_len_cutoff=150","\n","rank=5","\n","pair_num_cutoff=5","\n","map_len=35","\n";

for ($x=0; $x<=$#files_R1_6KB; $x ++){
	print FILE "q1=",$files_R1_6KB[$x],"\n","q2=",$files_R2_6KB[$x],"\n";
}

print FILE "[LIB]","\n","avg_ins=6000","\n", "reverse_seq=1","\n","asm_flags=3","\n",
	"rd_len_cutoff=150","\n","rank=5","\n","pair_num_cutoff=5","\n","map_len=35","\n";

for ($f=0; $f<=$#files_R1_6KB_2; $f ++){
	print FILE "q1=",$files_R1_6KB_2[$f],"\n","q2=",$files_R2_6KB_2[$f],"\n";
}

print FILE "[LIB]","\n","avg_ins=10000","\n", "reverse_seq=1","\n","asm_flags=3","\n",
"rd_len_cutoff=150","\n","rank=6","\n","pair_num_cutoff=5","\n","map_len=35","\n";

for ($h=0; $h<=$#files_R1_10KB; $h ++){
	print FILE "q1=",$files_R1_10KB[$h],"\n","q2=",$files_R2_10KB[$h],"\n";
}

# close the file.
close FILE;
exit 0;
