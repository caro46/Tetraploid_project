# [Download](https://github.com/marbl/canu/releases) and install
Download the the binary version for linux `canu-1.5.Linux-amd64.tar.xz`.

Then:
```
xz -dc canu-1.5.*.tar.xz |tar -xf -
```
Executable programs in `/work/ben/canu-1.5/Linux-amd64/bin`.

# Run
Using the fasta format obtained from `dextract`
```
xport PATH=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin:$PATH
/work/ben/canu-1.5/Linux-amd64/bin/canu -p mellotropicalis_pacbio -d /work/ben/Mellotropicalis_corrected_data/canu_assembly genomeSize=3.1g -pacbio-raw /scratch/ben/mellotropicalis_pacbio_temp/*.fasta.gz
```
Try with different parameters on wobbie (`wobbie101`)
```
/work/ben/canu-1.5/Linux-amd64/bin/canu -p mellotropicalis_pacbio -d /work/ben/Mellotropicalis_corrected_data/canu_assembly genomeSize=3.1g -pacbio-raw /scratch/ben/mellotropicalis_pacbio_temp/*.fasta.gz merylMemory=20 merylThreads=8 >canu_log_May5.txt
```
Not enough memory on `wob101`.

# Notes
*A well-behaved large genome, such as human or other mammals, can be assembled in 10,000 to 25,000 CPU hours, depending on coverage. A grid environment is strongly recommended, with at least 16GB available on each compute node, and one node with at least 64GB memory. You should plan on having 3TB free disk space, much more for highly repetitive genomes.* Don't think it is really possible...
