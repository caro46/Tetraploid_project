#!/bin/sh
#SBATCH --job-name=meraculous_61pelib
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=10:00:00
#SBATCH --mem=200gb
#SBATCH --output=meraculous_61pelib.%J.out
#SBATCH --error=meraculous_61pelib.%J.err
#SBATCH --account=def-ben
#SBATCH --mail-user=cauretc@mcmaster.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

module load nixpkgs/16.09  gcc/4.8.5 meraculous/2.2.4
##61mers
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.61.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer #ntasks-per-node=16 time=3-00:00:00

#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.61.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer #1D limit 
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.61.config -dir /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_61mer_2018-04-09_07h49m27s -resume #2D

#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.61.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer -step meraculous_import

##61mer-includiing pe from mp
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.61with300bp.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer_all_pe #try with 2000s - OK so 3D

##51
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.51.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_51mer_all_pe #--time=3-00:00:00, --ntasks-per-node=16 --mem=200gb

##61mer, genome size as paratrop 
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_paratrop_size.57.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_57mer_paratrop_size #--time=1-00:00:00 --ntasks-per-node=16
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_paratrop_size_keepvar.61.config /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer_paratrop_size_keepallvar
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_paratrop_size_keepvar_nomatepe.61.config /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_61mer_paratrop_size_keepallvar_nomatepe #5h
run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop_paratrop_size_keepvar_nomatepe.61.config -dir /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_61mer_paratrop_size_keepallvar_nomatepe_2018-04-18_07h21m22s -resume #trying 10h

##Restart/resume
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.config -dir /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_2018-03-14_20h11m18s -resume #stopped because of time, --ntasks-per-node=8, --mem=200gb

#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.config -dir /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_2018-03-14_20h11m18s -restart -start meraculous_mercount #setting the depth cuttoff to 4

##45mers
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.45.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly_45mer
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.45.config -dir /home/cauretc/scratch/meraculous/mellotropicalis_meraculous_assembly_45mer_2018-03-18_14h03m01s -restart -start meraculous_mercount #depth cuttoff to 5, --ntasks-per-node=16, --mem=200gb

##Initial run
#run_meraculous.sh -c /home/cauretc/scratch/meraculous/mellotrop.config -dir /home/cauretc/scratch/meraculous -label mellotropicalis_meraculous_assembly #8task
