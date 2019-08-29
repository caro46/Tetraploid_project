# Rational

Reconsidering the previous pipeline.

Before we wanted to try to get a better contigs assembly to be able to use a chimerical approach for scaffolding. However the attempts have not been successful with some newer assemblies being half or less from the expected genome size. Another major issue is the resources required for a "successful" run and the stability of the server I am using... i.e. issues when need to run with a lot of memory requirement for a long time.
A more realistic approach is too use the assemblies we were previously able to make and improve them. We have multiple SOAP de novo assemblies that have a size without gap close to the expected genome size (3-3.5 Gb), with N50 ~ 10-11 kb. The main issue with these assemblies is the amount of missing data.

# Using other assemblies to close the gaps - [FGAP](https://github.com/pirovc/fgap)

We got multiple assemblies usinf SOAPdenovo2 (1 kmer approach, multiple kmer approach, mate libraries only for scaffolding, ...) that had promising statistics. 
Since the weaknesses from the different assemblies and potentially different "good"/"bad" regions and scaffolds, we are going to try to close some gaps from 1 assembly using the information from other assemblies.

If the statistics improve then we can use the pacbio reads (using the same program) to close more gaps.

```
./run_fgap.sh <MCR installation folder> -d <draft file> -a "<dataset(s) file(s)>" [parameters]
```

## Installing and Running

The installation and running steps are clearly explained on the [github page](https://github.com/pirovc/fgap) of the program. It uses `blast` so we will need to load `blast` when submitting the job on Graham.

Not sure I like the idea of using `blast` to close gaps but I guess it should be faster and if we have some incorrect/discrepancies we should be able to correct them later on... On their paper, they had less missasseblies than GapCloser (but other papers highlighted the limitations of GapCloser - however it is easy to use and uses somewhat reasonable resources).

## Using only scaffolds `> 1kb`

Most likely very small scaffolds are hard to assemble because of repeats and potentially contain more errors. They are potentially going to make whatever program used running longer without giving information useful at this step. For now we are going to focuse on scaffolds of size `=> 1kb`.
```
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' [multi_lines_fasta].scafSeq >[1_line_fasta].fa
awk '!/^>/ { next } { getline seq } length(seq) >= 1000 { print $0 "\n" seq }' [1_line_fasta].fa >[1_line_fasta_1kb].fa

```
After this step running `Quast`. Whichever assemblies is the "best" after removing small scaffolds will be used as the "draft file", the other assemblies will all be used as "datasets files". The Allpaths assembly we previously used for finding the sex determining region will not be used since most likely the scaffolds are chimerical from both subgenomes.

# Using Pacbio to close more large gaps

Either using `fgap` if promising from step mentioned before or `LR_Gapcloser`. `Pbjelly` can also be considered, however it seems to require more resources (memory + time). `Pbjelly` is older and has been used in other assembly projects in other labs while the 2 first programs are younger (only 1 year appart with `fgap` but `fgap` has been updated more recently and seems to be faster).

## [LR_Gapcloser](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6324547/)
