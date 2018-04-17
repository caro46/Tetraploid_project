# Meraculous

Austin adviced to give a try to Meraculous. With `cedar` and `graham` it should be ok to run.

To [download](https://jgi.doe.gov/data-and-tools/meraculous/), the [manual](http://1ofdmq2n8tc36m6i46scovo2e.wpengine.netdna-cdn.com/wp-content/uploads/2014/12/Manual.pdf), et the publication [Chapman et al. 2011](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0023501)

It is already installed on `cedar` and can be loaded like that
```
module load nixpkgs/16.09  gcc/4.8.5
module load meraculous/2.2.4
```
## kmer distribution - jellyfish

To choose the best k-mer size (from the manual): *As a rule of thumb, the largest value of k that yields a distinct peak at least ~30X is a reasonable choice*. We can either run the 1st step or Meraculous (`meraculous_mercount`) or just run `jellyfish` with different k-mer values ([script](https://github.com/caro46/Tetraploid_project/blob/master/some_scripts/jellyfish_iteratively.pl)) and check on the graph.

On 2/03, started jellyfish with k-mer values: `31, 41, 51, 55, 59, 61, 65, 69, 71, 79, 81`. (Depending on the preliminary results I can run other sizes within the best range). I'll put the script up on github when I'll be sure it is running without issue (in case we need to load more modules, libraries...).

Finished the 1st set of run after 1day (not enough time to run everybody, used 16 threats, 1node, 100G for 1day). 2 distinct peaks between kmers 41 and 51 (51 still able to distinguish them) and more than 30X for at least 1 of the peak. Running again using kmer size of `43, 45, 47, 49, 53` to try to be more accurate in the kmer choice. Run into issues when I tried to run again `Broken pipe`. So I redunced the number of threats and asked for more memory (8 threats and 200G of RAM) and it is running fine on 5/03/18. This time instead of `zcat`, I used `gunzip -c`.

6/03/18: 2nd set of kmers done. According to the kmer frequency plot, `49` seems the best: still 2 distinguishable peaks (1st at 16x, 2nd at 28X) or `47`: peaks at 16x and  30x. I'll try 1st with `mer_size 49`

To have exact coverage:
```R
hist49 <- my_data[my_data$Name_import_file=="hist_49mer",]
hist49[hist49$frequency==max(hist49$frequency),] #16x coverage for 1st peak
```
Not clear where is the 2nd peak by eyes (kinda platea before a drop) but examining the data, after 28x the frequency is only decreasing (between 23 and 28x up and down), so should correspond to the 2nd peak. 
```R
hist47 <- my_data[my_data$Name_import_file=="hist_47mer",]
hist47[hist47$frequency==max(hist47$frequency),] #16x
hist47_25x <- hist47[hist47$coverage>25,]
hist47_25x[hist47_25x$frequency==max(hist47_25x$frequency),] #30x
```
Previously I run on all the short reads we had (paired and mate). Since it is adviced to only used paired for contigs (and kmer value matters for contiging), to make sure about the kmer values, I am re-running jellyfish, using only short paired ends reads.

### Investigating errors vs genomic spikes
Selecting the 1st 100 lines of the `hist` files produced by `jellyfish` and print them in 1 file (filenames as the 1st column, contain kmer size)
```
awk 'FNR<101 {print FILENAME, $0}' *mer >hist_100lines_41to71mers
```

## Running

`mellotrop.config` contains the main information to run the program. We need to give an estimation of the insert size for each library and the stantard deviation. We don't have this information. Put I'll use a 10\% variance (NEED TO PUT SOME REF), i.e.: `180bp+/-20, 400bp+/-40, 1000bp+/-100, 6kb+/-600, 10kb+/-1000`. If the assembly is not good enough, we can map the reads to the assembly and try to have an estimate with `bwa` of the mean and standard deviation of insert size. The `.config` file gives information about the sequences files, the type of library (fragment or jumping), the insert size, its standard deviation, the mean size of the reads, the orientation (innies, outies), if the reads are used for contigs and/or scaffolding. Example of a [config file](https://github.com/caro46/Tetraploid_project/blob/master/files_examples/mellotrop.config).

Meraculous re-estimates the insert sizes during the run, so we should get a more accurate estimate.

8/03: submitted with less resources (`8` CPUS), using only the short insert size for the contigs part as suggested in the manual. When I did the 1st step run `-step meraculous_import`, no issue (so good format of the inputs), tried specified `-step meraculous_mercount` but it only rerun the import step. Should have submitted from inside the output directory of the other run and add a `-resume`

9/03: submitted another short run using `-stop meraculous_mercount` to run the 1st 2 steps and check on some outputs for k-mer choice. Also real run using this time all the short reads (including mate reads), in the contigs steps. We will see which assemblies between including or not the mate reads in contigs produce the most continuous contig assembly.

15/03: So all the runs started (at once...). Because of the number of files produced, the size and the computecanada limit I decided to stop the run that was using more cores because the benefit in time did not seem to be a lot. Gave different try to restart/resume if a run fails (waiting to make sure that I am not getting errors then I can focus on the real/complete run and delete the unecessary files - need to check on the plots first - since I resubmitted step by step, the other complete run is further in the step, since everything was running without issues I killed the job and deleted the `tryshort` for space purposes). So with `-resume`, any run that gets killed because of time (or others) can directly be re-started from wherever it stopped.

To resume:
```
run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_tryshort.config -dir /home/cauretc/scratch/meraculous/tryshort/mellotropicalis_meraculous_assembly_1st_step_2018-03-11_05h30m03s -resume
```
To restart: `-restart -start meraculous_mercount`, or 1 by 1 step `-step meraculous_mercount`. When using `resume` or `restart`: `-dir` is the run directory created when the 1st run started, you cannot use `-label` anymore. Rerun from within the run directory is not sufficient, `-dir` is necessary from the command submission.

16/03: The run with only paired end (180 bp -> 1000bp) to build the contigs, with value `49` for kmer failed. Seemed to be because meraculous couldn't find the `min-depth cutoff`. The `mercount.png` was produced: the "error" peak doesn't seem separated enough from the main "genomic" peak. Should try smaller kmer size (will see if we all the reads in contiging would work). `45` seemed to maybe a good value to try (according to previous jellyfish distribution plots). Issue with the slurm controller on the machine, need to submit the new run with smaller kmer whenever it is fixed. - working and submitted the same day

Restart the run using only paired reads in contiging and 49mers, using `min_depth_cutoff 4` in `.config` and submitted with `-restart -start meraculous_mercount`. (issue with the controller, the previous run was still "running" on controller while the program outputs were saying they finished unsucessfully `Stage meraculous_mercount failed` with also `slurmstepd: error: Unable to send job complete message: Unable to contact slurm controller (connect failure)` - I needed to force to cancel the job).

21/03: 

- only paired reads in contiging - 49mers: stopped because of time (4days allowed). Resubmitted using `-resume`.

- Run `fasta_stats` on the `contigs.fa` in the `meraculous_merblast` directory. The total length of the contigs, ~2.43Gb, is smaller than the estimated genome size, 3.1Gb-3.5Gb (but still bigger than the diploid *X. tropicalis* genome, 1.7Gb) - probably due to coverage and/or repeats. Hopefully the run with all the data (including the mate libraries) will be better. 

- Giving a try on this `contigs.fa` file (49mers - only paired reads in contiging) as input for DBG2OLC. 

27/03:

The run (short insert in contiging - 49mers) failed at the scaffolding `meraculous_ono`. Either because too small contigs/scaffolds to be able to use the bigger insert (highly possible). It can also be because of the libraries: used `nxtrim` on the mate libraries the put the reads by default in the Forward/Reverse direction, and kept the `MP/unknown` reads. `unknown` is described as *a library of read-pairs that are mostly large-insert mate-pair, but possibly contain a small proportion of paired end contaminants*, so I didn't put `[hasInnieArtifact] 1` since it is for *significant fraction of read pairs is in non-dominant orientation*... Maybe I should... 
```
2018/03/26 20:16:24 meraculous.pl main::run_meraculous_ono 2738> ERROR: None of the libraries in set 3 were deemed suitable for scaffolding!  Please check library parameters or consider excluding this set altogether.
```
I think it might be worth it to 1st have the run done for the "all libraries in contigs" run and/or the one with a smaller kmer size (45).

6/04:

On the 4/04 cancelled all the jobs (45 mers, all libraries in contigs). The failure of scaffolding from 49mers due to the small size of contigs. To be included in the scaffolding the insert of a library needs to be multiple times smaller than the contigs (the program estimates the actual insert size). Austin advice to include the `fallback_on_est_insert_size 1` that allows the library to be included anyways, just using the estimated insert size contained in the `.config` file. 

What is the most important in the choice of the k-mer size is to be able to distinguish eror and genomic peaks (more than having 2 genomic peaks). Idea being the worst thing for the assembly is the repeats: the smaller the kmer is the worse it is. Need to have the biggest kmer size for which you are able to distinguish a peak for error and a genomic peak.

Since the use of the `nxtrim` program identifies and separates reads with long insert and unusual short insert size, we can had these "new" pair end reads in our dataset and use them in the contig, scaffold and gap closure.

Launched a job to resume the 49mer run with the `fallback_on_est_insert_size 1`. Also launched another job using the `pe` from the long insert libraries (insert size estimate: 300bp, deviation: 30, reads size: 110) with a kmer size of 61. Launched a `jellyfish` run with different kmer size on the whole short insert libraries (including the new one from the long reads) to identify the biggest kmer size that allow to distinguish error from genomic peaks. 

9/04:

The run including the `pe` files from mate libraries (after `nxtrim`) failed with a format error. However no error detected using `fastQValidator`. Some reads however are very small. Using `bbduk.sh` from `bbmap/37.36`, selecting reads of length `>= 20bp`. The new mean reads length is `59.034669`, with `13553506` reads (from Austin, the insert size is usually ~300bp).
```
gunzip -c *.fastq.gz | awk 'BEGIN { t=0.0;sq=0.0; n=0;} ;NR%4==2 {n++;L=length($0);t+=L;sq+=L*L;}END{m=t/n;printf("total %d avg=%f stddev=%f\n",n,m,sq/n-m*m);}' - >stats_pe_reads.txt
``` 
A run without these `pe` files and a kmer size of 61 started.

10/04:

From Jellyfish results (done on 7/04), using `pe` from actual paired end libraries and mate paired: the best kmer value seems to be 51, with a min depth = 5, 1st genomic peak = 15, 2nd = 25, bubble_min_depth_cutoff=23. For kmer of 55 and 61 it is harder to tell but approximatively: 55mer: min depth = 4, 1st genomic peak = 13, 2nd = 23 ; 61mer:min depth = 4, 1st genomic peak = 11, 2nd = 20. The observation of the `isotigs.depth.hist` when the `meraculous_bubble` step will be done can help see if it is visible with kmer=61 and if we need to adjust the value autocaluated by the program. If not, we should directly go with 55mer and the values I discussed earlier.

11/04:

The quick try run (Time ~1h) using all the pair end reads (including the ones from mate pair) didn't produce any errors - means issue was previously due to too small reads in the "FRA300" lib. Submitted for a longer run (kmer=61, pe in every step, mp in scaffolding and gap closing, `fallback_on_est_insert_size 1`, `gap_close_aggressive 1`, `min_depth_cutoff 4`). 

Submitted with a kmer size of 51 (`min_depth_cutoff 4`, `bubble_depth_threshold 23`, similar other parameters).

### Results
### 49mers

(finished on 10/04)

Using short paired ends libraries for every step and mate paired for only the scaffolding step. Other parameters: `min_depth_cutoff 4` (from k-mer distribution + `mercount.occurrence.dmin.err`). No `bubble_depth_threshold` specified.

`meraculous_final_results/SUMMARY.txt`
```
== Assembly Stats ===

Description             cnt     total   min     max     N50 stats
------------------------------------------------------------------------------
Final Scaffolds         519589  1623.8Mb        1.0Kb   175.6Kb 72740 > 4.4Kb totalling 811.9Mb
Final Contigs           728454  1258.8Mb        0.0Kb   30.5Kb  190931 > 2.1Kb totalling 629.4Mb
Starting UUtigs         54615801        5282.3Mb        0.0Kb   6.9Kb   14956607 > 0.1Kb totalling 2641.2Mb
```
Better than the `allpaths` assembly I previously obtained. The size is ~1/2 of the expected size but I think it is still promising since it was a preliminary run.

For the `bubble_min_depth_cutoff`, used the auto-detection. Checking the `isotigs.depth.hist` and hist from jellyfish. It is the limit (depth with the lowest frequency between the 2 genomic peaks). For this run corresponds to ~23. From `meraculous_bubble/haplotigs.dmin.err`: `D-min cutoff picked at: 24`. I should probably rerun from the bubble step with a value of 23 (1st should wait the results from 61mer).

`fasta_stats`
```
Main genome scaffold total: 519589
Main genome contig total:   728454
Main genome scaffold sequence total: 1623.8 MB
Main genome contig sequence total:   1258.8 MB (-> 22.5% gap)
Main genome scaffold N/L50: 72740/4.4 KB
Main genome contig N/L50:   190931/2.1 KB
Number of scaffolds > 50 KB: 299
% main genome in scaffolds > 50 KB:  1.1%

 Minimum    Number    Number     Total        Total     Scaffold
Scaffold      of        of      Scaffold      Contig     Contig
 Length   Scaffolds  Contigs     Length       Length    Coverage
--------  ---------  -------  -----------  -----------  --------
    All   519,589    728,454  1,623,824,024  1,258,766,162    77.52%
   1 kb   519,589    728,454  1,623,824,024  1,258,766,162    77.52%
 2.5 kb   148,638    298,388  1,048,007,570  691,855,147    66.02%
   5 kb    66,814    189,380  784,233,310  434,893,854    55.45%
  10 kb    26,475    100,170  484,954,810  273,218,975    56.34%
  25 kb     4,232     25,880  145,515,920   80,724,029    55.47%
  50 kb       299      2,915   18,622,943   10,669,844    57.29%
 100 kb         8        130      990,425      682,567    68.92%
 250 kb         0          0            0            0     0.00%
```
For short paired end libraries, `meraculous` re-estimated the insert size (from the `info.log`)
```
lib_insert_size_recalc  FRA400 398 29
lib_insert_size_recalc  FRA2ND180 156 28
lib_insert_size_recalc  FRA1000 947 99
lib_insert_size_recalc  FRA1ST180 198 20
```
#### Small total length
##### Read and kmer depth

```
Read depth = (Total input sequencing in GB) / (Expected genome size in GB)
Kmer depth = (Read depth) x (Read length - Kmer size + 1) / (Read length)
```
We expect a genome size between 3.1 and 3.5.
```
##GS=3.1 (X. laevis)
RD = (30.9+30.1+0.9+22.2+137.0+0.8) / 3.1 = 71.58064516129032
Read_length_mean = (314140000*98.2+304340000*98.8+8760000*98.3+1510080000*90.7+13553506*59.034669)/(314140000+304340000+8760000+1510080000+13553506) = 92.77292699169057
KD(41) = 71.58064516129032*(92.77292699169057-41+1)/92.77292699169057 = 40.71791505999617

##GS=3.5 (estimation from reads)
RD = 63.4
KD(41) = 36.064439053139466

##GS=3.4 (= 2 x X. tropicalis)
RD=65.26470588235294
KD(41) = 37.12515784882004
```
##### Default filtering

In the final results: we only have information for scaffolds > 1kb and contigs that are used in these filtered scaffolds. In case of highly repetitive genome we expect to obtain small contigs that might be hard to assemble (small scaffolds) - we already started with "contigs" from `meraculous_merblast/contigs.fa` very small: too small to be able to re-estimate the insert size of big insert mate libraries. Not surprising for me that at the end we obtained a much smaller assembly size than expected. Should be already improved by using bigger k-mer size and more libraries in the gap filling step.

- `final.scaffolds.unfiltered.single-haplotype.fa`: (diploid_mode 1 only) The scaffolds without alternative variant singletons  (no size filtering).

- `final.scaffolds.fa`: Final scaffolds of size greater than 1kb  (in diploid_mode 2 includes all variants)

- `final.contigs.fa`: Individual contigs comprising the final filtered scaffolds

(17/04:) Run the `fasta_stats` on `final.scaffolds.fa.unfiltered` and `final.scaffolds.unfiltered.single-haplotype.fa`: total length respectively ~2.9Gb and 2.2Gb. The small intial contigs size seems to be definitely a factor.

## Evaluating the run
The script can be run at different steps in addition to the inspection of the intermediary files to check (`log`, `kha.png`, `mercount.png`, `.err`). 
```
export MERACULOUS_ROOT=/cvmfs/soft.computecanada.ca/easybuild/software/2017/avx2/Compiler/gcc4.8/meraculous/2.2.4/bin/
/cvmfs/soft.computecanada.ca/easybuild/software/2017/avx2/Compiler/gcc4.8/meraculous/2.2.4/bin/evaluate_meraculous_run.sh mellotropicalis_meraculous_assembly_2018-03-14_20h11m18s mellotropicalis_meraculous_assembly_2018-03-14_20h11m18s/some_stats_running
```
It produces 3 files `RUN_SUMMARY.txt` containing information about each run, time of run, failures, different results of each steps (total mers, mers used, library mapping, scaffolding, gap closing and final scaffolds after filtering, ...), and 2 outputs specifically for the quality for the final assembly `final.scaffolds.fa.stats`, `final.scaffolds.fa.unfiltered.stats`.

## Checking fastq format
Not sure from where the issues for scaffolding with meraculous came from (note from 27/03). Checked the `.fasq` format before and after nxtrim to make sure it is fine (4/04)
```
./fastQValidator --file /home/cauretc/scratch/HiSeq_data/6kb_1_nxtrimmed_0_R1.mp_unknown.fastq.gz 
Finished processing /home/cauretc/scratch/HiSeq_data/6kb_1_nxtrimmed_0_R1.mp_unknown.fastq.gz with 58030136 lines containing 14507534 sequences.
There were a total of 0 errors.
Returning: 0 : FASTQ_SUCCESS

./fastQValidator --file /home/cauretc/scratch/HiSeq_data/6kb_1_nxtrimmed_0_R1.paired.pe.fastq.gz 
Finished processing /home/cauretc/scratch/HiSeq_data/6kb_1_nxtrimmed_0_R1.paired.pe.fastq.gz with 3635368 lines containing 908842 sequences.
There were a total of 0 errors.
Returning: 0 : FASTQ_SUCCESS

./fastQValidator --file /home/cauretc/scratch/HiSeq_data/10kb_nxtrimmed_6_R1.paired.pe.fastq.gz
Finished processing /home/cauretc/scratch/HiSeq_data/10kb_nxtrimmed_6_R1.paired.pe.fastq.gz with 472972 lines containing 118243 sequences.
There were a total of 0 errors.
Returning: 0 : FASTQ_SUCCESS

./fastQValidator --file /home/cauretc/scratch/HiSeq_data/10kb_nxtrimmed_6_R1.mp_unknown.fastq.gz 
Finished processing /home/cauretc/scratch/HiSeq_data/10kb_nxtrimmed_6_R1.mp_unknown.fastq.gz with 14203840 lines containing 3550960 sequences.
There were a total of 0 errors.
Returning: 0 : FASTQ_SUCCESS
```
