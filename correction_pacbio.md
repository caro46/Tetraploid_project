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

Keeping in mind for "big" genome: increasing the suffix array sparseness with `-e [value, default=`]`. See a discussion [here](https://github.com/biointec/jabba/issues/3).

Input: Pacbio fasta or Fastq.

## Ectools ([github repository](https://github.com/jgurtowski/ectools)).
