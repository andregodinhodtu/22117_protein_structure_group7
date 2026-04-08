#!/bin/bash
# Note: No unix commands may be executed until after the #SBATCH lines
# Notice how the options are used on the #SBATCH lines
# Requesting time (2 hours)
#SBATCH -t 2:00:00
# Memory required (4 Gigs)
#SBATCH --mem=4G
# Number of cores on the node (1 core)
#SBATCH -c 1
#SBATCH -o structure_selection_script.log
#SBATCH -e structure_selection_script.err
# Accounting - if necessary
#SBATCH -A pr_course
# Here follows the user commands:


# Change to the directory from which the job was submitted
cd $SLURM_SUBMIT_DIR

#activate environment
source /home/ctools/protein_structure_course/bin/activate

echo "Running PDBminer..."

# Execute your program
PDBminer -u Q16611 -n 2 -f csv

echo "done"
