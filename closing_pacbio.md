# Rational

We obtained an assembly (scaffolds) from SOAPdenovo2 `SOAP_Mellotropicalis_BJE3652_all_libraries_big_library_scaffoldonly_47_61mers.scafSeq` (See the [Assembly file](https://github.com/caro46/Tetraploid_project/blob/master/Assembly.Rmd) to get the complete command performed). The main statistics (the complete statistics from `Quast` can be found on the same page) are encouraging (N50 = 12246, length > 3.5 Gb = expected size of the genome).
However, we have a lot of missing data (`N's per 100 kbp = 58459.19`) since we were unable to close the gaps using `Gapcloser` even selecting only very long scaffolds to reduce the running time. This for me can make a re-scaffolding step harder. So closing some gaps seem necessary at this point.

Because of the very long time and huge resources needed, we need to find another way to close the gaps to improve the following step of re-scaffolding. The running time might be huge because of the high number of very long gaps. Using our pacbio reads directly at this step might make us saving time.The pacbio should be useful to close large gaps.

*Objective:* Go FASTER, we will correct the assembly later on. Pretty unrealistic the time a polyploid assembly is supposed to take...

# Softwares

I recently came accross `LR_Gapcloser` which on the [paper](https://academic.oup.com/gigascience/article/8/1/giy157/5256637) seems to be a good option. The authors describe the software as **"fast and efficient tool"**. The program can be downloaded from [github](https://github.com/CAFS-bioinformatics/LR_Gapcloser). The authors used both corrected and non-corrected long reads. Considering our limited coverage and some issues in the past  while testing other assemblers (ex. DBG2OLC), some sort of correcting looks like necessary, at least as a 1st try. In their paper, they used `MECAT`from [Xiao et al. 2017](https://www.nature.com/articles/nmeth.4432) that uses long reads to correct long reads ([Github page of MECAT](https://github.com/xiaochuanle/MECAT)). Again this sofware is supposed to be much faster than the other more used softwares.
