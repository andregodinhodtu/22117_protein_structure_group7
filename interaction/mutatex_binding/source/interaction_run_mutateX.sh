#!/bin/bash
# Requesting time
#SBATCH -t 20:00:00
# Memory required
#SBATCH --mem=16G
# Number of cores on the node (1 core)
#SBATCH -c 4
# Output file
#SBATCH -o mutateX.log
#SBATCH -e mutateX.err
# Folder for execution
#SBATCH -D /home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/priority_mutateX_run

# Queuing system is currently not working, so we have to make sure to change directory at the beginning of the script
cd /home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/priority_mutateX_run

structure=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/structures/6UXR_dimer_clean.pdb

mutatex $structure \
	-p 4 -m ../mutation_list.txt \
	-x /home/ctools/foldx/foldx \
	-f suite5 -R ../repair_runfile_template.txt \
	-M ../mutate_runfile_template.txt -q ../priority_poslist.txt \
	-L -l -v -C  deep -B  -I ../interface_runfile_template.txt
