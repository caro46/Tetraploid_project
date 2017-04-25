Downloaded from [here](https://github.com/yechengxi/DBG2OLC).

### Installing 
```
unzip DBG2OLC-master.zip
cd DBG2OLC-master
g++ -O3 -o DBG2OLC *.cpp #need the BasicDataStructure.h, GraphConstruction.h, GraphSimplification.h, GraphSearch.h, BuildContigs.h
g++ -O3 -o SparseAssebmler *.cpp
g++ -O3 -o Sparc *.cpp
```
Looks like we need to use the `subread` from Pacbio, not `scraps`:

*Data in a subreads.bam file should be analysis ready, meaning that all of the data present is expected to be useful for down-stream analyses. Any subreads for which we have strong evidence will not be useful (e.g. double-adapter inserts, single-molecule artifacts) should be excluded from this file and placed in scraps.bam as a Filtered with an SC tag of F.* [(pacbioformat)](http://pacbiofileformats.readthedocs.io/en/3.0/BAM.html)

### Merge the bam files into 1
```
bamtools merge BJE3652.all.subreads.bam Sequel.RunS005.*.BJE3652.subreads.bam

```
### Convert bam to fastq
Suggestions from Ben: convert each bam into a fastq and then merge the fastq.
```perl
#!/usr/bin/perl

use warnings;
use strict;

# This script will transform bam files into fastq files  

my $status;
my $commandline;
my @files;

my $path = "/scratch/ben/mellotropicalis_bam_temp/";
my $path_to_bamtools = "/work/ben/bamtools-master/bin/";
@files = glob($path."*.bam");
my $x;
my @files_no_extension;
my @temp;

foreach(@files){
    @temp=split(".bam",$_);
    push(@files_no_extension,$temp[0]);
}

foreach(@files_no_extension){
    
$commandline = $path_to_bamtools."bamtools filter -length \">1000\" -tag \"rq:>0.85\" -in ".$path.$files_no_extension.".bam | ".$path_to_bamtools."bamtools convert -format fastq -out ".$path.$files_no_extension.".filterRQ.fastq ";
$status = system($commandline);
}
```
```
/work/ben/bamtools-master/bin/bamtools filter -length ">1000" -tag "rq:>0.85" -in BJE3652.all.subreads.bam | bamtools convert -format fastq -out BJE3652.all.subreads.filterRQ.fastq
```
### Run
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f BJE3652.all.subreads.filterRQ.fastq >DBG2OLC_LOG.txt
```
For more details see [DBG2OLC github page](https://github.com/yechengxi/DBG2OLC)
```
There are three major parameters that affect the assembly quality:

M = matched k-mers between a contig and a long read.

AdaptiveTh: adaptive k-mer matching threshold. If M < AdaptiveTh* Contig_Length, this contig cannot be used as an anchor to the long read.

KmerCovTh: fixed k-mer matching threshold. If M < KmerCovTh, this contig cannot be used as an anchor to the long read.

MinOverlap: minimum overlap score between a pair of long reads. For each pair of long reads, an overlap score is calculated by aligning the compressed reads and score with the matching k-mers.

Suggested tuning range is provided here:

For 10x/20x PacBio data: KmerCovTh 2-5, MinOverlap 10-30, AdaptiveTh 0.001~0.01.

For 50x-100x PacBio data: KmerCovTh 2-10, MinOverlap 50-150, AdaptiveTh 0.01-0.02.
```
Some other less flexible or less important parameters:
```
k: k-mer size, 17 works well.

Contigs: the fasta contigs file from existing assembly.

MinLen: minimum read length.

RemoveChimera: remove chimeric reads in the dataset, suggest 1 if you have >10x coverage.

For high coverage data (100x), there are two other parameters:

ChimeraTh: default: 1, set to 2 if coverage is ~100x.

ContigTh: default: 1, set to 2 if coverage is ~100x.

These two are used in multiple alignment to remove problematic reads and false contig anchors. When we have high coverage, some more stringent conditions shall be applied as with the suggested parameters.
```
