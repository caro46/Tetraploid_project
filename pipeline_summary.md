# Pipeline - subject to updates

In the Readme file, everything we have tried and run should be referenced. Here it will be a more detailed pipeline that are considering for the project (if we realised some assemblers or programs did give good/expected results they will not be mentioned here). 

Austin gave advice on some sofwares and also gave information about the pipeline he usually use for his assemblies. This pipeline should be a mixed of his advice/pipeline and own softwares I think would be good. 

## 1- Reads trimming

Trimming adapters ([trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic), [nxtrim](https://github.com/sequencing/NxTrim)), very low quality reads (trimmomatic, [jellyfish/quake](http://www.cbcb.umd.edu/software/quake/)). Nxtrim for the mate paired reads only (need to get rid of small insert size from the mate libraries, important to have a good estimate of insert size)

## 2- Meraculous assembly

[Meraculous](http://1ofdmq2n8tc36m6i46scovo2e.wpengine.netdna-cdn.com/wp-content/uploads/2014/12/Manual.pdf) is a paired-end/mate reads assembly that is supposed to be efficient and not require that much resources.

### a) k-mer estimate

Running jellyfish in an iterative way (multiple odd k-mer sizes) to get the histograms (frequency of k-mers at different coverage) for multiple k-mer values. Advice for meraculous being the main peak should be around 30X coverage. For diploid genomes: 1 peak at very low coverage=errors/contamination, 2 peaks=unique genomic kmers, high-depth peaks for repeat k-mers. For our tetraploid genome we at least need 2 good peaks (previously we were not able to visually see the other peaks).

### b) Meraculous runs

Using the approximate k-mer size from jellyfish, run the 1st two steps (`meraculous_import` and `meraculous_mercount`) to check if the k-mer value seems reasonable for the assembly (and check that all the files are in the good format to run without staying on queue for a while). Need to check on multiple files: `mercount.png` (check on the peaks similarly ad with jellyfish) and `kha.png` (helps identifying the different k-mer populations). Then run the all the steps after potentially corection the k-mer size and asking for more resources.

## 3- Hybrid assembly: DBG2OLC

[DBG2OLC](https://github.com/yechengxi/DBG2OLC) is a hybrid assembler that uses contigs from an short reads assembler (us: from meraculous if we get an OK assembly) and uncorrected long reads (us: pacbio in fasta format after using `dextract` on the `.bam` sequel files).

We will be using only reads >3kb (at least at the beginning):
```
./DBG2OLC k 17 KmerCovTh 2 MinLen 3000 MinOverlap 20 AdaptiveTh 0.0001 RemoveChimera 1 LD 0 Contigs meraculous_contigs f pacbio.fa 
```
Then using `LD 1` and changing values of `MinOverlap` and `AdaptiveTh` to get a better assembly.
Suggested tuning range by DBG2OLC author: ` MinOverlap 10-30, AdaptiveTh 0.001~0.01` (10x/20x PacBio data). 
 
## 4- Sequence consensus: `racon`?
The goal is to identify discrepancies between the reads and the "backbone" sequences.

Either `pbdagon` or `racon`.  `pbdagon` requires `blasr` which can be tricky to install (not in the softwares described on computecanada but present in sspace-longread folder...) and haven't been successful with `pbdagon` installation. `racon` is a fairly new program that seems to have promising results. I used it previously when trying the `minimap/miniasm/racon` pipeline. 

## 5- Decontamination of the assembly

The goal here is to identify everything that is not nuclear genome from our species.

### a) Mitochondrial genome

Can probably use [NovoPlasty](https://academic.oup.com/nar/article/45/4/e18/2290925) or [Norgal](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1927-y) or SIDR. [SIDR](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5709863/) seems especially interesting (machine learning decision based).

### b) UniVec, virus, bacteria, and archaea

Blasting the genomes against NCBI database and discarding scaffolds that match to these references. 

## 6- Rescaffolding 

[SSPACE](https://academic.oup.com/bioinformatics/article/27/4/578/197626) and [SSPACE-longRead](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4076250/) and/or [LINKS](http://www.bcgsc.ca/platform/bioinfo/software/links). I think 1st should use SSPACE and paired/mate reads, then SSPACE-longRead using corrected LORDEC long reads. Finally want to improve more using LORDEC long reads and SSPACE-longRead super-scaffolds with LINKS.  

## 7- Gap filling

[PBjelly](https://sourceforge.net/p/pb-jelly/wiki/Home/) uses long reads to filling the gaps. [GapCloser](http://soap.genomics.org.cn/soapdenovo.html) to close more gaps using short/medium insert size paired ends reads.

## 8- Error correction and polishing: [arrow](https://github.com/PacificBiosciences/GenomicConsensus)

## 9- Superscaffolds using *X .tropicalis*

Using python script made with Andrew's help. Will use results from alignment created with `nucmer`.
