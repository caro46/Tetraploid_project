# Meraculous

Austin adviced to give a try to Meraculous. With `cedar` and `graham` it should be ok to run.

To [download](https://jgi.doe.gov/data-and-tools/meraculous/), the [manual](http://1ofdmq2n8tc36m6i46scovo2e.wpengine.netdna-cdn.com/wp-content/uploads/2014/12/Manual.pdf), et the publication [Chapman et al. 2011](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0023501)

It is already installed on `cedar` and can be loaded like that
```
module load nixpkgs/16.09  gcc/4.8.5
module load meraculous/2.2.4
```
## kmer distribution - jellyfish

To choose the best k-mer size (from the manual): *As a rule of thumb, the largest value of k that yields a distinct peak at least ~30X is a reasonable choice*. We can either run the 1st step or Meraculous (`meraculous_mercount`) or just run `jellyfish` with different k-mer values and check on the graph.

On 2/03, started jellyfish with k-mer values: `31, 41, 51, 55, 59, 61, 65, 69, 71, 79, 81`. (Depending on the preliminary results I can run other sizes within the best range). I'll put the script up on github when I'll be sure it is running without issue (in case we need to load more modules, libraries...).

## Running

`mellotrop.config` contains the main information to run the program. We need to give an estimation of the insert size for each library and the stantard deviation. We don't have this information. Put I'll use a 10\% variance (NEED TO PUT SOME REF), i.e.: `180bp+/-20, 400bp+/-40, 1000bp+/-100, 6kb+/-600, 10kb+/-1000`. If the assembly is not good enough, we can map the reads to the assembly and try to have an estimate with `bwa` of the mean and standard deviation of insert size. The `.config` file gives information about the sequences files, the type of library (fragment or jumping), the insert size, its standard deviation, the mean size of the reads, the orientation (innies, outies), if the reads are used for contigs and/or scaffolding.
