#!/bin/bash
set -euo pipefail

# Base paths
BASE=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7
WORKING_DIR=$BASE/stability/analysis
MUTATE_X_RUN_DIR=$BASE/stability/mutatex_stability/results/2IMT_clean
STRUCTURES_DIR=$BASE/structures

# Inputs
CHECKED_PDB=$MUTATE_X_RUN_DIR/2IMT_clean_model0_checked.pdb
MUTATION_LIST=$WORKING_DIR/mutation_list.txt
FINAL_AVERAGES=$MUTATE_X_RUN_DIR/results/mutation_ddgs/final_averages
POS_LIST=$WORKING_DIR/poslist.txt

cd "$WORKING_DIR"

ddg2distribution \
    -p "$CHECKED_PDB" \
    -d "$FINAL_AVERAGES" \
    -l  "$MUTATION_LIST" \
    -q "$POS_LIST" \
    -o distribution.png \
    -s 25 \
    -x 50 \
    -n -10 \
    -T scatter

# -T could be  { stem , box , violin , average , scatter }