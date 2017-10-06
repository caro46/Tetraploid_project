## Aligning against *X. tropicalis*

Using MUMMER. New version `mummer-4.0.0beta1.tar.gz`. Download new release from [here](https://github.com/mummer4/mummer/releases). Mummer on [github](https://github.com/mummer4/mummer). For some reason not able to install a new version on sharcnet so let's try with the older version we have `MUMmer3.23` (`/work/cauretc/programs/MUMmer3.23`)

```
./nucmer -p <prefix> ref.seq qry.seq
show-coords -r -c -l nucmer.delta > nucmer.coords
```
From the mummer website [example](http://mummer.sourceforge.net/examples/): *Each line of the table represents an individual pairwise alignment, and each line is sorted by its starting reference coordinate (-r). Additional information, like alignment coverage (-c) and sequence length (-l) can be added to the table with the appropriate options. Output is to stdout, so we have redirected it into the file, nucmer.coords.*

Beginning from the example of [output from Nucmer website](http://mummer.sourceforge.net/examples/data/nucmer.coords)
```
/home/aphillip/web/mummer/examples/data/B_anthracis_Mslice.fasta /home/aphillip/web/mummer/examples/data/B_anthracis_contigs.fasta
NUCMER

    [S1]     [E1]  |     [S2]     [E2]  |  [LEN 1]  [LEN 2]  |  [% IDY]  |  [LEN R]  [LEN Q]  |  [COV R]  [COV Q]  | [TAGS]
===============================================================================================================================
    5224    12174  |     6944        1  |     6951     6944  |    99.80  |   312600     6944  |     2.22   100.00  | B_anthracis_Mslice	138389
```
## Separating the subgenomes

Using python script. We will keep scaffolds longer than `500bp`, than align on a region for at least 50% of the length of the scaffold. The subgenome *tropicalis* will be regions having the highest `%ID`. Will be creating multiple outputfiles: an index, a fasta file containing the name of the chromosome, the subgenome, the scaffold sequences separated by 80 "N". 

## Mapping back to the pseudomolecules

We should map the HiSeq reqds and the contigs of the assemblies and call the consensus to polish the genome. Then run `quast`.
