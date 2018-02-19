# Canu
## [Download](https://github.com/marbl/canu/releases) and install
Download the the binary version for linux `canu-1.5.Linux-amd64.tar.xz`.

Then:
```
xz -dc canu-1.5.*.tar.xz |tar -xf -
```
Executable programs in `/work/ben/canu-1.5/Linux-amd64/bin`.

## Usage

```
usage:   canu [-version] [-citation] \
              [-correct | -trim | -assemble | -trim-assemble] \
              [-s <assembly-specifications-file>] \
               -p <assembly-prefix> \
               -d <assembly-directory> \
               genomeSize=<number>[g|m|k] \
              [other-options] \
              [-pacbio-raw |
               -pacbio-corrected |
               -nanopore-raw |
               -nanopore-corrected] file1 file2 ...

example: canu -d run1 -p godzilla genomeSize=1g -nanopore-raw reads/*.fasta.gz
```
By default `minReadLength=1000`, `rawErrorRate=0.300` for Pacbio, `minOverlapLength=500`. Reads can be either FASTA or FASTQ format, uncompressed, or compressed with gz, bz2 or xz.

## Run
Using the fasta format obtained from `dextract`
```
export PATH=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin:$PATH
/work/ben/canu-1.5/Linux-amd64/bin/canu -p mellotropicalis_pacbio -d /work/ben/Mellotropicalis_corrected_data/canu_assembly genomeSize=3.1g -pacbio-raw /scratch/ben/mellotropicalis_pacbio_temp/*.fasta.gz
```
Try with different parameters on wobbie (`wobbie101`)
```
/work/ben/canu-1.5/Linux-amd64/bin/canu -p mellotropicalis_pacbio -d /work/ben/Mellotropicalis_corrected_data/canu_assembly genomeSize=3.1g -pacbio-raw /scratch/ben/mellotropicalis_pacbio_temp/*.fasta.gz merylMemory=20 merylThreads=8 >canu_log_May5.txt
```
Not enough memory on `wob101`.

## Notes
- *A well-behaved large genome, such as human or other mammals, can be assembled in 10,000 to 25,000 CPU hours, depending on coverage. A grid environment is strongly recommended, with at least 16GB available on each compute node, and one node with at least 64GB memory. You should plan on having 3TB free disk space, much more for highly repetitive genomes.* Don't think it is really possible... See [FAQ](http://canu.readthedocs.io/en/latest/faq.html#faq)

## New start
More ressources on computecanada (a lot).

Downloaded newest version from github (executable located there ` ~/project/cauretc/programs/canu/Linux-amd64/bin/`)
```
git clone https://github.com/marbl/canu.git
cd canu/src
make -j 8
```
For now, tried same command as in the previous `Run` paragraph (but submitteds through `sbatch`). 

Not clear how long it should take... this run is more to check everything is working... I might stay on queue forever (need to see if it is running tomorrow on Jan17), need to have BE opinion probably.
So I killed the job and resubmitted for a shorter time perio using fewer tasks. I think I just need to be patient and wait (priority reason) - jan.18.

Not clear why it fails. I checked the default `java` version available on cedar (`1.8.0_151`) and `canu` requires "at least 1.8.0". Trying running it again.

