#!/usr/bin/perl


###Arguments from commandline
my $path_to_data=$ARGV[0];
my $path_to_genome=$ARGV[1];
my $path_to_output=$ARGV[2];
my $genome=$ARGV[3];
my @chromosomes = @ARGV[4..$#ARGV];

###Other parameters
my $commandline;
my $status;

my @file_R1;
my @file_R2;

foreach my $chrom (@chromosomes) {
	print $chrom,"\n";
	@file_R1 = glob($path_to_data."*".$chrom."\/".$chrom."*R1*.fastq.gz");
	@file_R2 = glob($path_to_data."*".$chrom."\/".$chrom."*R2*.fastq.gz");
#	print @file_R1[0]," ",@file_R2[0],"\n";
	#bwa mem 
	$commandline = "bwa mem ".$path_to_genome.$genome." ".@file_R1[0]." ".@file_R2[0]." \> ".$path_to_output.$chrom.".sam";
	$status = system($commandline);
	# Samtools : sam to bam
	$commandline="samtools view -bt ".$path_to_genome.$genome." -o ".$path_to_output.$chrom.".bam ".$path_to_output.$chrom.".sam";
	$status = system($commandline);
	# Samtools : bam to _sorted.bam
	$commandline="samtools sort ".$path_to_output.$chrom.".bam -o ".$path_to_output.$chrom."_sorted.bam";
	$status = system($commandline);
	# Stats
	$commandline="pileup.sh in=".$path_to_output.$chrom.".sam out=".$path_to_output.$chrom."coverage_".$chrom;
	$status = system($commandline);
	$commandline="samtools flagstat ".$path_to_output.$chrom."_sorted.bam \> ".$path_to_output.$chrom."_flagstats.log";
	$status = system($commandline);
}

#perl ~/project/cauretc/scripts/bwa_arg.pl /home/cauretc/projects/rrg-ben/cauretc/Mellotrop_single_chr/2014_mellotriop_single_chr/ /home/cauretc/projects/rrg-ben/cauretc/reference_genomes/ /home/cauretc/projects/rrg-ben/cauretc/Mellotrop_single_chr/bwa/all_chrom/ Xtropicalis_v9_repeatMasked_HARD_MASK_chr_only.fa 1A 1B 2A 2B 3A 3B 4A 4B 5A 5B 6A 6B 7A 8A 8B 9A 9B 10A 10B
#wa mem /home/cauretc/projects/rrg-ben/cauretc/reference_genomes/Xtropicalis_v9_repeatMasked_HARD_MASK_chr_only.fa /home/cauretc/projects/rrg-ben/cauretc/Mellotrop_single_chr/trimmed_data/Sample_Ben-Evans-WGA3-7B/7B_R1_trim_paired.fastq.gz /home/cauretc/projects/rrg-ben/cauretc/Mellotrop_single_chr/trimmed_data/Sample_Ben-Evans-WGA3-7B/7B_R2_trim_paired.fastq.gz >/home/cauretc/projects/rrg-ben/cauretc/Mellotrop_single_chr/bwa/mellotropicalis_7B.sam
