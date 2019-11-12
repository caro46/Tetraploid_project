
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

```
```
