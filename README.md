# Tetraploid_project

## Quick introduction

*X. mellotropicalis* is a tetraploid species, which half of its genome is closely related to the diploid *X. tropicalis*. We are interesting in building his genome (as the 1st part of various analysis) and defining his sex-determining system. The commands performed can be found in this project folder. Not all of them were successfull and their outputs (example poor assemblies,...) won't necessarly be included in further studies.

A working pipeline can be found [there](https://github.com/caro46/Tetraploid_project/blob/master/pipeline_summary.md) explaining the workflow.

## 1- [To start:](https://github.com/caro46/Tetraploid_project/blob/master/quality_tests.Rmd)

- quality test (fastqc)
- quality improvement (trimommatic & Quake)
 
## 2- Assembly:

We have different types of data: short illumina reads from diverse insert size (total `.gz` files size ~202G) and Pacbio reads. The 2 kinds of reads have different types of errors, from [Salmela et al. 2017](https://academic.oup.com/bioinformatics/article/33/6/799/2525585/Accurate-self-correction-of-errors-in-long-reads):

*most research of short read error correction has concentrated on mismatches, the dominant error type in Illumina data, whereas in long reads indels are more common.*

In order to tackle the issue of assembling a tetraploid species (duplications, repeat regions), we will try to use the advantages of both types of data mainly the accuracy of short reads and continuity of long reads.

Different methods exist: doing multiple assemblies and then try to merge them (idea being different assemblies will have different good regions), using the long reads to order a short reads contigs assembly without correcting the long reads (DBG2OLC), correcting the long reads using or not the short reads for the correction. Only short reads assemblies should be more accurate but more fragmented, whereas only long reads should be continuous but with (many) more errors, hybrid assemblers tries to use both qualities (accuracy + continuity) of the different data types. The work idea is to make various assemblies using the different datasets and then "combine" them, separate the 2 subgenomes, a last step would be to map the short reads back to the genome for a last correction steps.

The Sequel Pacbio reads we have are in the new `.bam` format. Most of the available softwares for Pacbio reads were implemented before the change. Gene Meyers discussed how to convert the `.bam` raw file into a `.fastq` like files or `.fasta` files on his [blog](https://dazzlerblog.wordpress.com/command-guides/dextractor-command-guide/) to then be able to run the assemblers. See [here](https://github.com/caro46/Tetraploid_project/blob/master/dextractor.md) for the commands performed.

I put more information about the Pacbio reads [there](https://github.com/caro46/Tetraploid_project/blob/master/correction_pacbio.md#statistics-about-reads): size, number of reads, estimated coverage.

### Only short reads 

- [SOAPdenovo](https://github.com/caro46/Tetraploid_project/blob/master/Assembly.Rmd)
- [Allpaths](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_Allpaths.Rmd)
- [Meraculous](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_meraculous.md)

### Hybrid

- [DBG2OLC](https://github.com/caro46/Tetraploid_project/blob/master/DBG2OLC_run.md)

### Only long reads

- [Canu and Falcon](https://github.com/caro46/Tetraploid_project/blob/master/canu_assembly.md): mostly notes for now (oct.31/17)

- [minimap/miniasm/racon](https://github.com/caro46/Tetraploid_project/blob/master/miniasm_assembly.Rmd) association

*Comment Jan31/18:* Only Pacbio assembly requires too much memory so except if `miniasm` uses less than expected by `canu`, we will continue trying the idea of merging "only short reads" and "only pacbio" assemblies. Most likely the most feasible option would be correcting the pacbio and uses it for scaffolding contigs from allpaths... (using SOAPdenovo maybe).

### [Correcting Pacbio reads](https://github.com/caro46/Tetraploid_project/blob/master/correction_pacbio.md)

- LoRDEC

- HALC

## 3- Assembly improvement

- [GapCloser](https://github.com/caro46/Tetraploid_project/blob/master/gap_closer.Rmd#soapdenovo2-gapcloser)

- Quiver

- Pilon 

## 4- [Pseudomolecules](https://github.com/caro46/Tetraploid_project/blob/master/pseudomolecules.md)

## 5- Assembly quality assessment: [Quast](https://github.com/caro46/Tetraploid_project/blob/master/Quality_assembly_assesment.md)

## 6- Potentially later analysis

Ian publication on polyploid plants is interesting and we should probably speak with him for some analysis ([Moghe et al. 2014](https://www.researchgate.net/publication/262787251_Consequences_of_Whole-Genome_Triplication_as_Revealed_by_Comparative_Genomic_Analyses_of_the_Wild_Radish_Raphanus_raphanistrum_and_Three_Other_Brassicaceae_Species)).
