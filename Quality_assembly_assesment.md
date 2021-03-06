# [Quast](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3624806/)

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
On the contigs:
```
./quast.py /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.contigs.fasta /work/ben/Mellotropicalis_corrected_data/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.contig -o /work/ben/quast-4.5/quast_results/contig_allpath_soap
```
Try using `--scaffolds` to see if change the results 
```
./quast.py --scaffolds /work/ben/Mellotropicalis_corrected_data/allpaths/data/Run1_no_180_2/ASSEMBLIES/test/final.assembly.fasta /work/ben/Mellotropicalis_corrected_data/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq -o /work/ben/quast-4.5/quast_results/scaffolds_option_allpath_SOAP
```
DBG2OLC - backbone
```
./quast.py --scaffolds /work/ben/Mellotropicalis_corrected_data/DBG2OLC-master/compiled/backbone_raw.fasta -o /work/ben/quast-4.5/quast_results/DBG2OLC
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
About scaffolds
```
--scaffolds (or -s)
The assemblies are scaffolds (rather than contigs). QUAST will add split versions of assemblies to the comparison (named <assembly_name>_broken). Assemblies are split by continuous fragments of N's of length ≥ 10. If broken version is equal to the original assembly (i.e. nothing was split) it is not included in the comparison. Scaffold gap size misassemblies are enabled in this case (see section 3.1.2 for details and --scaffold-gap-max-size for setting maximum gap length). 
```
From the FAQ of the [manual](http://quast.bioinf.spbau.ru/manual.html)
```
 Q6. What does "broken" version of an assembly refer to while assessing scaffolds' quality (--scaffolds option)?

Actually, the difference between "broken" and original assembly (scaffolds) is very simple. QUAST splits input fasta by continuous fragments of N's of length ≥ 10 and call this a "_broken" assembly. By doing this we try to reconstruct "contigs" which were used for construction of the scaffolds. After that, user can compare results for real scaffolds and "reconstructed contigs" and find out whether scaffolding step was useful or not.

If you have both contigs.fasta and scaffolds.fasta it is better to specify both files to QUAST and don't set --scaffolds option. The comparison of real contigs vs real scaffolds is more honest and informative than scaffolds vs scaffolds_broken.

To sum up, you should use --scaffolds option if you don't have original file with contigs but want to compare your scaffolds with it. Also note, that --scaffolds option implies QUAST to search for scaffold gap size misassemblies. 
```
If I understand correctly the goal of the broken scaffolds is to come back on a contig version. Comparing both (scaffold and broken) will help to see how efficient the scaffolding step was. But basically since we directly have the contigs, we do not actually need the broken statistics (do not need to run the `--scaffolds` option but we could have directly run contigs and scaffolds all together).
## Results
### Scaffolds
#### Preliminary results from the screen:
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

#### report.txt
```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).
Suggestion: all assemblies contain continuous fragments of N's of length >= 10 bp. You may consider rerunning QUAST using --scaffolds (-s) option!

Assembly                    final.assembly  SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq
# contigs (>= 0 bp)         320227          2654558                                              
# contigs (>= 1000 bp)      286034          541958                                               
# contigs (>= 5000 bp)      19292           275558                                               
# contigs (>= 10000 bp)     1887            246283                                               
# contigs (>= 25000 bp)     6               25021                                                
# contigs (>= 50000 bp)     0               1980                                                 
Total length (>= 0 bp)      607138367       5073922146                                           
Total length (>= 1000 bp)   574372221       4530331488                                           
Total length (>= 5000 bp)   136492195       4058112063                                           
Total length (>= 10000 bp)  23462309        3838894191                                           
Total length (>= 25000 bp)  159305          882707243                                            
Total length (>= 50000 bp)  0               117897095                                            
# contigs                   320227          848955                                               
Largest contig              30521           172751                                               
Total length                607138367       4749065556                                           
GC (%)                      38.79           38.96                                                
N50                         1920            11981                                                
N75                         1243            10258                                                
L50                         76909           110537                                               
L75                         178611          218933                                               
# N's per 100 kbp           6522.06         71236.08                
```
#### Scaffold option (broken assembly)
```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).

