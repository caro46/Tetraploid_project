# Rational

Reconsidering the previous pipeline.

Before we wanted to try to get a better contigs assembly to be able to use a chimerical approach for scaffolding. However the attempts have not been successful with some newer assemblies being half or less from the expected genome size. Another major issue is the resources required for a "successful" run and the stability of the server I am using... i.e. issues when need to run with a lot of memory requirement for a long time.
A more realistic approach is too use the assemblies we were previously able to make and improve them. We have multiple SOAP de novo assemblies that have a size without gap close to the expected genome size (3-3.5 Gb), with N50 ~ 10-11 kb. The main issue with these assemblies is the amount of missing data (about ~50% of the assemblies seem to just be missing data).

# Using other assemblies to close the gaps - [FGAP](https://github.com/pirovc/fgap)

We got multiple assemblies usinf SOAPdenovo2 (1 kmer approach, multiple kmer approach, mate libraries only for scaffolding, ...) that had promising statistics. 
Since the weaknesses from the different assemblies and potentially different "good"/"bad" regions and scaffolds, we are going to try to close some gaps from 1 assembly using the information from other assemblies.

If the statistics improve then we can use the pacbio reads (using the same program) to close more gaps.

```
./run_fgap.sh <MCR installation folder> -d <draft file> -a "<dataset(s) file(s)>" [parameters]
```

## Installing and Running

