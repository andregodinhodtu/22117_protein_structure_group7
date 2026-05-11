#!/bin/bash

# Script to create a general folder containing informations from both the priority and the complementary run

OUTDIR=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/full_scan_ddgs/final_averages/

PRIO_RUN=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/priority_mutateX_run/results/interface_ddgs/final_averages/A-B
COMP_RUN=/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding/complementary_mutateX_run/results/interface_ddgs/final_averages/A-B


mkdir -p -m 777 $OUTDIR

cp $PRIO_RUN/* $OUTDIR
cp $COMP_RUN/* $OUTDIR


