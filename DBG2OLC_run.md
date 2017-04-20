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
bamtools merge -list subreadBamFiles.fofn -out subreads.bam
```
### Convert bam to fastq
```
$ bamtools filter -length ">1000" -tag "rq:>0.85" -in m.subreads.bam | bamtools convert -format fastq -out m.subreads.filterRQ.fastq
```
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f m.subreads.filterRQ.fastq >DBG2OLC_LOG.txt
```
