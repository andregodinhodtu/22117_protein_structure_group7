#!/bin/bash
# Note: No unix commands may be executed until after the #SBATCH lines
# Notice how the options are used on the #SBATCH lines
# Requesting time (2 hours)
#SBATCH -t 2:00:00
# Memory required (4 Gigs)
#SBATCH --mem=4G
# Number of cores on the node
#SBATCH -c 1
#SBATCH -o stability_mutate_x_script.log
#SBATCH -e stability_mutate_x_script.err
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

echo "Running MutateX on $PDB_FILE ..."

mutatex $PDB_FILE \
    -p 1 \
    -m $SLURM_SUBMIT_DIR/mutation_list.txt \
    -x /home/ctools/foldx/foldx \
    -f suite5 \
    -R $SLURM_SUBMIT_DIR/repair_runfile_template.txt \
    -M $SLURM_SUBMIT_DIR/mutate_runfile_template.txt \
    -q $SLURM_SUBMIT_DIR/poslist.txt \
    -L -l -v \
    -C none

echo "Running ddg2excel ..."

ddg2excel \
    -p $PDB_FILE \
    -l $SLURM_SUBMIT_DIR/mutation_list.txt \
    -q $SLURM_SUBMIT_DIR/poslist.txt \
    -d $RESULTS_DIR/results/mutation_ddgs/${PROTEIN_NAME}_model0_checked_Repair/ \
    -F csv

echo "done"
