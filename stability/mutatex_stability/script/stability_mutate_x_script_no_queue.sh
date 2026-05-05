#!/bin/bash
# Requesting time (6 hours)
#SBATCH -t 6:00:00
# Memory required (4 Gigs)
#SBATCH --mem=4G
# Number of cores on the node
#SBATCH -c 4
#SBATCH -o stability_mutate_x_script.log
#SBATCH -e stability_mutate_x_script.err
# Accounting - if necessary
#SBATCH -A pr_course

SCRIPT_DIR=$(dirname $(realpath $0))
cd $SCRIPT_DIR

if [ -z "$1" ]; then
    echo "Error: no PDB file specified. Usage: sbatch stability_mutate_x_script.sh <filename.pdb>"
    exit 1
fi

STRUCTURES_DIR=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/structures
PDB_FILE=$STRUCTURES_DIR/$1

if [ ! -f "$PDB_FILE" ]; then
    echo "Error: file $PDB_FILE does not exist"
    exit 1
fi

PROTEIN_NAME=$(basename $1 .pdb)
RESULTS_DIR=$SCRIPT_DIR/../results/$PROTEIN_NAME

mkdir -p $RESULTS_DIR
cd $RESULTS_DIR

source /home/ctools/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate /home/ctools/protein_structure_course

echo "Running MutateX on $PDB_FILE ..."

mutatex $PDB_FILE \
    -p 4 \
    -m $SCRIPT_DIR/mutation_list.txt \
    -x /home/ctools/foldx/foldx \
    -f suite5 \
    -R $SCRIPT_DIR/repair_runfile_template.txt \
    -M $SCRIPT_DIR/mutate_runfile_template.txt \
    -q $SCRIPT_DIR/poslist.txt \
    -L -l -v \
    -C deep

# -C option can be deep or none