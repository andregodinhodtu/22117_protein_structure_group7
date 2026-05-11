# Protein Structure Analysis Project – Group 7

This project was developed as part of the course **22117: Protein Structure and Computational Biology (Spring 2026)** by students of Group 7.  

It focuses on the analysis of **BAK1 protein variants**, including their **stability, solvent accessibility, binding interactions, and structural modeling**.  

**Authors:**  
- **André Godinho** (s25370)  
- **Louis Page** (s25372)  
- **Veronica Miscu** (s215159)  
- **Maxence Marbouty** (s253730)  
- **Emma Jinschek** (s253599)  

---

## Folder Overview

- **mavisp/**  
  Contains scripts and raw data for variant plotting.  
  - `plotting_variants_mavisp.R` → R script to visualize variant effects.  
  - `raw_data/` → Input data for plotting.  
  - `mutations_per_position.png` → Example output plot.

- **22117_protein_structure_group7.Rproj**  
  RStudio project file.

- **MD_analyses/**  
  Contains molecular dynamics analysis data.  
  - `atlas_data/` → Processed MD datasets.

- **structures/**  
  Cleaned and original PDB structures used for analysis.  
  - Examples: `2IMT_clean.pdb`, `6UXR_dimer_clean.pdb`.

- **naccess_analysis/**  
  Scripts and outputs related to solvent accessibility calculations.  
  - `nacess_plot.R` → Script to generate solvent accessibility plots.  
  - `nacess_plot_final.png`

- **interaction/**  
  Contains interaction analyses and scripts.  
  - `mutatex_binding/` → MutateX binding energy analysis.  
  - `naccess/` → NACCESS analysis related to interactions.

- **stability/**  
  Stability analysis using MutateX and NACCESS.  
  - `analysis/` → Plots and results (ΔΔG distributions, heatmaps).  
  - `mutatex_stability/` → FoldX/MutateX calculations and scripts.  
  - `naccess/` → Solvent accessibility calculations.

- **final_figures/**  
  Summary figures for presentations and publications.  
  - Includes heatmaps, PyMol snapshots, and stability plots.

- **ensemble_work/**  
  Ensemble modeling and structural mutagenesis.  
  - `repair/`, `clean_run/` → Intermediate PDB files and repaired structures.  
  - `mutate_runfile_template.txt`, `repair_runfile_template.txt` → FoldX run templates.

- **prediction_of_phatogenicity/**  
  Scripts and results for pathogenicity predictions.  
  - `alpha_missense/`, `alphamissense_demask_plot/`, `demask/`.

- **structure_selection/**  
  Scripts and logs for selecting representative structures.  
  - Includes selection logs and results.

- **LICENSE**  
  License file for the project.

---

## Analysis Workflow

1. **Structure Preparation**  
   - PDB files cleaned (`structures/`) and repaired using FoldX (`ensemble_work/repair`).

2. **Solvent Accessibility**  
   - `NACCESS` calculates side-chain solvent accessibility.  
   - Scripts in `stability/naccess/script/`.

3. **Stability Analysis (Single Structure)**  
   - `MutateX` used to calculate ΔΔG values for selected mutations (range: -2 to 5 kcal/mol, 4 CPU cores).  
   - Scripts located in `stability/` and `interaction/`.

4. **Molecular Dynamics Simulations**  
   - MD simulations performed to generate multiple conformations of the protein.  

5. **Ensemble Stability Analysis**  
   - `MutateX` ensemble mode applied to the MD-generated structures.  
   - Evaluates mutation effects across the conformational ensemble.  
   - Ensemble scripts and repaired structures stored in `ensemble_work/`.

6. **Plotting & Figures**  
   - Results visualized in `analysis/figures_and_plots/` and `final_figures/`.

---
