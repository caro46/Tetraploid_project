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

## Summary report
Note:

- By default `--min-contig` option is set to 500bp (similar to abyss I think).
- very complete description in the [manual](http://quast.bioinf.spbau.ru/manual.html#sec3)
```
# contigs (≥ x bp) is total number of contigs of length ≥ x bp. Not affected by the --min-contig parameter (see section 2.4).

Total length (≥ x bp) is the total number of bases in contigs of length ≥ x bp. Not affected by the --min-contig parameter (see section 2.4).

All remaining metrics are computed for contigs that exceed the threshold specified with --min-contig (see section 2.4, default is 500 bp).

# contigs is the total number of contigs in the assembly.

Largest contig is the length of the longest contig in the assembly.

Total length is the total number of bases in the assembly.

Reference length is the total number of bases in the reference genome.

GC (%) is the total number of G and C nucleotides in the assembly, divided by the total length of the assembly.

Reference GC (%) is the percentage of G and C nucleotides in the reference genome.

N50 is the length for which the collection of all contigs of that length or longer covers at least half an assembly.

NG50 is the length for which the collection of all contigs of that length or longer covers at least half the reference genome.
This metric is computed only if the reference genome is provided.

N75 and NG75 are defined similarly to N50 but with 75 % instead of 50 %.

L50 (L75, LG50, LG75) is the number of contigs equal to or longer than N50 (N75, NG50, NG75)
In other words, L50, for example, is the minimal number of contigs that cover half the assembly.
```
## Results
Preliminary results from the screen:
```
Running Basic statistics processor...
  Contig files:
    1  final.assembly
    2  SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq
  Calculating N50 and L50...
    1  final.assembly, N50 = 1920, L50 = 76909, Total length = 607138367, GC % = 38.79, # N's per 100 kbp =  6522.06
    2  SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq, N50 = 11981, L50 = 110537, Total length = 4749065556, GC % = 38.96, # N's per 100 kbp =  71236.08
Done.
```
Wahoo this program is cool. OK so for now we have confirmation that the SOAP assembly is better (or not.. Need to speak with Ben boss to decide which one is the best).
