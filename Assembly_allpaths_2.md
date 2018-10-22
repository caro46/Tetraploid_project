# Previously

- *Libraries -- RAM limitation:* Tried to produced an Allpaths assembly on Sharcnet. I was not able to use all the libraries (due to RAM requirement) -- I could not use the 180bp 2nd library that should have helped to obtain an OK assembly with Allpaths. **Now** with have Graham and its large memory nodes.

- *ploidy: diploid:* We assumed the assembly would be able to separate both diploid subgenomes (subgenomes more different between each other). **Now** using the haploid assembly mode to try to have the complete genome. Later, dbg2olc with the addition of long Pacbio reads should help to keep only 1 version of each subgenome.

- *mate pairs -- trimmomatic only:* **Now**, only using mate+unknown identified by `nxtrim`. By default `nxtrim` converted the mate pair in FR direction, in the `in_libs.csv` needed to specify `inward` for them.

# Oct. Run

## Preparing the data

Used the same script as before to prepare `in_groups.csv` file.

(Oct.20/2018)
```
PrepareAllPathsInputs.pl DATA_DIR=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data/Xmellotropicalis/frag_nxtrimMate PLOIDY=1 IN_GROUPS_CSV=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data/Xmellotropicalis/in_groups.csv IN_LIBS_CSV=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data/Xmellotropicalis/in_libs.csv
```
The `PrepareAllPathsInputs.pl` was run with the ressources limit on Graham: `--mem=600g`, `--time=7-00:00:00`, `--ntasks-per-node=2`. It successfully finished after ~1day. But `RunAllPathsLG` failed due to RAM requirement  
```
RunAllPathsLG PRE=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data REFERENCE_NAME=Xmellotropicalis DATA_SUBDIR=frag_nxtrimMate RUN=Run1_all_library TARGETS=standard THREADS=1 OVERWRITE=TRUE
```
We resubmitted the `RunAllPathsLG` (Oct.20) using `--ntasks-per-node=1`, `--mem=800gb`, again for a week to make sure the RAM amount is OK. On Oct.22 still running. If at the end of the week, failure due to time limit, will do `--time=28-00:00:00` (maximum possible on Graham and Cedar). The assembly should re-start from where it stopped.
