#!/usr/bin/perl

use strict;
use warnings;

my $path_to_data;
$path_to_data = "/home/cauretc/scratch/HiSeq_data/";

#output
#my $path_to_output = "/home/cauretc/scratch/jellyfish/";
##only paired end / no mate
my $path_to_output = "/home/cauretc/scratch/jellyfish/onlypaired/";

#other commands
my $commandline;
my $status;
my @kmerlist;
my $kmer;

#count 
#@kmerlist = (31, 41, 51, 55, 59, 61, 65, 69, 71, 79, 81);
#did until 65. 2distinct peaks between 41 and 51
#@kmerlist = (43, 45, 47, 49, 53);
##only paired
@kmerlist = (41, 43, 45, 47, 49, 53, 55);
foreach $kmer (@kmerlist) {
#	$commandline = "zcat ".$path_to_data."*.fastq.gz | "."jellyfish count /dev/fd/0 -m ".$kmer." -s 100M -t 16 -C -o count_".$kmer;
#	$commandline = "gunzip -c ".$path_to_data."*.fastq.gz | jellyfish count /dev/fd/0 -m ".$kmer." -s 100M -t 8 -C -o count_".$kmer;
	$commandline = "gunzip -c ".$path_to_data."Ben*.fastq.gz | jellyfish count /dev/fd/0 -m ".$kmer." -s 100M -t 8 -C -o ".$path_to_output."count_".$kmer;
	$status = system($commandline);
	$commandline = "jellyfish histo ".$path_to_output."count_".$kmer." -o ".$path_to_output."hist_".$kmer."mer";
	$status = system($commandline);
	$commandline = "rm -f ".$path_to_output."count_".$kmer;
	$status = system($commandline);
	print "jellyfish histo done with kmer size: ".$kmer." \n";
}
