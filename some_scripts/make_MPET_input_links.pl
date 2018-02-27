#!/usr/bin/perl

use strict;
use warnings;

#path to links
my $path_to_link = "/home/cauretc/project/cauretc/programs/links_v1.8.5/";

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
$path_to_data = "/home/cauretc/scratch/HiSeq_data/";

#output
my $path_to_output = "/home/cauretc/scratch/scaffolding/mpet/";

#other commands
my $commandline;
my $status;
my $y;

#convert into fasta

@files_R1_6000_1 = glob($path_to_data."Ben-Evans-BJE3652-6kb_NoIndex_L002_R1_*_trim_paired.cor.fastq.gz");
@files_R2_6000_1 = glob($path_to_data."Ben-Evans-BJE3652-6kb_NoIndex_L002_R2_*_trim_paired.cor.fastq.gz");
#the number of files R1 and R2 should be the same (paired)
for ($y=0; $y<=$#files_R1_6000_1; $y ++) {
	$commandline = "gunzip -c ".$files_R1_6000_1[$y]." | perl -ne \'\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);\' >".$path_to_output."mpet_6kb_1_R1_".$y.".fa";
	$status = system($commandline);
	$commandline = "gunzip -c ".$files_R2_6000_1[$y]." | perl -ne \'\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);\' >".$path_to_output."mpet_6kb_1_R2_".$y.".fa";
	$status = system($commandline);
}

print "Done with converting to fasta for 6kb - 1st lib \n";

@files_R1_6000_2 = glob($path_to_data."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex_L001_R1_*_trim_paired.cor.fastq.gz");
@files_R2_6000_2 = glob($path_to_data."Ben_Evans_BJE3652_6kb_2nd_Sequencing_Run_NoIndex_L001_R2_*_trim_paired.cor.fastq.gz");
for ($y=0; $y<=$#files_R1_6000_2; $y ++) {
	$commandline = "gunzip -c ".$files_R1_6000_2[$y]." | perl -ne '\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);\' >".$path_to_output."mpet_6kb_2_R1_".$y.".fa";
	$status = system($commandline);
	$commandline = "gunzip -c ".$files_R2_6000_2[$y]." | perl -ne '\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);\' >".$path_to_output."mpet_6kb_2_R2_".$y.".fa";
	$status = system($commandline);
}
print "Done with converting to fasta for 6kb - 2nd lib \n";

@files_R1_10000 = glob($path_to_data."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex_L001_R1_*_trim_paired.cor.fastq.gz");
@files_R2_10000 = glob($path_to_data."Ben_Evans_BJE3652_10kb_Mate_Pair_Library_NoIndex_L001_R2_*_trim_paired.cor.fastq.gz");
for ($y=0; $y<=$#files_R1_10000; $y ++) {
	$commandline = "gunzip -c ".$files_R1_10000[$y]." | perl -ne \'\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);\' >".$path_to_output."mpet_10kb_R1_".$y.".fa";
	$status = system($commandline);
	$commandline = "gunzip -c ".$files_R2_10000[$y]." | perl -ne \'\$ct++;if(\$ct>4){\$ct=1;}print if(\$ct<3);' >".$path_to_output."mpet_10kb_R2_".$y.".fa";
	$status = system($commandline);
}

print "Done with converting to fasta for 10kb \n";

#make into link format (using script from tools directory)

@files_R1_mpet_6kb = glob($path_to_output."mpet_6kb_1_R1_*.fa");
@files_R2_mpet_6kb = glob($path_to_output."mpet_6kb_1_R2_*.fa");

for ($y=0; $y<=$#files_R1_mpet_6kb; $y ++) {
	$commandline = "perl ".$path_to_link."tools/makeMPETOutput2EQUALfiles.pl ".$files_R1_mpet_6kb[$y]." ".$files_R2_mpet_6kb[$y];
	$status = system($commandline);
}
print "Done with converting to link format for 6kb - 1st lib \n";

@files_R1_mpet_6kb_2 = glob($path_to_output."mpet_6kb_2_R1_*.fa");
@files_R2_mpet_6kb_2 = glob($path_to_output."mpet_6kb_2_R2_*.fa");

for ($y=0; $y<=$#files_R1_mpet_6kb_2; $y ++) {
	$commandline = "perl ".$path_to_link."tools/makeMPETOutput2EQUALfiles.pl ".$files_R1_mpet_6kb_2[$y]." ".$files_R2_mpet_6kb_2[$y];
	$status = system($commandline);
}
print "Done with converting to link format for 6kb - 2nd lib \n";

@files_R1_mpet_10kb = glob($path_to_output."mpet_10kb_R1_*.fa");
@files_R2_mpet_10kb = glob($path_to_output."mpet_10kb_R2_*.fa");

for ($y=0; $y<=$#files_R1_mpet_10kb; $y ++) {
	$commandline = "perl ".$path_to_link."tools/makeMPETOutput2EQUALfiles.pl ".$files_R1_mpet_10kb[$y]." ".$files_R2_mpet_10kb[$y];
	$status = system($commandline);
}
print "Done with converting to link format for 10kb \n";

#making the link fof file: the complete path is necessary
@files_mpet_link_6kb = glob($path_to_output."mpet_6kb_1_R1_*.fa_paired.fa");

for ($y=0; $y<=$#files_mpet_link_6kb; $y ++) {
	$commandline = "echo ".$files_mpet_link_6kb[$y]." >> mpet_6kb_1.fof";
	$status = system($commandline);
}
print "Done with making fof link input for 6kb - 1st lib \n";

@files_mpet_link_6kb_2 = glob($path_to_output."mpet_6kb_2_R1_*.fa_paired.fa");

for ($y=0; $y<=$#files_mpet_link_6kb_2; $y ++) {
	$commandline = "echo ".$files_mpet_link_6kb_2[$y]." >> mpet_6kb_2.fof";
	$status = system($commandline);
}
print "Done with making fof link input for 6kb - 2nd lib \n";

@files_mpet_link_10kb = glob($path_to_output."mpet_10kb_R1_*.fa_paired.fa");

for ($y=0; $y<=$#files_mpet_link_10kb; $y ++) {
	$commandline = "echo ".$files_mpet_link_10kb[$y]." >> mpet_10kb.fof";
	$status = system($commandline);
}
print "Done with making fof link input for 10kb \n";
