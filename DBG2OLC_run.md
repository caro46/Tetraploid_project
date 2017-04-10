Downloaded from [here](https://github.com/yechengxi/DBG2OLC).

Installing 
```
unzip DBG2OLC-master.zip
cd DBG2OLC-master
g++ -O3 -o DBG2OLC *.cpp #need the BasicDataStructure.h, GraphConstruction.h, GraphSimplification.h, GraphSearch.h, BuildContigs.h
g++ -O3 -o SparseAssebmler *.cpp
g++ -O3 -o Sparc *.cpp
```
```
./DBG2OLC k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.01 RemoveChimera 1 Contigs /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta f 30x.fasta >DBG2OLC_LOG.txt
```
