# [Platanus](https://genome.cshlp.org/content/24/8/1384) 

## Introduction

We tried multiple times to use Allpaths for our tetraploid assembly ( [1st_try](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_Allpaths.Rmd), [2nd_try](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_allpaths_2.md) ) without success because of the tetraploid nature of our genome and ressources requirement of the program.

Platanus seemed a new promising program to use because it has been used in multiple polyploid assembly project. The finger millet project ([Hatakeyama et al. 2018](https://academic.oup.com/dnaresearch/article/25/1/39/4103403)) is especially interesting since their first steps are similar to the ones we are planning to take.

Platanus output always works as input for [DBG2OLC](https://github.com/yechengxi/DBG2OLC), which is a good sign considering I did not have luck with SOAPdenovo2.

## Commands

Platanus as a limit for the number of input files so I merged all the forward and all the reverse separately, for each library independently before running platanus:

```
cat BenEvansBJE3652_180bp_Library_*R1*_trim_paired.cor.fastq.gz >merged_by_lib/180bp_Library_1_R1.fastq.gz
cat BenEvansBJE3652_180bp_Library_*R2*_trim_paired.cor.fastq.gz >merged_by_lib/180bp_Library_1_R2.fastq.gz
cat Ben_Evans_BJE3652_180_BP_Library_2nd_Sequence_*R1*_trim_paired.fastq.gz >merged_by_lib/180bp_Library_2_R1.fastq.gz
cat Ben_Evans_BJE3652_180_BP_Library_2nd_Sequence_*R2*_trim_paired.fastq.gz >merged_by_lib/180bp_Library_2_R2.fastq.gz
cat BenEvansBJE3652_400bp_Library_*R1*_trim_paired.cor.fastq.gz >merged_by_lib/400bp_Library_R1.fastq.gz
cat BenEvansBJE3652_400bp_Library_*R2*_trim_paired.cor.fastq.gz >merged_by_lib/400bp_Library_R2.fastq.gz
cat BenEvansBJE3652_1000bp_*R1*_trim_paired.cor.fastq.gz >merged_by_lib/1000bp_Library_R1.fastq.gz
cat BenEvansBJE3652_1000bp_*R2*_trim_paired.cor.fastq.gz >merged_by_lib/1000bp_Library_R2.fastq.gz

```
Making contigs with platanus
```
module load nixpkgs/16.09  gcc/7.3.0 platanus/1.2.4 
#platanus assemble -f FILE1 [FILE2 ...] -o STR -t INT
platanus assemble -f 180bp_Library_1_R1.fastq.gz 180bp_Library_1_R2.fastq.gz 180bp_Library_2_R1.fastq.gz 180bp_Library_2_R2.fastq.gz 400bp_Library_R1.fastq.gz 400bp_Library_R2.fastq.gz 1000bp_Library_R1.fastq.gz 1000bp_Library_R2.fastq.gz -o Xmellotropicalis_platanus -t 4 2>platanuslog
```
Error when trying to input `fastq.gz`, not recognized as a fastq/fasta file. Tried using `<(zcat file.gz)`, error from graham:
```
/var/spool/slurmd/job9236033/slurm_script: line 17: syntax error near unexpected token `('
```
Need enable `process substitution` by setting the posix previous to my command: `set +o posix`. Thanks to this [tip](http://onetipperday.sterding.com/2013/12/syntax-error-near-unexpected-token.html).

# [Platanus2/platanus_allee](http://platanus.bio.titech.ac.jp/platanus2)

De novo haplotype assembler. Trying it at the same time as Platanus. The paper has not been publishe yet but is under review and is already available [here](https://www.biorxiv.org/content/biorxiv/early/2018/06/15/347906.full.pdf).

In our case might give us better results that platanus1. Platanus2 accepts: paired end, mate pairs and pacbio long reads. If `platanus_allee assemble` runs fine without requiring too much ressources, I am considering to use all of our data with this software instead of using only it to construct the contigs and using them as input for DBG2OLC. 

Submitted 1st job on Nov.15 using: `--ntasks-per-node=1`, `--time=7-00:00:00`, `--mem=100G`. As for the platanus1 command: need to set posix and the use `<(zcat file.gz)` (started on Nov.15). 

Submitted a big job on Nov.22 `--ntasks-per-node=10 --time=28-00:00:00 --mem=200G` to make sure we have enough ressources to finish the job. In the platanus command specified `-m 200`. Took ~5 days to go through the queue on Graham, but failed less than 2 hours after the job starts with this error message

```
K = 32, saving kmers from reads...
Error(5): Error, Kmer distribution exception!!
Kmer distribution cannot be caluculated correctly.
```
Apparently some people had a similar issue with platanus (for [example](https://www.biostars.org/p/185344/)). Suggestions about `gcc` version and kmer size. Maybe due to not enough coverage at the default kmer size (`32`), trying with `-k 21`. 
Smaller kmer size seems to fix the issue. Ready to run for a longer time.
```
K = 21, saving kmers from reads...
AVE_READ_LEN=92.9672

KMER_EXTENSION:
K=21, KMER_COVERAGE=73.6015 (>= 3), COVERAGE_CUTOFF=3
K=41, KMER_COVERAGE=53.4276, COVERAGE_CUTOFF=3, PROB_SPLIT=10e-inf
K=61, KMER_COVERAGE=33.2538, COVERAGE_CUTOFF=3, PROB_SPLIT=10e-10.351
K=66, KMER_COVERAGE=28.2103, COVERAGE_CUTOFF=2, PROB_SPLIT=10e-10.0079
K=67, KMER_COVERAGE=27.2016, COVERAGE_CUTOFF=2, PROB_SPLIT=10e-10.0622
loading kmers...
```  
