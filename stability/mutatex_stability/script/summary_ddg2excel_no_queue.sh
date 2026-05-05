#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: no PDB file specified. Usage: bash run_ddg2excel_local.sh <filename.pdb>"
    exit 1
fi

STRUCTURES_DIR=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/structures
PDB_FILE=$STRUCTURES_DIR/$1

if [ ! -f "$PDB_FILE" ]; then
    echo "Error: file $PDB_FILE does not exist"
    exit 1
fi

PROTEIN_NAME=$(basename $1 .pdb)
SCRIPT_DIR=$(dirname "$0")
RESULTS_DIR=$SCRIPT_DIR/../results/$PROTEIN_NAME

source /home/ctools/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate /home/ctools/protein_structure_course

echo "Running ddg2excel on $PROTEIN_NAME ..."

ddg2excel \
    -p $PDB_FILE \
    -l $SCRIPT_DIR/mutation_list.txt \
    -q $SCRIPT_DIR/poslist.txt \
    -d $RESULTS_DIR/results/mutation_ddgs/${PROTEIN_NAME}_model0_checked_Repair/ \
    -F csv

echo "done"