
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

module load nixpkgs/16.09 gcc/5.4.0 mummer-64bit/3.23

nucmer -mumreference $1 -p $2 $3
show-coords -r -c -l $2.delta > $2.coords
show-snps -C $2.delta > $2.snps
show-tiling $2.delta > $2.tiling

#example: sbatch ~/project/cauretc/scripts/running_nucmer_arg.sh /home/cauretc/projects/rrg-ben/cauretc/reference_genomes/Xtrop9.1/XT9_1_chromosomes_only.fa nucmer_XT9_1_chrom_SOAP_Mellotropicalis_BJE3652_47_61mers_1kb /home/cauretc/projects/rrg-ben/cauretc/SOAP_assemblies/SOAP_Mellotropicalis_BJE3652_47_61mers_1kb.fa
```
Note: `mummer-64bit` necessary otherwise genome to big to build the initial tree.
