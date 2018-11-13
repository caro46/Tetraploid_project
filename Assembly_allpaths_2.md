# [Previously](https://github.com/caro46/Tetraploid_project/blob/master/Assembly_Allpaths.Rmd)

- *Libraries -- RAM limitation:* Tried to produced an Allpaths assembly on Sharcnet. I was not able to use all the libraries (due to RAM requirement) -- I could not use the 180bp 2nd library that should have helped to obtain an OK assembly with Allpaths. **Now** we have Graham and its large memory nodes.

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

## RunAllpaths

```
RunAllPathsLG PRE=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data REFERENCE_NAME=Xmellotropicalis DATA_SUBDIR=frag_nxtrimMate RUN=Run1_all_library TARGETS=standard THREADS=1 OVERWRITE=TRUE
```
We resubmitted the `RunAllPathsLG` (Oct.20) using `--ntasks-per-node=1`, `--mem=800gb`, again for a week to make sure the RAM amount is OK. On Oct.22 still running. If at the end of the week, failure due to time limit, will do `--time=28-00:00:00` (maximum possible on Graham and Cedar). The assembly should re-start from where it stopped.

`less allpaths.8494932.out` (oct.24)
```
Wed Oct 24 04:52:31 2018 (NK): Done with kmerization. Took 3.45 days.
Wed Oct 24 04:52:31 2018 (FEC): Making corrections.
Wed Oct 24 05:07:07 2018 (FEC):   2128013878 reads.
Wed Oct 24 05:07:07 2018 (FEC):     49768006 reads corrected (2.3 %).
Wed Oct 24 05:07:07 2018 (FEC):     51385872 total corrections.
Wed Oct 24 05:07:07 2018 (FEC):          1.0 corrections per corrected read.
Wed Oct 24 05:07:07 2018 (FEC):      8741577 corrections skipped.
PERFSTAT: % of bases pre-corrected [frac_bases_pre_corrected] = 0.0
Wed Oct 24 05:14:59 2018 (FE): Analysing kmer spectrum.
Wed Oct 24 05:14:59 2018 (KS): Writing kmer spectrum to '/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data/Xmellotropicalis/frag_nxtrimMate/Run1_all_library/frag_reads_filt.25mer.kspec'.
Wed Oct 24 05:15:01 2018 (KSC): Estimating genome size.
Wed Oct 24 05:15:01 2018 (KSC): ------------------- Kmer Spectrum Analysis -------------------
Wed Oct 24 05:15:01 2018 (KSC): Genome size estimate        =  3,425,961,158 bases
Wed Oct 24 05:15:01 2018 (KSC): Genome size estimate CN = 1 =  1,747,606,722 bases (  51.0 % )
Wed Oct 24 05:15:01 2018 (KSC): Genome size estimate CN > 1 =  1,678,354,436 bases (  49.0 % )
Wed Oct 24 05:15:01 2018 (KSC): Coverage estimate           =             42 x
Wed Oct 24 05:15:01 2018 (KSC): Bias stddev at scale > K    =           0.40
Wed Oct 24 05:15:01 2018 (KSC): Base error rate estimate    =         0.0005 (Q = 32.7)
Wed Oct 24 05:15:01 2018 (KSC): SNP rate not computed (PLOIDY = 1).
Wed Oct 24 05:15:01 2018 (KSC): --------------------------------------------------------------
PERFSTAT: estimated genome size in bases [genome_size_est] = 3425961158
PERFSTAT: % genome estimated to be repetitive (at K=25 scale) [genome_repetitiveness_est] = 48.0
PERFSTAT: estimated genome coverage by fragment reads [genome_cov_est] = 42
PERFSTAT: estimated standard deviation of sequencing bias (at K=25 scale) [bias_stddev_est] = 0.40
```

**Optimistic note**: 

- coverage estimate from fragment libraries (2x180bp, 400bp, 1kb) = 42X

- Genome size estimated by the program and the repetitiveness is very close to what we expected !!!

**Update:**

- Allpaths-LG failed (Nov.11):

```
Sat Nov 10 01:52:55 2018 (NK): [pass  8] parse collect sort summarize merge
Sun Nov 11 01:06:02 2018 (NK): [pass  9] parse
Dang dang dang, we've got a problem.
Attempt to allocate memory failed, memory usage before call = 466.91 GB.
--------------------------------------------------------------------------------
Top memory processes on this server now:
top: unknown option 'a'
Usage:
  top -hv | -bcHiOSs -d secs -n max -u|U user -p pid(s) -o field -w [cols]
--------------------------------------------------------------------------------
Stack trace (sometimes informative):

Fatal error (pid=9755) at Sun Nov 11 01:58:21 2018:
Failed to create temporary file from /tmp/tmp_process_name_Xc17PF2: No such file or directory [errno=2].


Sun Nov 11 01:58:21 2018.  Abort.  Stopping.

```
Interresting considering it has a whole 800Gb for itself... Looking on different websites, it has been a recurring issues to have Allpaths to run on a shared server...

- Trying now (`--mem=1000gb`,`--ntasks-per-node=1`, `--time=28-00:00:00`):

```
RunAllPathsLG PRE=/home/cauretc/projects/rrg-ben/cauretc/HiSeq_data REFERENCE_NAME=Xmellotropicalis DATA_SUBDIR=frag_nxtrimMate RUN=Run1_all_library TARGETS=standard THREADS=1 MAX_MEMORY_GB=900
```

Need to find new options in case it fails...

Directly went it went to the queue:
```
Fatal error (pid=60670) at Tue Nov 13 15:20:16 2018:
Run directory already exists. To continue an assembly use OVERWRITE=True
```
Before this attempt, the use of `OVERWRITE=True` made us lost all the progress that was done... In theory we were supposed to be able to re-start an assembly from where it stopped. Does not seem to work well... Re-submitted using the overwrite option, started on Nov. 13, 2018. Seemed to again not start where it was supposed to... Lost 13 days of progress!!!

On the computecanada [webpage](https://docs.computecanada.ca/wiki/Job_scheduling_policies) it is specified that 28 days is limit ("*Cedar and Graham will accept jobs of up to 28 days in run-time.*") which is what I am using. If the program always has to start again from the beginning then it will not be enough. 

With BE we decided that giving a try to another program (maybe Platanus?). If it is faster then I will use the output of the other program as input from DBG2OLC.

