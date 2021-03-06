
# Latest *X. tropicalis* genome

```
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.3_Xenopus_tropicalis_v9.1/GCF_000004195.3_Xenopus_tropicalis_v9.1_assembly_report.txt

wget http://ftp.xenbase.org/pub/Genomics/JGI/Xentr9.1/XENTR_9.1_Xenbase.gff3
```

## Only chromosomes

```
awk 'BEGIN {RS=">"} /Chr/ {print ">"$0}' XT9_1.fa |gzip >XT9_1_chromosomes_only.fa.gz
```

# Aligning *X. mellotropicalis* against *X. tropicalis*

## Nucmer

`running_nucmer_arg.sh`
```sh
#!/bin/sh
#SBATCH --job-name=nucmer
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem=50gb
#SBATCH --output=nucmer.%J.out
#SBATCH --error=nucmer.%J.err
#SBATCH --account=[account]
#SBATCH --mail-user=[email]
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

#module load nixpkgs/16.09 gcc/5.4.0 mummer-64bit/3.23
module load nixpkgs/16.09 gcc/5.4.0 mummer/4.0.0beta2 #for mummerplot

nucmer -mumreference $1 -p $2 $3
delta-filter -q $2.delta -l 1000 -i 80 > $2.filtered_q.delta
show-coords -r -c -l $2.delta > $2.coords
#show-snps -C $2.delta > $2.snps 
show-tiling $2.delta > $2.tiling

mummerplot -c $2.tiling -p $2.$4.mummerplot -r $4 --png

#do not see anything
#mummerplot $2.delta -p $2.$4.delta.mummerplot -r $4 -l -x [$5,$6] --png

mummerplot -c $2.filtered_q.delta -p $2.$4_$5_$6.filtered_q.delta.mummerplot -r $4 -x [$5,$6] --png
mummerplot $2.filtered_q.delta -p $2.$4_$5_$6.filtered_q.delta.dotplot.mummerplot -r $4 --png

#example: sbatch ~/project/cauretc/scripts/running_nucmer_arg.sh /home/cauretc/projects/rrg-ben/cauretc/reference_genomes/Xtrop9.1/XT9_1_chromosomes_only.fa nucmer_XT9_1_chrom_SOAP_Mellotropicalis_BJE3652_47_61mers_1kb /home/cauretc/projects/rrg-ben/cauretc/SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_47_61mers_1kb.fa Chr10
```
Note: `mummer-64bit` necessary otherwise genome to big to build the initial tree.

The `nucmer`, `show-coords`, `show-snps`, `show-tilling` took `Run time 14:58:57` to finish.

Doing a coverage/identity plot with `mummerplot` on the tilling output takes some min for each *X. tropicalis* chromosomes separately.
To be able to use the installed `mummerplot` I had to swith to `mummer/4.0.0beta2` otherwise issue with `perl` versions and cannot use the fixed way suggested by people on similar issues because of permission on graham (or will have to install myself...).
```
Can't use 'defined(%hash)' (Maybe you should just omit the defined()?) at /cvmfs/soft.computecanada.ca/easybuild/software/2017/avx2/Compiler/gcc5.4/mummer-64bit/3.23/bin/mummerplot line 884.
```

(1) I made a mummerplot on the result from tiling to check if we have an OK representation of the different *X. tropicalis* chromosome since:
```
show-tiling attempts to construct a tiling path out of the query contigs as mapped to the reference sequences. Given the delta alignment information of a few long reference sequences and many small query contigs, show-tiling will determine the best mapped location of each query contig.
```
(2) mummerplot on the delta result to see if we have at least 2 scaffolds for some region. `-x [$5,$6]` should be specified otherwise since we have a large amount of scaffolds it will not be visible.

(1) and (2) should be for a quick inference about how "bad" is our assembly and decide what to do next. I will prepare a pipeline anyways which we could run on better improved assembly. Both mummerplots might help us better understanding the potential issues with our assembly. It is highly preliminary look at the data and should be used only as such.

Note without any filtering downstream of `nucmer` command. The plots are not really readable. Setting up a filter of an alignemnt length of at least 1kb, a minimum alignment identity of 80%. The 80% would assume a high similarity between both subgenomes. Can adapt later.

## minimap2

```
#!/bin/sh
#SBATCH --job-name=minimap
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=1-00:00:00
#SBATCH --mem=50gb
#SBATCH --output=minimap.%J.out
#SBATCH --error=minimap.%J.err
#SBATCH --account=account
#SBATCH --mail-user=[email]
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

#$1=ref, $2=draft, $3=prefix
module load nixpkgs/16.09 gcc/7.3.0 minimap2/2.13 samtools/1.9

minimap2 -t 3 -ax asm20 --cs $1 $2 > $3.sam
samtools view -S -b $3.sam | samtools sort -o $3_sorted.bam
samtools flagstat $3_sorted.bam > $3_sorted.flagstat
samtools stats $3_sorted.bam > $3_sorted.stats
```
```
sbatch ~/project/cauretc/scripts/running_minimap_draft_ref_genome.sh /home/cauretc/projects/rrg-ben/cauretc/reference_genomes/Xtrop9.1/XT9_1_chromosomes_only.fa /home/cauretc/projects/rrg-ben/cauretc/SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_47_61mers_10kb.fa Mellotropicalis_BJE3652_47_61mers_10kb_trop_minimap2
```
Extracting the scaffolds ID and their `dv` values. `dv`: *Approximate per-base sequence divergence*.
```
samtools view Mellotropicalis_BJE3652_47_61mers_10kb_trop_minimap2_sorted.bam | cut -f1,20 | grep "dv:" >scaffolds.dv
```