The installation and running steps are clearly explained on the [github page](https://github.com/pirovc/fgap) of the program. It uses `blast` so we will need to load `blast` when submitting the job on Graham.

```
wget https://sourceforge.net/projects/fgap/files/MCR_LINUX64b.tar.gz
wget https://sourceforge.net/projects/fgap/files/FGAP_1_8_1_LINUX64b.tar.gz
```
Cannot do this installation on Graham (version and other issues). Got the version hosted on github (same FGAP_1_8_1 version but octave way, not from compiled version ---downloaded on Sept. 18, 2019). On Graham need to do:
```
module load octave
module load gcc/7.3.0 blast+/2.7.1
octave fgap.m --help [or whatever command to be performed]
``` 

Not sure I like the idea of using `blast` to close gaps but I guess it should be faster and if we have some incorrect/discrepancies we should be able to correct them later on... On their paper, they had less missasseblies than GapCloser (but other papers highlighted the limitations of GapCloser - however it is easy to use and uses somewhat reasonable resources).

## Using only scaffolds `> 1kb`

Most likely very small scaffolds are hard to assemble because of repeats and potentially contain more errors. They are potentially going to make whatever program used running longer without giving information useful at this step. For now we are going to focuse on scaffolds of size `=> 1kb`.
```
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' [multi_lines_fasta].scafSeq >[1_line_fasta].fa
awk '!/^>/ { next } { getline seq } length(seq) >= 1000 { print $0 "\n" seq }' [1_line_fasta].fa >[1_line_fasta_1kb].fa

```
After this step running `Quast`. Whichever assemblies is the "best" after removing small scaffolds will be used as the "draft file", the other assemblies will all be used as "datasets files". The Allpaths assembly we previously used for finding the sex determining region will not be used since most likely the scaffolds are chimerical from both subgenomes.

Summary from Quast
```
Assembly        SOAP_Mellotropicalis_BJE3652_47_61mers_1kb      SOAP_Mellotropicalis_BJE3652_genome_43_to_63_1kb        SOAP_Mellotropicalis_BJE3652_genome_63_1kb      SOAP_Mellotropicalis_BJE3652_genome_63_memory_180together_1kb
# contigs (>= 0 bp)     511170  573881  565105  579442
# contigs (>= 1000 bp)  511170  573881  565105  579442
# contigs (>= 5000 bp)  263093  289786  263126  270094
# contigs (>= 10000 bp) 222708  254323  227154  238281
# contigs (>= 25000 bp) 27167   24508   26647   24512
# contigs (>= 50000 bp) 2446    1837    2715    2200
Total length (>= 0 bp)  4336244034      4655282122      4398088021      4454144208
Total length (>= 1000 bp)       4336244034      4655282122      4398088021      4454144208
Total length (>= 5000 bp)       3892871210      4144077097      3888205495      3925707624
Total length (>= 10000 bp)      3597974221      3886236631      3628135653      3695410069
Total length (>= 25000 bp)      970107622       855283468       963188667       873023424
Total length (>= 50000 bp)      149453914       110140193       169925946       135800053
# contigs       511170  573881  565105  579442
Largest contig  156266  113293  257805  147593
Total length    4336244034      4655282122      4398088021      4454144208
GC (%)  39.21   39.14   39.28   39.27
N50     12924   12061   12485   12122
N75     10302   10245   10247   10242
L50     91879   108828  94966   101470
L75     188623  215312  194607  203235
# N's per 100 kbp       61526.56        63814.39        61156.52        62043.82

```

## Trying run
To check if everything would run properly: 
- 1 day run, using 5 CPUS, 15gb memory ; specify `SOAP_Mellotropicalis_BJE3652_47_61mers_1kb.fa` as draft, the other as datasets.
```
octave --no-gui --eval 'fgap -d SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_47_61mers_1kb.fa -a "SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_genome_43_to_63_1kb.fa,SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_genome_63_1kb.fa,SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_genome_63_memory_180together_1kb.fa" -t 5 -o SOAP_assemblies/fgap_results/fgap_out'
``` 
- 1 day run, 64 CPUS (2 nodes, 8 tasks/node, 4 cpus/task) to compare with the results from their paper (run 1 human chr. in some h using this CPU number) ; only `SOAP_Mellotropicalis_BJE3652_genome_63_1kb.fa` as dataset

*Ccl:* No issue detected with the program. BJE suggested to only focus on pacbio data, and divide the draft assembly in multiple smaller subset.

## Subseting the draft genome
```
module load bbmap/38.44
partition.sh in=SOAP_Mellotropicalis_BJE3652_47_61mers_1kb.fa out=47_61mers_subset_%.fasta ways=[number_of_expected_files]
```

## Only scaffolds `> 50kb`
```
awk '!/^>/ { next } { getline seq } length(seq) >= 50000 { print $0 "\n" seq }' SOAP_Mellotropicalis_BJE3652_all_libraries_big_library_scaffoldonly_47_61mers_1line.scafSeq >SOAP_Mellotropicalis_BJE3652_47_61mers_50kb.fa
```
Parameters of the run: 3D, 64CPUS, default parameters for `fgap` (graham - no waiting on sept. 26).

# Using Pacbio to close more large gaps

Either using `fgap` if promising from step mentioned before or `LR_Gapcloser`. `Pbjelly` can also be considered, however it seems to require more resources (memory + time). `Pbjelly` is older and has been used in other assembly projects in other labs while the 2 first programs are younger (only 1 year appart with `fgap` but `fgap` has been updated more recently and seems to be faster).

## [LR_Gapcloser](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6324547/)

# Using small amount of data with `gapcloser`

Focusing on `SOAP_Mellotropicalis_BJE3652_47_61mers_1kb` since highest N50.
I want to see if a subset of the data we have: the first 180bp sequencing (`BenEvansBJE3652_180bp_Library_GTTTCG_L001_*`), 400bp (`BenEvansBJE3652_400bp_Library_GTTTCG_L002*`), 1kb (`BenEvansBJE3652_1000bp_Library_GTTTCG_L003*`) can still reduce the amount of missing data.

Since most of the time and memory used before was with the huge amount of `180_BP_Library_2nd_Sequence`, we should have no issue with memory nor time. The advantage is also only high quality short insert size will be used (bad quality for `180_BP_Library_2nd_Sequence` but huge amount of data).

