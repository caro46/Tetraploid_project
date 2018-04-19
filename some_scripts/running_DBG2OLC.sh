#!/bin/sh
#SBATCH --job-name=DBG2OLC
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=3-00:00:00
#SBATCH --mem=100gb
#SBATCH --output=DBG2OLC.%J.out
#SBATCH --error=DBG2OLC.%J.err
#SBATCH --account=def-ben
#SBATCH --mail-user=cauretc@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

/home/cauretc/project/cauretc/programs/DBG2OLC/compiled/DBG2OLC k 17 KmerCovTh 2 MinLen 3000 RemoveChimera 1 MinOverlap 20 AdaptiveTh 0.0001 LD 0 Contigs /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_2018-03-14_20h11m18s/meraculous_merblast/contigs.fa f /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads_uppercase.fasta >/home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/run_1DBG2OLC_meraculous.log

