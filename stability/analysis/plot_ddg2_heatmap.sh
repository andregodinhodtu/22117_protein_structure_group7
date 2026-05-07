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
FINAL_AVERAGES=$MUTATE_X_RUN_DIR/results/final_averages
MUTATIONS_VAL=$MUTATE_X_RUN_DIR/results/mutation_ddgs/2IMT_clean_model0_checked_Repair
POS_LIST=$WORKING_DIR/poslist.txt

source /home/ctools/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate /home/ctools/protein_structure_course

# Sanity checks
for f in "$CHECKED_PDB" "$MUTATION_LIST" "$POS_LIST"; do
    [[ -f "$f" ]] || { echo "Missing file: $f" >&2; exit 1; }
done
[[ -d "$MUTATIONS_VAL" ]] || { echo "Missing directory: $MUTATIONS_VAL" >&2; exit 1; }

cd "$WORKING_DIR"

ddg2heatmap \
    -p "$CHECKED_PDB" \
    -l "$MUTATION_LIST" \
    -d "$MUTATIONS_VAL" \
    -s 25 \
    -n -2.0 \
    -x 5.0 \
    -q "$POS_LIST"