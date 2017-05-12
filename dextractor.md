## Download
The latest source code from [github](https://github.com/thegenemyers/DEXTRACTOR) on April 28th, 2017([V1.0](https://devhub.io/zh/repos/thegenemyers-DEXTRACTOR) - updated to deal with bam file).

## Installing on sharcnet
It was kinda of difficult 
```
module load hdf/mpi/5.1.8.11
module load zlib/system/1.2.11
```
In the `Makefile`, change:
```
PATH_HDF5 = /opt/sharcnet/hdf/5.1.8.11/mpi
DEST_DIR  = /work/ben/Mellotropicalis_corrected_data/DEXTRACTOR-master
PATH_mpi = /opt/sharcnet/openmpi/1.8.7/gcc-5.1.0/std
PATH_zlib = /opt/sharcnet/zlib/1.2.11/system
```
Add to all the `gcc` command
```
-I $(PATH_zlib)/include -L $(PATH_zlib)/lib
```
In particular for `dextract` and `dex2DB`

```
dextract: dextract.c sam.c bax.c expr.c expr.h bax.h DB.c DB.h QV.c QV.h
        gcc $(CFLAGS) -I $(PATH_HDF5)/include -L$(PATH_HDF5)/lib -I $(PATH_mpi)/include -L $(PATH_mpi)/lib -I $(PATH_zlib)/include -L $(PATH_zlib)/lib -o dextract dextract.c sam.c bax.c expr.c DB.c QV.c -lhdf5 -lsz 

dex2DB: dex2DB.c sam.c bax.c DB.c QV.c bax.h DB.h QV.h
        gcc $(CFLAGS) -I$(PATH_HDF5)/include  -L$(PATH_HDF5)/lib -I $(PATH_mpi)/include -L $(PATH_mpi)/lib -I $(PATH_zlib)/include -L $(PATH_zlib)/lib -o dex2DB dex2DB.c sam.c bax.c DB.c QV.c -lhdf5 -lsz
```
Needed to change the `-lz` into `-lsz`. 
```
make 
make install
```
### Cite
Dextractor is part of the dazzler assembler project. See
[Weitschek et al. 2014](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4265526/) for an example of how to cite dazzler.

## Run
To obtain fasta files
```
dextract -f /scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.1000bpmin.fastq.gz
```
```
gzip /scratch/ben/mellotropicalis_pacbio_temp/*.fasta

cat /scratch/ben/mellotropicalis_pacbio_temp/*fasta.gz >/scratch/ben/mellotropicalis_pacbio_temp/BJE3652.all.subreads.fasta.gz
```