Assembly                    final.assembly  final.assembly_broken  SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq  SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq_broken
# contigs (>= 0 bp)         320227          335910                 2654558                                                152163                                                      
# contigs (>= 1000 bp)      286034          299944                 541958                                                 11345                                                       
# contigs (>= 5000 bp)      19292           7640                   275558                                                 29                                                          
# contigs (>= 10000 bp)     1887            384                    246283                                                 4                                                           
# contigs (>= 25000 bp)     6               0                      25021                                                  0                                                           
# contigs (>= 50000 bp)     0               0                      1980                                                   0                                                           
Total length (>= 0 bp)      607138367       567787029              5073922146                                             104404063                                                   
Total length (>= 1000 bp)   574372221       533328147              4530331488                                             15168652                                                    
Total length (>= 5000 bp)   136492195       50674050               4058112063                                             221257                                                      
Total length (>= 10000 bp)  23462309        4495845                3838894191                                             56492                                                       
Total length (>= 25000 bp)  159305          0                      882707243                                              0                                                           
Total length (>= 50000 bp)  0               0                      117897095                                              0                                                           
# contigs                   320227          335910                 848955                                                 152163                                                      
Largest contig              30521           20653                  172751                                                 21623                                                       
Total length                607138367       567787029              4749065556                                             104404063                                                   
GC (%)                      38.79           38.79                  38.96                                                  40.40                                                       
N50                         1920            1653                   11981                                                  653                                                         
N75                         1243            1198                   10258                                                  561                                                         
L50                         76909           98862                  110537                                                 59351                                                       
L75                         178611          201382                 218933                                                 102706                                                      
# N's per 100 kbp           6522.06         43.86                  71236.08                                               698.01                                
```
### Contigs
```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).
Suggestion: assembly final.contigs contains continuous fragments of N's of length >= 10 bp. You may consider rerunning QUAST using --scaffolds (-s) option!

Assembly                    final.contigs  SOAP_Mellotropicalis_BJE3652_genome_33_memory
# contigs (>= 0 bp)         373937         84463003                                     
# contigs (>= 1000 bp)      335094         6551                                         
# contigs (>= 5000 bp)      1467           24                                           
# contigs (>= 10000 bp)     19             4                                            
# contigs (>= 25000 bp)     0              0                                            
# contigs (>= 50000 bp)     0              0                                            
Total length (>= 0 bp)      567751381      5161961770                                   
Total length (>= 1000 bp)   530543843      8927010                                      
Total length (>= 5000 bp)   8930438        189770                                       
Total length (>= 10000 bp)  218409         56492                                        
Total length (>= 25000 bp)  0              0                                            
Total length (>= 50000 bp)  0              0                                            
# contigs                   373931         108805                                       
Largest contig              14519          21623                                        
Total length                567748982      72788492                                     
GC (%)                      38.79          40.76                                        
N50                         1502           634                                          
N75                         1170           553                                          
L50                         130224         43154                                        
L75                         238067         74067                                        
# N's per 100 kbp           37.15          0.00     
```
## Conclusion
### Scaffolds
Most of the statistics seem to say that SOAP assembly is better. However it has a lot of scaffolds. A concern is that maybe SOAP has a bunch of scaffolds because it does not know what to do with them so maybe they are not that accurate. So we will try the chimerical assembly (Illumina + Pacbio) with both draft assemblies.
### Contigs
Allpaths seems better for the contigs.

### DBG2OLC
```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).

Assembly                    backbone_raw
# contigs (>= 0 bp)         197362      
# contigs (>= 1000 bp)      197309      
# contigs (>= 5000 bp)      191606      
# contigs (>= 10000 bp)     150797      
# contigs (>= 25000 bp)     17016       
# contigs (>= 50000 bp)     80          
Total length (>= 0 bp)      2998370399  
Total length (>= 1000 bp)   2998337103  
Total length (>= 5000 bp)   2976186620  
Total length (>= 10000 bp)  2654677125  
Total length (>= 25000 bp)  507668773   
Total length (>= 50000 bp)  4393666     
# contigs                   197345      
Largest contig              68950       
Total length                2998364467  
GC (%)                      42.63       
N50                         17259       
N75                         12914       
L50                         65494       
L75                         115454      
# N's per 100 kbp           0.03  
```
