# Quast

## [Install](http://quast.bioinf.spbau.ru/manual.html#sec1)
```
wget https://downloads.sourceforge.net/project/quast/quast-4.5.tar.gz
tar -xzf quast-4.5.tar.gz
cd quast-4.5
./setup.py install_full
```
## Running
Comparing allpath assembly with best SOAPdenovo assembly
```
./quast.py /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.assembly.fasta /work/ben/Mellotropicalis_corrected_data/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq
```
I didn't specify the output location. So the results will be:
```
/work/ben/quast-4.5/quast_results/results_2017_04_25_13_07_23
```
