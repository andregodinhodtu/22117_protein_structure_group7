#!/bin/bash
# Requesting time
#SBATCH -t 20:00:00
# Memory required
#SBATCH --mem=16G
# Number of cores on the node (1 core)
#SBATCH -c 4
# Output file
#SBATCH -o ddg2.log
#SBATCH -e ddg2.err
# Folder for execution
#SBATCH -D /home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/complementary_mutateX_run/plots

# Queuing system is currently not working, so we have to make sure to change directory at the beginning of the script
cd /home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/complementary_mutateX_run/plots

structure=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/structures/6UXR_dimer_clean.pdb

ddg2excel -p $structure -l ../../mutation_list.txt -q ../../complementary_poslist.txt -d ../results/interface_ddgs/final_averages/A-B/ -F csv
ddg2heatmap -p $structure -l ../../mutation_list.txt -q ../../complementary_poslist.txt -d ../results/interface_ddgs/final_averages/A-B/  -s 30 -x 5
