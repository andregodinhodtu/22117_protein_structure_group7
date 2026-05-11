# Local Interaction Analysis of BAK1 Using MutateX/FoldX

**Student:** Maxence Marbouty (`s253730`)  
**Structure used:** `6UXR` (Activated BAK1 Dimer)

## Overview
This folder contains the computational pipeline used to assess the effects of mutations on the **local interaction** (binding affinity) of the BAK1 dimer. The analysis follows the methodology described in the project report, utilizing `MutateX` and `FoldX` to calculate changes in binding free energy ($\Delta\Delta G_{bind}$).

## Folder Structure

### 1. Analysis Subdirectories
- `Naccess/`: Contains the solvent accessibility analysis (SASA) performed on the dimerized structure `6UXR`. 
- `mutatex_binding/`: The main directory for the binding energy calculations.
    - `source/`: Contains all scripts used for processing and execution.
    - `priority_mutateX_run/`: Results of the initial run focused on the priority clinical variant list.
    - `complementary_mutateX_run/`: Results of the saturation mutagenesis run for the complementary subset of residues.
    - `full_scan_ddgs/`: Aggregated and averaged $\Delta\Delta G$ data used for generating final heatmaps and figures.

### 2. Input & Configuration Files (mutatex_binding/)
These files define the parameters and targets of the MutateX runs:
- `*_poslist.txt`: Lists of specific residues targeted for mutagenesis (Priority, Complementary, and full Interface).
- `*_runfile_template.txt`: Configuration templates for the MutateX pipeline, defining FoldX parameters.
- `mutation_list.txt`: Specific amino acid substitutions defined for the priority clinical subset.

## Methodology & Execution

### Computational Strategy
Most of scripts in the `source/` folder were originally designed to be submitted to the DTU cluster queuing system. However, due to system downtime during the project, the calculations were executed using `nohup` to ensure continuous processing.

The exact command lines used for these background executions are documented in:
`mutatex_binding/source/syntax_nohup.sh`

Other quick scripts for creating directories and moving files (e.g., `make_results_folders.sh`, `moving_files.sh`, `gathering_runs.sh`) were manually executed using `./script.sh`.

### Environment
- **Python:** 3.12.9 
- **Pipeline:** MutateX
- **Engine:** FoldX (suite5)
- **Parameters:** Parallelization on 4 threads, *deep* cleaning mode.
