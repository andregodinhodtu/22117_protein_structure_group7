#!/bin/bash

# Because the queuing system was not working, we used nohup to execute our job in the background, instead of sbatch.

# To begin with, do not forget to activate the conda environment, mandatory for the script to run:

conda activate /home/ctools/protein_structure_course

# Here are the different command we used, to execute the .sh bash scripts we had prepared:

# For the first batch of selected residues:

nohup ./interaction_run_mutateX.sh > nohup_mutatex.out 2>&1 &

# and the corresponding ddg2 analysis

nohup ./make_ddg2_plots.sh > nohup_ddg2plots.out 2>&1 &

# then for the complementary residues:

nohup ./complementary_run_mutateX.sh > nohup_comp_mutatex.out 2>&1 &
nohup ./ddg2_plots_complementary.sh > nohup_comp_ddg2plots.out 2>&1 &
