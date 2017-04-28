## Download
The latest source code from [github](https://github.com/thegenemyers/DEXTRACTOR) on April 28th, 2017.

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
```
make 
make install
```
