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
- *A well-behaved large genome, such as human or other mammals, can be assembled in 10,000 to 25,000 CPU hours, depending on coverage. A grid environment is strongly recommended, with at least 16GB available on each compute node, and one node with at least 64GB memory. You should plan on having 3TB free disk space, much more for highly repetitive genomes.* Don't think it is really possible... See [FAQ](http://canu.readthedocs.io/en/latest/faq.html#faq)

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
