# Reason

Pacbio reads are longer but have a higher error rates ([Koren et al., 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3707490/)) than NGS reads. The type of errors is also different: indels vs SNP.

From [Miller et al. 2017](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-017-3927-8):

*Because most of the errors in PacBio sequencing are random, PacBio reads can be corrected by alignment to other PacBio reads, given sufficient coverage redundancy.*

# Hybrid approach: 
Main idea: 

The short reads have smaller error rates and so they will be used to correct the errors in the pacbio reads while keeping their long length.

## [LoRDEC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253826/)
Building a DBG graph with short reads then mapping the long reads onto it.

Input: Pacbio fasta or fastq. Do not take advantage of paired reads but can give multiple input files, for paired end need to give them as multiple files - comma separated (see the [FAQ](http://www.lirmm.fr/~rivals/lordec/FAQ/)).

## [halc](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1610-3)

[Github page](https://github.com/lanl001/halc)

We might want to consider this option too. It uses `LoRDEC` and `blasr` (in *ordinary* mode). It uses information from contigs to correct long reads, and also original short reads to correct short repeats. 2 modes *ordinary* and *repeat-free*, in the *repeat-free* one it filters very small alignments (< 300 bp) in the graph construction step. I'll try it in the *repeat-free* mode since on the other mode I am pretty sure it should use more memory than LoRDEC. 

# Only Pacbio approach:
Using 1 type of data. Sequencing biaised of Illumina (GC..).

## [LoRMA](https://academic.oup.com/bioinformatics/article/33/6/799/2525585/Accurate-self-correction-of-errors-in-long-reads)
Uses LoRDEC. Bruijn graphs with increasing length of k-mers using only the pacbio reads then a step of polishing.

Input: Pacbio fasta.

## Jabba ([github](https://github.com/biointec/jabba), [paper Miclotte et al. 2016](https://almob.biomedcentral.com/articles/10.1186/s13015-016-0075-7))

Keeping in mind for "big" genome: increasing the suffix array sparseness with `-e [value, default=1]`. See a discussion [here](https://github.com/biointec/jabba/issues/3).

Input: Pacbio fasta or Fastq.

## Ectools ([github repository](https://github.com/jgurtowski/ectools)).

# Comments

Tried to install LoRMA without success. Not sure why, good `g++`, `cmake`, `make` versions and LoRDEC was installed (the path for the binaries were specified in the `lorma.sh` script). From the [FAQ](https://www.lirmm.fr/~rivals/lordec/FAQ/#orgheadline9) of LoRDEC, LoRMA uses more memory and times so I think we should try LoRDEC for now on a subset of the data.

*Can LoRDEC perform also self-correction?
Not directly. However, LoRDEC has a companion software called LoRMA, that uses LoRDEC and performs self-correction with long reads. LoRMA does not need short reads, but use only long reads.
For the same amount of data, LoRMA requires more computing resources and more time.*

[Here](https://hal.inria.fr/hal-01463694/document) is a comparison of some programs. The best one for us seems to be LoRDEC since in theory it doesn't use that much memory, handle multiple input files and have pretty good results and the running time doesn't sound unreasonable. For jabba for example, we will probably need to concatenate a subset/all of the files to run it

# Statistics about reads

Using `BBMap_37.36`
```
 /work/cauretc/programs/bbmap/readlength.sh in=BJE3652.all.subreads.nolengthlimit.q30.fastq.gz out=histogram.txt max=100000
```
```
#Reads: 5278721
#Bases: 40727210029
#Max:   81750
#Min:   50
#Avg:   7715.4
#Median:        6370
#Mode:  180
#Std_Dev:       6156.3
```

To estimate quickly the coverage:

```
C = R x L / G = 5278721 x 7715.4 / 3 100 000 000 ~ 13X
```
Where C is physical coverage, R is the total number of reads, L is (average) read length, and G is the genome size (we used the size from the *X.laevis* genome, but `allpaths` estimated the genome size ~2.8Gb which would mean ~14.5X coverage).

# LoRDEC

```
Usage:
	  lordec-correct 
	     [--trials <number of target k-mers>]
	     [--branch <maximum number of branches to explore>]
	     [--errorrate <maximum error rate>]
	     [--threads <number of threads>] 
             [-S <out statistics file>] 
             [-m <max memory size>]  
             [-a <max abundance>]
	     -2 <FASTA/Q files> -k <k-mer size> -s <abundance threshold> -i <PacBio FASTA file> -o <output file corrected reads>
	
	Typical command:	
	    lordec-correct -2 illumina.fasta -k 19 -s 3 -i pacbio.fasta -o pacbio-corrected.fasta
```

Script to produce the metafile specifying the input short reads file can be found [here](https://github.com/caro46/Tetraploid_project/tree/master/some_scripts/make_input_lordec.pl) and I tried to run it on Cedar machine from computecanada using this [bash script](https://github.com/caro46/Tetraploid_project/tree/master/some_scripts/running_lordec.sh). Submitted using:
```
sbatch ~/project/cauretc/scripts/running_lordec.sh
squeue -u <user> #checking the statut
scancel <jobid> #to cancel the job
```
sbash [options](https://slurm.schedmd.com/sbatch.html). 

From LoRDEC [FAQ](http://www.lirmm.fr/%7Erivals/lordec/FAQ/#orgheadline34), can take a while to run, but how long...

*As each LR is processed one by one, obviously the number of LR, and even more their cumulated lengths, are major determinants of the running time.
Previous to the correction, LoRDEC builds or loads the de Bruijn graph of the short reads. This can also take some time if the SR set is huge.* 

Sooooo I might stay on queue forever...probably need to speak about that we BE.

OK so I tried on a subset for a shorter time and ended with an error so I killed all the LOrDEC jobs and tried again on subset using `-a 100000`. Started running this morning (22/01 - was on queue for ~4days). Seem to run fine. Will see where the the job ends to better estimate the ressources needed. 

## On multiple pacbio files
Trying to run for 2 days limit:
```
/home/cauretc/project/cauretc/programs/LoRDEC-0.5.3-Source/build/tools/lordec-correct -2 /home/cauretc/scratch/lordec_analysis/input_metalist_small_med_lib.txt -k 19 -s 3 -a 100000 -i /home/cauretc/scratch/pacbio_mellotrop/multi_files/Sequel.RunS005.001.BJE3652.fasta.gz -o /home/cauretc/scratch/lordec_analysis/small_med_lib/BJE3652.RunS005.001.subreads.lordec_small_med_lib.fasta &> /home/cauretc/scratch/lordec_analysis/small_med_lib/lordec.log
```
Started 4 of them since the queue seems to be long but I need the ressources I asked and maybe more so we need to wait (jan.23/18). The output name has been change depending on the input name (i.e. `Sequel.RunS005.002.BJE3652.fasta.gz` -> `BJE3652.RunS005.002.subreads.lordec_small_med_lib.fasta`, `lordec2.log`)

Ended with this error message (25/01/2018):
```
/var/spool/slurmd/job4435309/slurm_script: line 15: 25010 Segmentation fault      (core dumped) /home/cauretc/project/cauretc/programs/LoRDEC-0.5.3-Source/build/tools/lordec-correct -2 /home/cauretc/scratch/lordec_analysis/input_metalist_small_med_lib.txt -k 19 -s 3 -a 100000 -i /home/cauretc/scratch/pacbio_mellotrop/multi_files/Sequel.RunS005.001.BJE3652.fasta.gz -o /home/cauretc/scratch/lordec_analysis/small_med_lib/BJE3652.RunS005.001.subreads.lordec_small_med_lib.fasta &>/home/cauretc/scratch/lordec_analysis/small_med_lib/lordec.log
slurmstepd: error: Exceeded step memory limit at some point.
```
A lot of intermediary outputs - deleted (25/01)

31/01/18: lauching another run to see if it can go through, testing on `Sequel.RunS005.001.BJE3652.fasta.gz` only for now, using `-s 5` in the `canu` command and `#SBATCH --time=48:00:00` and `#SBATCH --mem=100gb` in the submission script.

5/02/18: not enough time to finish. But enough to produce the `.h5` file that we we can use as an input and gain some time (`input_metalist_small_med_lib.h5` instead of `input_metalist_small_med_lib.txt`). Submitted again, this time using the `.h5` and on the 2nd pacbio file (submitted when the other was still running): for 4 days, 3 threats. 

# HALC

```
usage: runHALC.py [-h] [-o ORDINARY] [-r] [-b BOUNDARY] [-a] [-c COVERAGE]
                  [-w WIDTH] [-k KMER] [-t THREADS] [-l]
                  long_read.fa contig.fa
```

```
/home/cauretc/project/cauretc/programs/halc/runHALC.py -r -l /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads.fasta /home/cauretc/scratch/final.assembly.fasta 
```
On Jan.31/18, all sharcnet systems were done (do not include computecanada server), so I couldn't copy the assembly yet. Sounds like the inputs need to 1st be unzipped (when run it needs to make sure I can unzip it without bothering the other runs).

OK so on Feb.1, still issue with sharcnet, but had a copy on the computer of the Allpaths assembly so submitted the run today for `#SBATCH --time=24:00:00` and `#SBATCH --mem=100gb`. I updated the command above. According to the `squeue`, should start running tomorrow (Feb.2) early morning so will see if it is working.

Note Feb.5/18:

During the weekend, job failed because `-t/--threads` is required, resubmitted again.
Failed again because of `blasr` missing (thought it was optional).
Some trouble to install `blasr` (what worked on Iqaluk, doesn't here, probably some modules missing)- eneded up dopying from sharcnet. To see how it was installed, see the pitchfork part of the [DBG2OLC page](https://github.com/caro46/Tetraploid_project/blob/master/DBG2OLC_run.md#installing-blasr-for-consensus-step). The "normal" `hdf5` module cannot be loaded with the `gcc/6.4.0` which is necessary for the `pitchfork` version of blasr. I can install `hdf5` again but not necessary and still other issues/conflicts when tried to do so... The following commands was the last try that didn't work before copying the `blasr.5.3.` installed on sharcnet. People always have various issues when trying to install `blasr`.
```
module load nixpkgs/16.09  gcc/6.4.0 
module load hdf5-mpi
git clone git://github.com/PacificBiosciences/pitchfork
make init
make
make blasr
```

