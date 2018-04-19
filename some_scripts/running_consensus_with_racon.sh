#!/bin/sh
#SBATCH --job-name=consensus_racon_DBG2OLC
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --time=3-00:00:00
#SBATCH --mem=100gb
#SBATCH --output=consensus_racon_DBG2OLC.%J.out
#SBATCH --error=consensus_racon_DBG2OLC.%J.err
#SBATCH --account=def-ben
#SBATCH --mail-user=cauretc@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

#1st run

##mapping the pacbio reads to the draft genome to obtain a paf format using minimap
/home/cauretc/project/cauretc/programs/minimap2/minimap2 -x map-pb -t5 /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/backbone_raw.fasta /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads_uppercase.fasta | gzip -1 >/home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop_minimap_reads_mapped.paf.gz   

##consensus with racon
/home/cauretc/project/cauretc/programs/racon/bin/racon -t 5 /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads_uppercase.fasta /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop_minimap_reads_mapped.paf.gz /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/backbone_raw.fasta /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon1.fa

#2nd run

##mapping the pacbio reads to the 1st racon consensus assembly 
/home/cauretc/project/cauretc/programs/minimap2/minimap2 -x map-pb -t5 /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon1.fa /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads_uppercase.fasta | gzip -1 >/home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon1_reads_mapped.paf.gz 

##2nd consensus run to improve accuracy with racon
/home/cauretc/project/cauretc/programs/racon/bin/racon -t 5 /home/cauretc/scratch/HALC_analysis/BJE3652.all.subreads_uppercase.fasta /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon1_reads_mapped.paf.gz /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon1.fa /home/cauretc/scratch/DBG2OLC_meraculous/contigs_only_short_insert/consensus_racon/DBG2OLC_consensus_pacbio_mellotrop.racon2.fa

