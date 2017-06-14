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
Suggestions from Ben: convert each bam into a fastq and then merge the fastq. To convert using bamtools as suggested [here](https://github.com/PacificBiosciences/PacBioFileFormats/wiki/BAM-recipes).
```perl
#!/usr/bin/perl

use warnings;
use strict;

# This script will transform bam files into fastq files  

my $status;
my $commandline;
my @files;

my $path = "/scratch/ben/mellotropicalis_pacbio_temp/";
my $path_to_bamtools = "/work/ben/bamtools-master/bin/";
@files = glob($path."*.bam");
my $x;
my @files_no_extension;
my @temp;

foreach(@files){
#       print $_,"\n";
    @temp=split(".bam",$_);
    push(@files_no_extension,$temp[0]);
}

for($x =0; $x <= $#files_no_extension; $x ++){
#print $files_no_extension[$x],"\n";    
$commandline = $path_to_bamtools."bamtools filter -length \">1000\" -tag \"rq:>0.85\" -in ".$files_no_extension[$x].".bam | ".$path_to_bamtools."bamtools convert -format fastq -out ".$files_no_extension[$x].".filterRQ.fastq ";
$status = system($commandline);

}

```
The `-tag \"rq:>0.85\"` option filtered everything. Need to speak with Ben boss to see if we should apply another filter. 

Concatenate fastq files
```
zcat /scratch/ben/mellotropicalis_pacbio_temp/*BJE3652.subreads.1000bpmin.fastq.gz | gzip >/scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.1000bpmin.fastq.gz
```
```
/work/ben/bamtools-master/bin/bamtools filter -length ">1000" -tag "rq:>0.85" -in BJE3652.all.subreads.bam | bamtools convert -format fastq -out BJE3652.all.subreads.filterRQ.fastq
```
Ok so looks weird. We will try with 
```
/work/ben/samtools-1.2/samtools bam2fq /scratch/ben/mellotropicalis_pacbio_temp/Sequel.RunS005.001.BJE3652.subreads.bam > Sequel.RunS005.001.BJE3652.subreads.fastq 
```
Obtained the same `!!!!` everywhere so should be normal I guess. Someone else also had the [issue](http://seqanswers.com/forums/showthread.php?p=203328). According to someone who responded to this issue: `Sequel data does not have a per base QV value for raw reads`.

DBG2OLC does not rely on the quality estimate but more on the overlapping of the reads so I think we are good for a first try. DBG2OLC warns about errors from correcting tools and suggest if we want to use correcting tools to compare the results with and without corrections on the pacbio reads.

Maybe should consider using [dextract](https://dazzlerblog.wordpress.com/) and use fasta format. From [github](https://github.com/thegenemyers/DEXTRACTOR). See some explanation about some [updates](https://dazzlerblog.wordpress.com/2016/11/14/moving-to-the-sequel/).
### Run
#### Using all the long reads (>1000bp)
##### Run1
The program is located `/work/ben/Mellotropicalis_corrected_data/DBG2OLC-master`. Run from the program directory
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.1000bpmin.fastq.gz >DBG2OLC_LOG_26April.txt
```
Ended up with a `Bus error`.
###### Bus error
- Recording the memory usage 
```
top -b -p 43780 -d 1800 >>top_DBG2OLC.out
```
- Bug in the program?
```
gdb DBG2OLC
GNU gdb (GDB) Red Hat Enterprise Linux (7.2-90.el6)
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/DBG2OLC...(no debugging symbols found)...done.
(gdb) run
Starting program: /work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/DBG2OLC 
 Example command: 
For third-gen sequencing: DBG2OLC LD1 0 Contigs contig.fa k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.005 f reads_file1.fq/fa f reads_file2.fq/fa
For sec-gen sequencing: DBG2OLC LD1 0 Contigs contig.fa k 31 KmerCovTh 0 MinOverlap 50 PathCovTh 1 f reads_file1.fq/fa f reads_file2.fq/fa
Parameters:
MinLen: min read length for a read to be used.
Contigs:  contig file to be used.
k: k-mer size.
LD: load compressed reads information. You can set to 1 if you have run the algorithm for one round and just want to fine tune the following parameters.
PARAMETERS THAT ARE CRITICAL FOR THE PERFORMANCE:
If you have high coverage, set large values to these parameters.
KmerCovTh: k-mer matching threshold for each solid contig. (suggest 2-10)
MinOverlap: min matching k-mers for each two reads. (suggest 10-150)
AdaptiveTh: [Specific for third-gen sequencing] adaptive k-mer threshold for each solid contig. (suggest 0.001-0.02)
PathCovTh: [Specific for Illumina sequencing] occurence threshold for a compressed read. (suggest 1-3)
Author: Chengxi Ye cxy@umd.edu.
last update: Jun 11, 2015.
Loading contigs.
0 k-mers in round 1.
0 k-mers in round 2.
Scoring method: 3
Match method: 1
Loading long read index
0 selected reads.
0 reads loaded.

Program received signal SIGFPE, Arithmetic exception.
0x0000000000434586 in LoadLongReadIndexWithMerging(std::vector<std::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, reads_info*, contigs_info*) ()
(gdb) backtrace
#0  0x0000000000434586 in LoadLongReadIndexWithMerging(std::vector<std::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, reads_info*, contigs_info*) ()
#1  0x000000000043cbdb in main ()
(gdb) where
#0  0x0000000000434586 in LoadLongReadIndexWithMerging(std::vector<std::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, reads_info*, contigs_info*) ()
#1  0x000000000043cbdb in main ()
(gdb) q
```
I compiled as suggested by the author (no error message) but just in case if the run dies again, I will try using the pre-compiled version:
```
./work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/compiled/DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.1000bpmin.fastq.gz >DBG2OLC_LOG_May.txt
```
Hum you are able to use fasta or fastq for the illumina data but sounds like only fasta for Pacbio. Using fasta files produced with [dextractor](https://github.com/caro46/Tetraploid_project/blob/master/dextractor.md). On wobbie (faster) and without redirecting the output (run forever)

Potential issues: (Iqaluk a little bit slow), sounds like cannot read `gz` files, not clear if OK `fastq` for Pacbio (some people got issues with that on some discussion groups), parameters too high?.
```
gunzip -c /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta.gz | ./../DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f -

zcat /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.1000bpmin.fastq.gz | ./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f -
```
The program does not load the file... Try do find a file `-`?!
```
./../DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f <(zcat /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta.gz)
```
```
Example command:
For third-gen sequencing: DBG2OLC LD1 0 Contigs contig.fa k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.005 f reads_file1.fq/fa f reads_file2.fq/fa
For sec-gen sequencing: DBG2OLC LD1 0 Contigs contig.fa k 31 KmerCovTh 0 MinOverlap 50 PathCovTh 1 f reads_file1.fq/fa f reads_file2.fq/fa
Parameters:
MinLen: min read length for a read to be used.
Contigs:  contig file to be used.
k: k-mer size.
LD: load compressed reads information. You can set to 1 if you have run the algorithm for one round and just want to fine tune the following parameters.
PARAMETERS THAT ARE CRITICAL FOR THE PERFORMANCE:
If you have high coverage, set large values to these parameters.
KmerCovTh: k-mer matching threshold for each solid contig. (suggest 2-10)
MinOverlap: min matching k-mers for each two reads. (suggest 10-150)
AdaptiveTh: [Specific for third-gen sequencing] adaptive k-mer threshold for each solid contig. (suggest 0.001-0.02)
PathCovTh: [Specific for Illumina sequencing] occurence threshold for a compressed read. (suggest 1-3)
Author: Chengxi Ye cxy@umd.edu.
last update: Jun 11, 2015.
Loading contigs.
306603019 k-mers in round 1.
256223141 k-mers in round 2.
Analyzing reads...
File1: /dev/fd/63
Long reads indexed.
Total Kmers: 40565115140
Matching Unique Kmers: 4263200439
Compression time: 20598 secs.
Scoring method: 3
Match method: 2
Loading long read index
Loading file: ReadsInfoFrom_63
0 reads loaded.
Floating point exception

```
Using small `AdaptiveTh` value
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.0001 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f <(zcat /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta.gz)
```
Try on unzipped
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.0001 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta LD 0
```
(previously tried `LD 0` and `LD1 0` when using zcat, it was not working either)
```
terminate called after throwing an instance of 'std::bad_alloc'
  what():  std::bad_alloc
Aborted
```
Seems a memory issue now. For large genomes in order to go faster, they advice to devide the pacbio into multiple batches, run with `LD 0` in the different batch directory and then put all the compressed reads in another directory and run with `LD 1`.

While looking at the produced files, looks like most of the reads did not pass the criteria, let's try 1st without `RemoveChimera 1`
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.0001 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta LD 0
```
Run done on `wobbie`. 
```
Extension warning.
error: complement_strY
```
This type of warning is due to the degenerated bases from the contigs. However the statistics are better than SOAP. Someone noticed a difference between the number of scaffolds from `backbone_raw.fasta` and `DBG2OLC_Consensus_info.txt` (see the [issue](https://github.com/yechengxi/DBG2OLC/issues/26)) that can be due to degenerated bases however it is not our case. We are running the consensus step to make sure we have an OK assembly.
```
grep -c ">" backbone_raw.fasta
197362

grep -c ">" DBG2OLC_Consensus_info.txt
197362
```

Divide into 2 files, advice form the author to go faster since the first steps are not multi-threats. Then `LD1` on a new directory containing all the compressed reads. Should potentially be used if we re-run the assembly to go faster on wobbie.
```
grep -c ">" /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta
#4982901
#4982901/2 = 2491450.5
awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%2491450==0){file=sprintf("myseq%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta
cat /scratch/ben/mellotropicalis_pacbio_temp/myseq2491450.fa /scratch/ben/mellotropicalis_pacbio_temp/myseq4982900.fa > /scratch/ben/mellotropicalis_pacbio_temp/Pacbio_2nd_half.fa
mv /scratch/ben/mellotropicalis_pacbio_temp/myseq0.fa /scratch/ben/mellotropicalis_pacbio_temp/Pacbio_1st_half.fa 
```
##### Parameters
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
##### Run2
Probably need to do a 2nd run using `LD1` to improve the assembly.

#### Only on the longest Pacbio reads
We should try running with only longer reads to see if it improves the assembly (fewer errors?).

#### Other programs in DBG2OLC package
From `/work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/compiled`
```
./AssemblyStatistics contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta
```
Produces 2 files in the assembly directory: `final.contigs.fastaStats_10k_5k_1k.txt` and `final.contigs.fastaStats.txt`
### Maybe usefull sites
- [Quiver](https://github.com/PacificBiosciences/GenomicConsensus/blob/master/doc/FAQ.rst)
- [HGAP](https://github.com/PacificBiosciences/Bioinformatics-Training/wiki/HGAP)
- correction tool [LoRMA](https://academic.oup.com/bioinformatics/article/33/6/799/2525585/Accurate-self-correction-of-errors-in-long-reads)
- [Guide](http://biorxiv.org/content/biorxiv/early/2015/10/16/029306.full.pdf) for de novo assembly using long reads (including chimerical assemblies)
- [Dealing with the new bam format from Sequel](https://dazzlerblog.wordpress.com/2016/11/14/moving-to-the-sequel/). For Quiver in particular. 

### Maybe future 
- [Falcon](http://www.nature.com/nmeth/journal/v13/n12/full/nmeth.4035.html) seems a promessing software to try... Uses long reads data to produce phased contigs.
- The [pineapple](https://academic.oup.com/dnaresearch/article/23/5/427/2236148/The-draft-genome-of-MD-2-pineapple-using-hybrid) workflow sounds pretty interesting
- The assembly of a [tree](http://www.g3journal.org/content/6/7/1835.full) also has an interesting workflow using Platanus software after transforming the Pacbio into illumina looks like reads (keeps the continuous advantage of the long reads).
- Their [pipeline](http://biorxiv.org/content/early/2016/05/19/029306.full.pdf+html) seems pretty good and similar to our start. They merged a hybrid assembly obtain with `DBG2OLC` and an only Pacbio assembly (obtained from Celera assembler) and then correct the assembly using Quiver. The advantage is Pacbio is more continuous but hybrid is more accurate. They first try merging the 2 assemblies using `minimus2` but it failed. They used a custom C++ script available on [github](https://github.com/mahulchak/quickmerge).
- People from Celera advice to use [Canu](http://canu.readthedocs.io/en/latest/quick-start.html) because Celera is not maintained anymore. Canu start by correcting the Pacbio reads.

### Installing blasr for consensus step
Using [example](https://github.com/PacificBiosciences/blasr/wiki/Step-by-step-blasr-installation-example)
```
module load gcc/7.1.0
TOP=$(pwd)
./configure.py --shared --sub --no-pbbam HDF5_INC=${TOP}/blasr_install/hdf5/hdf5-1.8.16-linux-centos6-x86_64-gcc447-shared/include/ HDF5_LIB=${TOP}/blasr_install/hdf5/hdf5-1.8.16-linux-centos6-x86_64-gcc447-shared/lib/
make configure-submodule
make build-submodule
make blasr
```
Not working whan tried the `make blasr`.

[Try](https://github.com/PacificBiosciences/blasr/wiki/Blasr-Installation-Qs-&-As)
```
git clone git://github.com/PacificBiosciences/blasr.git && cd blasr
git submodule update --init --remote
mkdir build && cd build
module load cmake/3.7.2
cmake .. && make

TOP=/work/ben/Mellotropicalis_corrected_data
cmake -DHDF5_LIBRARIES=${TOP}/blasr_install/hdf5/hdf5-1.8.16-linux-centos6-x86_64-gcc447-shared/lib/ -DHDF5_INCLUDE_DIRS=${TOP}/blasr_install/hdf5/hdf5-1.8.16-linux-centos6-x86_64-gcc447-shared/include/ .. && make

```
Still issue for compiling

Try what suggested [here](https://github.com/PacificBiosciences/blasr/issues/330)
```
make -j
make -j
```
Still not working. Try [pitchfork](https://github.com/PacificBiosciences/pitchfork/wiki)
```
git clone git://github.com/PacificBiosciences/pitchfork
cd pitchfork
make blasr 
```
```
./blasr --version
blasr	5.3.
```
#### Export PATHS (blasr and sparc)
```
#from `/work/cauretc/programs/blastr/pitchfork/deployment`
export LD_LIBRARY_PATH=$(pwd -P)/lib/:$(pwd -P)/include/
export PATH=/work/cauretc/programs/blastr/pitchfork/deployment/bin:$PATH
export PATH=/work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/compiled:$PATH
```
#### RUN
```
cat /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta BJE3652.all.subreads.fasta > ctg_pb.fasta

// we need to open a lot of files to distribute the above file into lots of smaller files

#ulimit -n unlimited #does not work on Sharcnet -> need to use split_reads_by_backbone_version 3

//run the consensus scripts

sh ./split_and_run_sparc.sh ../compiled/backbone_raw.fasta ../compiled/DBG2OLC_Consensus_info.txt /scratch/ben/mellotropicalis_pacbio_temp/ctg_pb.fasta ./consensus_dir 2 >cns_log.txt

sh ./split_and_run_sparc.path.sh ../compiled/backbone_raw.fasta ../compiled/DBG2OLC_Consensus_info.txt /scratch/ben/mellotropicalis_pacbio_temp/ctg_pb.fasta ./consensus_dir 2 3>cns_log.txt

```
Change the number of processors used in the script, default 64, set to 20.
Also needed to `chmod +x *.py` and `chmod -R 777 consensus_dir` and in the script `split_and_run_sparc.path.sh` need to add `./` to call the `python` script.

Some people seem to have issues with this step. For example [see](https://www.biostars.org/p/212727/) [or](https://github.com/yechengxi/DBG2OLC/issues/20) [or](https://github.com/yechengxi/DBG2OLC/issues/21). Maybe try [Racon](https://github.com/isovic/racon) as suggested on the biostars issue. Or we might just want to use `bwa` and just call the consensus if it keeps taking forever... 
### Checking chimera: blast
```
blastn -evalue 1e-80 -query /4/caroline/Xmellotropicalis/backbone_raw.fasta -db /4/caroline/tropicalis_genome/Xtropicalis_v9_repeatMasked_HARD_MASK_blastable -out /4/caroline/Xmellotropicalis/backbone_raw_xenTro9_hard_mask_e80 -outfmt 6 -max_target_seqs 2

grep "\<Backbone_3\>" /4/caroline/Xmellotropicalis/backbone_raw_xenTro9_hard_mask_e80
Backbone_3	Chr02	83.183	666	71	39	1745	2389	118306716	118307361	1.55e-159	571
Backbone_3	Chr02	82.370	709	72	49	10092	10769	118307362	118306676	2.01e-158	568
Backbone_3	Chr02	80.640	656	82	43	5877	6508	118306728	118307362	7.52e-128	466

grep "\<Backbone_6\>" /4/caroline/Xmellotropicalis/backbone_raw_xenTro9_hard_mask_e80
Backbone_6	Chr02	89.498	638	38	21	4316	4948	85935046	85934433	0.0	780
Backbone_6	Chr02	90.134	598	27	29	1	582	85934465	85935046	0.0	749
Backbone_6	Chr02	86.420	648	43	36	1476	2112	85935046	85934433	0.0	667
Backbone_6	Chr05	84.683	679	46	41	7226	7865	6025441	6024782	1.12e-175	625
Backbone_6	Chr05	86.863	373	20	27	12893	13250	6025441	6025083	4.45e-105	390
```
### Masking the repeats
```
tr '[:lower:]' '[:upper:]' </4/caroline/Xmellotropicalis/backbone_raw_supercontigs.fasta>/4/caroline/Xmellotropicalis/backbone_raw_supercontigs_upper_only.fasta
```
```
/usr/local/RepeatMasker/RepeatMasker -dir /4/caroline/Xmellotropicalis/ -qq -species "xenopus genus" -pa 5 -a /4/caroline/Xmellotropicalis/backbone_raw_supercontigs_upper_only.fasta
```
**Note:** considering what is found on the internet, neither [bwa](https://www.biostars.org/p/3232/) neither [blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp) care about upper/lower cases (both in the reference).