I think more and more that this software is not the solution. The amount it requires is just rediculous... I expected like 10T  because of the FAQ I previously cited... But apparently it would be more >200T!!!! See the [issue](https://github.com/marbl/canu/issues/587): this person was trying to assemble a "*2.4 Gb genome with approx >25X coverage reads on a slurm grid. In the 1-correction it used up >200TB of disk space and literally broke the cluster as it filled up the free disk to the rim*." 
An explanation from canu people being the genome should be really repetitive. A solution suggested:

```
corMhapFilterThreshold=0.0000000002 corMhapOptions="--threshold 0.80 --num-hashes 256 --num-min-matches 3 --ordered-sketch-size 1000 --ordered-kmer-size 14 --min-olap-length 2000 --repeat-idf-scale 50"
```
The person seemed to have a high coverage so maybe it would less, or maybe more since bigger genome, memory needed...
I will wait the end of run try to see if canu can at least start correctly but I think the other option using `minimap`, `minimiasm` and `racon` might be more feasible.

Note 29/01/18:

So again error when tried to run it:
```
ERROR:  mhap overlapper requires java version at least 1.8.0; you have unknown (from 'java').
ERROR:  'java -showversion' reports:
```
I checked again with `java -version` and `java -showversion` (good version: `1.8.0_151`). Some people had similar issues and discussed on [github](https://github.com/marbl/canu/issues/329) and [there](https://github.com/marbl/canu/issues/144). It seems to be that maybe it is not the same version on head node and compute node or that the version is not loaded on the compute node. So I added `module load java/1.8.0_151` in the bash submission script before the canu command and try to launch a run again (29/01/18).
Still didn't work. So trying within the canu command to add `java` path as suggested by the authors in some github issues, like that `java=/usr/bin/java` (start a checking run with `#SBATCH --time=00:01:00` on jan30/18).
If it is still not working, I'll try `useGrid=false` to force the program on not using a grid environment that seems to have fixed some other users similar problems (when the `java` path isn't working).

Note 31/01/18:

Since `canu` starts by correcting the sequences it might be good to at least have the 1st step runni
ng...and maybe use the outputs with another program. The java path in the command did not work either so trying with the other options specified above. Limit time: 48h.

```
/home/cauretc/project/cauretc/programs/canu/Linux-amd64/bin/canu java=/usr/bin/java useGrid=false genomeSize=3.1g corMhapFilterThreshold=0.0000000002 corMhapOptions="--threshold 0.80 --num-hashes 256 --num-min-matches 3 --ordered-sketch-size 1000 --ordered-kmer-size 14 --min-olap-length 2000 --repeat-idf-scale 50" -pacbio-raw /home/cauretc/scratch/pacbio_mellotrop/BJE3652.all.subreads.fasta.gz -p BJE3652_canu_assembly -d /home/cauretc/scratch/canu_analysis >/home/cauretc/scratch/canu_jantest.log
```

**Info to consider:** So there is a new issue on the [canu github page](https://github.com/marbl/canu/issues/767) about what to expect as ressources needed for a 2.2 Gb plant genome assembly (~ 80% repetitive):

*~40Tb space, ~300 gb RAM and >100-200 dedicated CPUs for 2-3 months might be a good start under default parameters.*

Ccl: no way we can use Canu...

Note 2/2/18:

Trying with [download](https://www.java.com/en/download/manual.jsp) `java v1.8.0_161` for local installation and run again specifying the path in the command.  

Still having trouble, try again with the grid, if not working, need to try `useGrid=false` with `ovsMethod=sequential`.
The issue seems to come when I submit on a compute node. They should fix that.
OK even weirder: as suggested by Brian: checked if the module for java was correctly loaded, and check was is inside my path. In theory it should work... Tried again with module but without any path specified in the command.

So previously, I tried loading `module load java/1.8.0_121` but loading the default version again with load seems to work `module load java`. New issue though:
```
-- ERROR
-- ERROR
-- ERROR  Found 1 machine configuration:
-- ERROR    class0 - 1 machines with 32 cores with 126 GB memory each.
-- ERROR
-- ERROR  Task bat can't run on any available machines.
-- ERROR  It is requesting:
-- ERROR    batMemory=128-512 memory (gigabytes)
-- ERROR    batThreads=8-32 threads
-- ERROR
-- ERROR  No available machine configuration can run this task.
-- ERROR
-- ERROR  Possible solutions:
-- ERROR    Change batMemory and/or batThreads
-- ERROR
```
So trying now with `maxMemory=16 maxThreads=1`, hopefully that fixes everything... And it is only the beginning, we won't probably be able to run the whole pipeline because of memory... 

It looks like it is only a memory/theads issue. Need probably to specify that for every step. For now trying `Change merylMemory and/or merylThreads`. But then if it seems to only be a RAM issues, can increase more.
For now, trying with `maxMemory=64 maxThreads=2 merylMemory=64 merylThreads=2`.

So I think we are ready for a long run now, set for `#SBATCH --time=7-00:00:00`. Need to regularly check on the space used when the job will be running (submitted on Feb.2/2018).

Note 5/02/18:

Job started running during the weekend without error. If stops before the end, should be able to start where it stops by resubmitted the same command, see the issue on [github](https://github.com/marbl/canu/issues/339):

Answer from `brianwalenz`:
*You can just restart the same canu command and it will pick up where it left off.*

11/02/18: lauched another canu assembly in the same directory after the previous run finished due to job time ended. 12/02: canu restarted from where it stopped (should run again for 7 days - all parameters the same).

15/02: `canu` is running the `trimming` step. But corrected reads are already available here: 

`/home/cauretc/scratch/canu_analysis/BJE3652_canu_assembly.correctedReads.fasta.gz` (4.4G)

19/02: `canu` ended on 16/02 after ~12d and 6h total. Quast result below 

```
/work/ben/quast-4.5/quast.py /work/cauretc/2017_Mellotropicalis/canu_assembly/BJE3652_canu_assembly.contigs.fasta /work/cauretc/2017_Mellotropicalis/canu_assembly/BJE3652_canu_assembly.unassembled.fasta /work/cauretc/2017_Mellotropicalis/canu_assembly/BJE3652_canu_assembly.contigsANDunassembled.fa -o /work/cauretc/2017_Mellotropicalis/canu_assembly/quast_results

Assembly                    BJE3652_canu_assembly.contigs  BJE3652_canu_assembly.unassembled  BJE3652_canu_assembly.contigsANDunassembled
# contigs (>= 0 bp)         582                            81658                              82240                                      
# contigs (>= 1000 bp)      582                            81658                              82240                                      
# contigs (>= 5000 bp)      234                            16308                              16542                                      
# contigs (>= 10000 bp)     73                             4317                               4390                                       
# contigs (>= 25000 bp)     1                              2                                  3                                          
# contigs (>= 50000 bp)     0                              0                                  0                                          
Total length (>= 0 bp)      3179780                        277573772                          280753552                                  
Total length (>= 1000 bp)   3179780                        277573772                          280753552                                  
Total length (>= 5000 bp)   2136801                        137281898                          139418699                                  
Total length (>= 10000 bp)  1023380                        54170958                           55194338                                   
Total length (>= 25000 bp)  29449                          51569                              81018                                      
Total length (>= 50000 bp)  0                              0                                  0                                          
# contigs                   582                            81658                              82240                                      
Largest contig              29449                          26049                              29449                                      
Total length                3179780                        277573772                          280753552                                  
GC (%)                      43.54                          42.25                              42.26                                      
N50                         7220                           4932                               4956                                       
N75                         4277                           2461                               2477                                       
L50                         143                            16612                              16735                                      
L75                         288                            36772                              37002                                      
# N's per 100 kbp           0.00                           0.00                               0.00 
```
`BJE3652_canu_assembly.contigsANDunassembled.fa` obtained with:

``` 
cat BJE3652_canu_assembly.contigs.fasta BJE3652_canu_assembly.unassembled.fasta >BJE3652_canu_assembly.contigsANDunassembled.fa
```
A lot of reads were not used in the assembly, I concatenated `contigs` and `unassembled` to have an idea of number, length... I think we will only use `contigs`.

# Falcon

## Some information
The 1st step of Falcon is correcting the reads (can be turned of with `input_type = preads` if we used already corrected reads). See the ["Raw sub reads overlapping for error correction" paragraph of the manual](https://github.com/PacificBiosciences/FALCON/wiki/Manual#raw-sub-reads-overlapping-for-error-correction) for more details.

From Falcon [manual](https://github.com/PacificBiosciences/FALCON/wiki/Manual)

*Each of the steps is accomplished with different command line tools implementing different sets of algorithms to accomplish the work. Also, the computational requirements are quite different for each step. The manual assumes the user has a reasonable amount of computational resources. For example, to assemble a 100M size genome with a reasonable amount of time, one might need at least 32 core cpus and 128Gb RAM. The code is written with the assumption of a cluster computating environment. One needs a job queue for long last scripting job and cpu-rich computational job queues*

[FAQ](http://pb-falcon.readthedocs.io/en/latest/faq.html)

## Installation
- Tried to install Falcon assembler 

Trying loading this modules 1st (need recent Python version)
```
module load intel/12.1.3
module load python/intel/2.7.8
```
Then (need to unload `python/intel/2.7.8` because of conflicts): 
```
module unload python/intel/2.7.8
module unload intel mkl openmpi
module load gcc/4.9.2 
module load python/gcc/2.7.8 

git clone git://github.com/PacificBiosciences/FALCON-integrate.git
cd FALCON-integrate
git checkout master
git submodule update --init
make init
source env.sh
make config-edit-user
make -j all
make test
```
Conclusion: need to see if it is the best solution and then ask Sharcnet for help to install the software.
Also tried with
```
module load intel/12.1.3
module load python/intel/3.4.2
make -j all
```
And with the `make config-standard` (instead of `make config-edit-user`). Will need to install another version of `Python` or ask Sharcnet. Tried also after installing locally `Python-2.7.9` and adding it to the `PATH`, still not working.
```
tar xvfz Python-2.7.9.tgz
cd Python-2.7.9
export PYTHON_TOP_DIR=/work/ben/Mellotropicalis_corrected_data/falcon/Python-2.7.9
./configure --prefix=$PYTHON_TOP_DIR
make
make install
export PATH=$PYTHON_TOP_DIR/bin:$PATH
echo $PATH
```
