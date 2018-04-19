#!/usr/bin/perl

use strict;
use warnings;

#path to nxtrim
my $path_to_nxtrim = "/home/cauretc/project/cauretc/programs/NxTrim/";

#mate pair libraries
##1st step
my @files_R1_6000_1;
my @files_R2_6000_1;
my @files_R1_6000_2;
my @files_R2_6000_2;
my @files_R1_10000;
my @files_R2_10000;
##2nd step
my @files_R1_mpet_6kb;
my @files_R2_mpet_6kb;
my @files_R1_mpet_6kb_2;
my @files_R2_mpet_6kb_2;
my @files_R1_mpet_10kb;
my @files_R2_mpet_10kb;
##3rd step
my @files_mpet_link_6kb;
my @files_mpet_link_6kb_2;
my @files_mpet_link_10kb;


my $path_to_data;
$path_to_data = "/home/cauretc/scratch/HiSeq_data/long_insert_nonxtrimmed/";

#output
my $path_to_output = "/home/cauretc/scratch/HiSeq_data/nxtrimmed/";

#other commands
my $commandline;
my $status;
my $y;

#6kb-1

@files_R1_6000_1 = glob($path_to_data."Ben-Evans-BJE3652-6kb_NoIndex_L002_R1_*_trim_paired.cor.fastq.gz");
@files_R2_6000_1 = glob($path_to_data."Ben-Evans-BJE3652-6kb_NoIndex_L002_R2_*_trim_paired.cor.fastq.gz");
#the number of files R1 and R2 should be the same (paired)
for ($y=0; $y<=$#files_R1_6000_1; $y ++) {
	$commandline = $path_to_nxtrim."nxtrim -s 0.9 --separate -1 ".$files_R1_6000_1[$y]." -2 ".$files_R2_6000_1[$y]." -O ".$path_to_output."6kb_1_nxtrimmed_".$y;
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."6kb_1_nxtrimmed_".$y."_R1.mp.fastq.gz ".$path_to_output."6kb_1_nxtrimmed_".$y."_R1.unknown.fastq.gz > ".$path_to_output."6kb_1_nxtrimmed_".$y."_R1.mp_unknown.fastq.gz";
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."6kb_1_nxtrimmed_".$y."_R2.mp.fastq.gz ".$path_to_output."6kb_1_nxtrimmed_".$y."_R2.unknown.fastq.gz > ".$path_to_output."6kb_1_nxtrimmed_".$y."_R2.mp_unknown.fastq.gz";
	$status = system($commandline);
}

print "Done with nxtrimming for 6kb - 1st lib \n";

@files_R1_6000_2 = glob($path_to_data."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex_L001_R1_*_trim_paired.cor.fastq.gz");
@files_R2_6000_2 = glob($path_to_data."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex_L001_R2_*_trim_paired.cor.fastq.gz");
for ($y=0; $y<=$#files_R1_6000_2; $y ++) {
        $commandline = $path_to_nxtrim."nxtrim -s 0.9 --separate -1 ".$files_R1_6000_2[$y]." -2 ".$files_R2_6000_2[$y]." -O ".$path_to_output."6kb_2_nxtrimmed_".$y;
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."6kb_2_nxtrimmed_".$y."_R1.mp.fastq.gz ".$path_to_output."6kb_2_nxtrimmed_".$y."_R1.unknown.fastq.gz > ".$path_to_output."6kb_2_nxtrimmed_".$y."_R1.mp_unknown.fastq.gz";
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."6kb_2_nxtrimmed_".$y."_R2.mp.fastq.gz ".$path_to_output."6kb_2_nxtrimmed_".$y."_R2.unknown.fastq.gz > ".$path_to_output."6kb_2_nxtrimmed_".$y."_R2.mp_unknown.fastq.gz";
	$status = system($commandline);
}
print "Done with nxtrimming for 6kb - 2nd lib \n";

@files_R1_10000 = glob($path_to_data."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex_L001_R1_*_trim_paired.cor.fastq.gz");
@files_R2_10000 = glob($path_to_data."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex_L001_R2_*_trim_paired.cor.fastq.gz");
for ($y=0; $y<=$#files_R1_10000; $y ++) {
	$commandline = $path_to_nxtrim."nxtrim -s 0.9 --separate -1 ".$files_R1_10000[$y]." -2 ".$files_R2_10000[$y]." -O ".$path_to_output."10kb_nxtrimmed_".$y;
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."10kb_nxtrimmed_".$y."_R1.mp.fastq.gz ".$path_to_output."10kb_nxtrimmed_".$y."_R1.unknown.fastq.gz > ".$path_to_output."10kb_nxtrimmed_".$y."_R1.mp_unknown.fastq.gz";
	$status = system($commandline);
	$commandline = "cat ".$path_to_output."10kb_nxtrimmed_".$y."_R2.mp.fastq.gz ".$path_to_output."10kb_nxtrimmed_".$y."_R2.unknown.fastq.gz > ".$path_to_output."10kb_nxtrimmed_".$y."_R2.mp_unknown.fastq.gz";
	$status = system($commandline);
}
print "Done with nxtrimming to fasta for 10kb \n";
