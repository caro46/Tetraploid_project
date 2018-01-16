#!/bin/sh
#SBATCH --job-name=lordec
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --time=144:00:00
#SBATCH --mem=16gb
#SBATCH --output=lordec.%J.out
#SBATCH --error=lordec.%J.err
#SBATCH --account=<account>
#SBATCH --mail-user=<email>
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

/home/cauretc/project/cauretc/programs/LoRDEC-0.5.3-Source/build/tools/lordec-correct -2 /home/cauretc/scratch/lordec_analysis/input_metalist.txt -k 19 -s 3 -i /home/cauretc/scratch/pacbio_mellotrop/BJE3652.all.subreads.fasta.gz -o /home/cauretc/scratch/lordec_analysis/BJE3652.all.subreads.lordec.fasta &> /home/cauretc/scratch/lordec_analysis/lordec.log
