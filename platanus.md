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

# [Platanus2/platanus_allee](http://platanus.bio.titech.ac.jp/platanus2)

De novo haplotype assembler. Trying it at the same time as Platanus. The paper has not been publishe yet but is under review and is already available [here](https://www.biorxiv.org/content/biorxiv/early/2018/06/15/347906.full.pdf).

In our case might give us better results that platanus1. Platanus2 accepts: paired end, mate pairs and pacbio long reads. If `platanus_allee assemble` runs fine without requiring too much ressources, I am considering to use all of our data with this software instead of using only it to construct the contigs and using them as input for DBG2OLC. 

Submitted 1st job on Nov.15 using: `--ntasks-per-node=1`, `--time=7-00:00:00`, `--mem=100G`.
