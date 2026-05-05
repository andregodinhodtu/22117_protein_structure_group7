#!/bin/bash
set -euo pipefail

# Base paths
BASE=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7
WORKING_DIR=$BASE/stability/analysis
MUTATE_X_RUN_DIR=$BASE/stability/mutatex_stability/results/2IMT_clean

# Inputs
CHECKED_PDB=$MUTATE_X_RUN_DIR/2IMT_clean_model0_checked.pdb
MUTATION_LIST=$WORKING_DIR/mutation_list.txt
FINAL_AVERAGES=$MUTATE_X_RUN_DIR/results/mutation_ddgs/final_averages

# Sanity checks
for f in "$CHECKED_PDB" "$MUTATION_LIST"; do
    [[ -f "$f" ]] || { echo "Missing file: $f" >&2; exit 1; }
done
[[ -d "$FINAL_AVERAGES" ]] || { echo "Missing directory: $FINAL_AVERAGES" >&2; exit 1; }

cd "$WORKING_DIR"

ddg2histo \
    -d "$FINAL_AVERAGES" \
    -p "$CHECKED_PDB" \
    -l "$MUTATION_LIST" \
    -r SA69 