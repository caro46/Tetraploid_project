# Tetraploid_project

## 1- [To start:](https://github.com/caro46/Tetraploid_project/blob/master/quality_tests.Rmd)

- quality test (fastqc)
- quality improvement (trimommatic & Quake)
 
## 2- Assembly:

We have different types of data: short illumina reads from diverse insert size and Pacbio reads. The 2 kinds of reads have different types of errors, from [Salmela et al. 2017](https://academic.oup.com/bioinformatics/article/33/6/799/2525585/Accurate-self-correction-of-errors-in-long-reads):

*most research of short read error correction has concentrated on mismatches, the dominant error type in Illumina data, whereas in long reads indels are more common.*

In order to tackle the issue of assembling a tetraploid species (duplications, repeat regions), we will try to use the advantages of both types of data mainly the accuracy of short reads and continuity of long reads.

Different methods exist: doing multiple assemblies and then try to merge them (idea being different assemblies will have different good regions), using the long reads to order a short reads contigs assembly without correcting the long reads (DBG2OLC), correcting the long reads using or not the short reads for the correction. Only short reads assemblies should be more accurate but more fragmented, whereas only long reads should be continuous but with (many) more errors, hybrid assemblers tries to use both qualities (accuracy + continuity) of the different data types. The work idea is to make various assemblies using the different datasets and then "combine" them, separate the 2 subgenomes, a last step would be to map the short reads back to the genome for a last correction steps.

### Only short reads 

- [SOAPdenovo](https://github.com/caro46/Tetraploid_project/blob/master/Assembly.Rmd)
- [Allpaths](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_Allpaths.Rmd)

### Hybrid

- [DBG2OLC](https://github.com/caro46/Tetraploid_project/blob/master/DBG2OLC_run.md)

### Only long reads

- [Canu and Falcon](https://github.com/caro46/Tetraploid_project/blob/master/canu_assembly.md): mostly notes for now (oct.31/17)

## 3- [Pseudomolecules](https://github.com/caro46/Tetraploid_project/blob/master/pseudomolecules.md)

## 4- Assembly quality assessment: [Quast](https://github.com/caro46/Tetraploid_project/blob/master/Quality_assembly_assesment.md)
