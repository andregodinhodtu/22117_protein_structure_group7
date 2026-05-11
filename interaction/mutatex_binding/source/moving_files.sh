#!/bin/bash

# This script is to be used as a command line, as it's just file manipulation
# Goal: move(copy) all files necessary for a mutatex run for local interaction from the course folder to our project one

# Create destination folder
MutateX_folder="/home/projects/22117_protein_structure/projects/group07/22117_protein_structure_group7/interaction/mutatex_binding"
Course_folder="/home/projects/22117_protein_structure/lecture6/mutatex_binding_templates"

cp "$Course_folder"/repair_runfile_template.txt "$MutateX_folder"
cp "$Course_folder"/mutate_runfile_template.txt "$MutateX_folder"
cp "$Course_folder"/mutation_list.txt "$MutateX_folder"
cp "$Course_folder"/interface_runfile_template.txt "$MutateX_folder"
