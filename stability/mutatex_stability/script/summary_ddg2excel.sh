#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH --mem=4G
#SBATCH -c 1
#SBATCH -o ddg2excel.log
#SBATCH -e ddg2excel.err
#SBATCH -A pr_course

cd $SLURM_SUBMIT_DIR

if [ -z "$1" ]; then
    echo "Error: no PDB file specified. Usage: sbatch run_ddg2excel.sh <filename.pdb>"
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

source /home/ctools/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate /home/ctools/protein_structure_course

echo "Running ddg2excel on $PROTEIN_NAME ..."

ddg2excel \
    -p $PDB_FILE \
    -l $SLURM_SUBMIT_DIR/mutation_list.txt \
    -q $SLURM_SUBMIT_DIR/poslist.txt \
    -d $RESULTS_DIR/results/mutation_ddgs/${PROTEIN_NAME}_model0_checked_Repair/ \
    -F csv

echo "done"