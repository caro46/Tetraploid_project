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

## Running

`mellotrop.config` contains the main information to run the program. We need to give an estimation of the insert size for each library and the stantard deviation. We don't have this information. Put I'll use a 10\% variance (NEED TO PUT SOME REF), i.e.: `180bp+/-20, 400bp+/-40, 1000bp+/-100, 6kb+/-600, 10kb+/-1000`. If the assembly is not good enough, we can map the reads to the assembly and try to have an estimate with `bwa` of the mean and standard deviation of insert size. The `.config` file gives information about the sequences files, the type of library (fragment or jumping), the insert size, its standard deviation, the mean size of the reads, the orientation (innies, outies), if the reads are used for contigs and/or scaffolding. Example of a [config file](https://github.com/caro46/Tetraploid_project/blob/master/files_examples/mellotrop.config).

8/03: submitted with less resources (`8` CPUS), using only the short insert size for the contigs part as suggested in the manual. When I did the 1st step run `-step meraculous_import`, no issue (so good format of the inputs), tried specified `-step meraculous_mercount` but it only rerun the import step. Should have submitted from inside the output directory of the other run and add a `-resume`

9/03: submitted another short run using `-stop meraculous_mercount` to run the 1st 2 steps and check on some outputs for k-mer choice. Also real run using this time all the short reads (including mate reads), in the contigs steps. We will see which assemblies between including or not the mate reads in contigs produce the most continuous contig assembly.

15/03: So all the runs started (at once...). Because of the number of files produced, the size and the computecanada limit I decided to stop the run that was using more cores because the benefit in time did not seem to be a lot. Gave different try to restart/resume if a run fails (waiting to make sure that I am not getting errors then I can focus on the real/complete run and delete the unecessary files - need to check on the plots first - since I resubmitted step by step, the other complete run is further in the step, since everything was running without issues I killed the job and deleted the `tryshort` for space purposes). So with `-resume`, any run that gets killed because of time (or others) can directly be re-started from wherever it stopped.

To resume:
```
run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_tryshort.config -dir /home/cauretc/scratch/meraculous/tryshort/mellotropicalis_meraculous_assembly_1st_step_2018-03-11_05h30m03s -resume
```
To restart: `-restart -start meraculous_mercount`, or 1 by 1 step `-step meraculous_mercount`. When using `resume` or `restart`: `-dir` is the run directory created when the 1st run started, you cannot use `-label` anymore. Rerun from within the run directory is not sufficient, `-dir` is necessary from the command submission.

16/03: The run with only paired end (180 bp -> 1000bp) to build the contigs, with value `49` for kmer failed. Seemed to be because meraculous couldn't find the `min-depth cutoff`. The `mercount.png` was produced: the "error" peak doesn't seem separated enough from the main "genomic" peak. Should try smaller kmer size (will see if we all the reads in contiging would work). `45` seemed to maybe a good value to try (according to previous jellyfish distribution plots). Issue with the slurm controller on the machine, need to submit the new run with smaller kmer whenever it is fixed.


