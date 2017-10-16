## Assemblies

- [x] SOAP de novo
- [x] Allpaths
- [x] DBG2OLC backbone
- [ ] blast a "good" genome against 
- [ ] script to make pseudomolecules - started, still need some improvement 


## GBS

- [x] make backbone assembly as supercontigs
- follow the same pipeline as for *Hymenochirus* and *Pipa* to identify potential sex-linked regions
- [x] mapping GBS data against supercontigs 
- [x] GATK - running, ploidy as diploid since allotetraploid (2 different diploid subgenomes, from different ancestral species) and also [see](http://gatkforums.broadinstitute.org/gatk/discussion/1214/can-i-use-gatk-on-non-diploid-organisms), GATK only do 1 type of ploidy for the whole genome creating issues for sex-determining regions (advice to do with polyploid and diploid). 

## Repeats

Tried to run RepeatMasker for months on the DBG2OLC assembly (with the scaffolds previously "groupedinto supercontigs" to try to make it faster [see](https://github.com/caro46/Tetraploid_project/blob/master/DBG2OLC_run.md)) but on Oct.16 (started on Jul.7) still on `Cycle2` so decided to kill the run.
