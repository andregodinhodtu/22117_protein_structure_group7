#!/bin/bash
# Note: No unix commands may be executed until after the #SBATCH lines
# Notice how the options are used on the #SBATCH lines
# Requesting time (2 hours)
#SBATCH -t 2:00:00
# Memory required (4 Gigs)
#SBATCH --mem=4G
# Number of cores on the node (1 core)
#SBATCH -c 1
#SBATCH -o stability_naccess_script.log
#SBATCH -e stability_naccess_script.err
# Accounting - if necessary
#SBATCH -A pr_course
# Here follows the user commands:

cd $SLURM_SUBMIT_DIR

if [ -z "$1" ]; then
    echo "Error: no PDB file specified. Usage: sbatch script.sh <filename.pdb>"
    exit 1
fi

STRUCTURES_DIR=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/structures
PDB_FILE=$STRUCTURES_DIR/$1

if [ ! -f "$PDB_FILE" ]; then
    echo "Error: file $PDB_FILE does not exist"
    exit 1
fi

PROTEIN_NAME=$(basename $1 .pdb)
RESULTS_DIR=$SLURM_SUBMIT_DIR/../results/$PROTEIN_NAME

mkdir -p $RESULTS_DIR
cd $RESULTS_DIR

source /home/ctools/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate /home/ctools/protein_structure_course

echo "Running Naccess on $PDB_FILE ..."
naccess $PDB_FILE

echo "done"