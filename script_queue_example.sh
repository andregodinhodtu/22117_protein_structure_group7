#!/bin/bash
# Note: No unix commands may be executed until after the #SBATCH lines
# Notice how the options are used on the #SBATCH lines
# Requesting time (2 hours)
#SBATCH -t 2:00:00
# Memory required (4 Gigs)
#SBATCH --mem=4G
# Number of cores on the node (1 core)
#SBATCH -c 1# Output file
#SBATCH -o test.log
#SBATCH -e test.err
# Folder for execution
#SBATCH -D /home/people/mylogin
# Accounting - if necessary
#SBATCH -A pr_course
# Here follows the user commands:


# Execute these programs
python myprogram.py
python myotherprogram.py
