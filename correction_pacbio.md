# Reason

Pacbio reads are longer but have a higher error rates ([Koren et al., 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3707490/)) than NGS reads. The type of errors is also different: indels vs SNP.

From [Miller et al. 2017](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-017-3927-8):

* Because most of the errors in PacBio sequencing are random, PacBio reads can be corrected by alignment to other PacBio reads, given sufficient coverage redundancy. *

# Hybrid approach: 
Main idea: 

The short reads have smaller error rates and so they will be used to correct the errors in the pacbio reads while keeping their long length.

## [LoRDEC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253826/)
Building a DBG graph with short reads then mapping the long reads onto it.

Input: Pacbio fasta or fastq. Do not take advantage of paired reads but can give multiple input files, for paired end need to give them as multiple files - comma separated (see the [FAQ](http://www.lirmm.fr/~rivals/lordec/FAQ/)).

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

# LoRDEC
Script to produce the metafile specifying the input short reads file can be found [here](https://github.com/caro46/Tetraploid_project/tree/master/some_scripts/make_input_lordec.pl) and I tried to run it on Cedar machine from computecanada using this [bash script](https://github.com/caro46/Tetraploid_project/tree/master/some_scripts/running_lordec.sh). Submitted using:
```
sbatch ~/project/cauretc/scripts/running_lordec.sh
squeue -u <user> #checking the statut
scancel <jobid> #to cancel the job
```
  
