## Aligning against *X. tropicalis*

### Nucmer
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
Commands to perform:
```
/work/cauretc/programs/MUMmer3.23/nucmer -p Nucmer_mello_allpaths_xentrop9 /work/ben/2016_Hymenochirus/xenTro9/Xtropicalis_v9_repeatMasked_HARD_MASK.fa <(zcat /work/cauretc/2017_Mellotropicalis/pseudomolecules/final.assembly.fasta.gz) 
/work/cauretc/programs/MUMmer3.23/show-coords -r -c -l Nucmer_mello_allpaths_xentrop9.delta > Nucmer_mello_allpaths_xentrop9.coords
```
```
/work/cauretc/programs/MUMmer3.23/nucmer -p Nucmer_mello_dbg2olc_xentrop9 /work/ben/2016_Hymenochirus/xenTro9/Xtropicalis_v9_repeatMasked_HARD_MASK.fa <(zcat /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw.fasta.gz)
```
Run started on `6/10` for `nucmer`.

Needed to 1st unzip the backbone file otherwise with `zcat` or `gzip -c`, Nucmer did not find the file.

### Filtering

Keeping only the best hit for each query `delta-filter -q`
```
../../programs/MUMmer3.23/delta-filter -q Nucmer_mello_dbg2olc_xentrop9.delta >Nucmer_mello_dbg2olc_xentrop9_qfiler.delta

../../programs/MUMmer3.23/show-coords -r -c -l Nucmer_mello_dbg2olc_xentrop9_qfiler.delta> Nucmer_mello_dbg2olc_xentrop9_qfiler.coord

```
### Soft masked
```
/work/cauretc/programs/MUMmer3.23/nucmer -p Nucmer_mello_dbg2olc_xentrop9_soft /work/ben/2016_Hymenochirus/xenTro9/Xtropicalis_v9_repeatMasked.fa /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw.fasta
#Oct 18
/work/cauretc/programs/MUMmer3.23/delta-filter -q Nucmer_mello_dbg2olc_xentrop9_soft.delta >Nucmer_mello_dbg2olc_xentrop9_soft_qfiler.delta
/work/cauretc/programs/MUMmer3.23/show-coords -r -c -l Nucmer_mello_dbg2olc_xentrop9_soft_qfiler.delta >Nucmer_mello_dbg2olc_xentrop9_soft_qfiler.coord
```

### Promer
```
/work/cauretc/programs/MUMmer3.23/promer -p Promer_mello_dbg2olc_xentrop9_soft /work/ben/2016_Hymenochirus/xenTro9/Xtropicalis_v9_repeatMasked.fa /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw.fasta
```
## Separating the subgenomes

Using python script. We will keep scaffolds longer than `500bp`, than align on a region for at least 50% of the length of the scaffold. The subgenome *tropicalis* will be regions having the highest `%ID`. Will be creating multiple outputfiles: an index, a fasta file containing the name of the chromosome, the subgenome, the scaffold sequences separated by 80 "N". 

```
python pseudomolecules.py Nucmer_mello_dbg2olc_xentrop9.coords 500 30 backbone_raw.fasta pseudomolecules_nucmer_dbg2olc.fasta pseudomolecules_nucmer_dbg2olc_index.txt >pseudomolecules_nucmer_dbg2olc.out

python pseudomolecules.py Nucmer_mello_dbg2olc_xentrop9.coords 500 50 backbone_raw.fasta pseudomolecules_nucmer_dbg2olc_cov50.fasta pseudomolecules_nucmer_dbg2olc_cov50_index.txt >pseudomolecules_nucmer_dbg2olc_cov50.out
```
Comments (run and tests on Oct.15): some weird stuff: sometimes same scaffold assigned to different chr. or diff subgenome depending on the region... Try to add more details for the 2nd subgenome. Need to check what is different exactly between our file and the example for which the script was working fine
```
python pseudomolecules.py Nucmer_mello_dbg2olc_xentrop9_qfiler.coord 500 20 backbone_raw.fasta filter/pseudomolecules_nucmer_qfilter_dbg2olc.fasta filter/pseudomolecules_nucmer_qfilter_dbg2olc_index.txt >filter/pseudomolecules_nucmer_qfilter_dbg2olc.out
```
Seems like the issue came from a not exact match of a `in` (changed into `==`)(in the example used the scaffolds name only had numbers)
```
python3 pseudomolecules.py Nucmer_mello_dbg2olc_xentrop9_qfiler.coord 500 15 backbone_raw.fasta filter/pseudomolecules_nucmer_qfilter_dbg2olc.fasta filter/pseudomolecules_nucmer_qfilter_dbg2olc_index.txt >filter/pseudomolecules_nucmer_qfilter_dbg2olc.out
```
Adding some codes to keep the scaffolds that are not separated into the 2 subgenomes: if match to *X. tropicalis* with the min cov. but there is not overlap with another scaffold: unknown_subgenome but I still assemble the scaffolds into chromosome (~like as a 3rd subgenome); if there is no match (or too small) with *X. tropicalis*, scaffolds considered as only polyploid and are not assemble into pseudomolecules.
```
module load python/intel/3.4.2
python3 pseudomolecules_scaffolds.py Nucmer_mello_dbg2olc_xentrop9_qfiler.coord 500 15 backbone_raw.fasta filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc.fasta filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc_index.txt >filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc.out
```
Soft mask (Oct.18)
```
module load python/intel/3.4.2
python3 ../pseudomolecules_scaffolds.py Nucmer_mello_dbg2olc_xentrop9_soft_qfiler.coord 500 15 ../backbone_raw.fasta pseudomolecules_scaff_nucmer_soft_qfilter_dbg2olc.fasta pseudomolecules_scaff_nucmer_soft_qfilter_dbg2olc_index.txt >pseudomolecules_scaff_nucmer_soft_qfilter_dbg2olc.out
```
Promer - to be run
```
module load python/intel/3.4.2
python3 pseudomolecules_scaffolds.py Pomer_mello_dbg2olc_xentrop9_soft_qfiler.coord 500 15 backbone_raw.fasta pseudomolecules_scaff_promer_qfilter_dbg2olc.fasta filter/pseudomolecules_scaff_promer_qfilter_dbg2olc_index.txt >pseudomolecules_scaff_promer_qfilter_dbg2olc.out
```
### Comments
We should consider using Promer to align the scaffolds onto *X. tropicalis* genome. The main issue seems to be the quality of the alignment (due to repeat elements?). On Oct. 17, started an alignment on the soft masked genome of *X. tropicalis*. We should also consider aligning the scaffolds that do not match onto *X. tropicalis* onto themselves and by comparing TEs maybe assign the scaffolds to the suspected subgenome.

## Mapping back to the pseudomolecules

We should map the HiSeq reqds and the contigs of the assemblies and call the consensus to polish the genome. Then run `quast`.
