# Stability Analysis of BAK1 Using MutateX/FoldX

**Student:** André Godinho (`s253707`)  
**Structure used:** `2IMT`

Positive ΔΔG values indicate destabilizing mutations.

Assesssment of effects of mutations on STABILITY using MutateX (i.e., FoldX) changes in folding free energies (Lecture 4)

---

## Repository Structure

stability/
├── README.md
├── analysis/
│   ├── energies.csv
│   ├── figures_and_plots/
│   └── plot_ddg2_*.sh
├── mutatex_stability/
│   ├── results/ (Not in git)
│   │   ├── 2IMT_clean/
│   │   │   ├── repair/
│   │   │   ├── results/
│   │   │   └── mutations/
│   │   └── 2IMT_clean_model0_checked.pdb
│   └── script/
│       ├── summary_ddg2excel.sh
│       ├── stability_mutate_x_script.sh
│       ├── mutate_runfile_template.txt
│       ├── repair_runfile_template.txt
│       ├── mutation_list.txt
│       └── poslist.txt
├── naccess/
│   ├── results/
│   │   └── 2IMT_no_solvent.rsa
│   └── script/
│       ├── stability_naccess_script.sh
│       ├── stability_naccess_script.log
│       └── stability_naccess_script.err
├── priority_poslist.txt (list priority to run mutate x)
└── complementary_poslist.txt (not priority to run mutate x)

---

## Workflow

1. **Structure Preparation**  
   - Removed water molecules and cofactors.  
   - Checked for missing residues; used AlphaFold or homology modeling if needed.  

2. **Solvent Accessibility (NACCESS)**  
   - Calculated which residues are buried or exposed.  
   - Relative side-chain accessibility used to identify surface vs buried residues.

3. **Stability Calculations (MutateX/FoldX)**  
   - **Repaired structure:** Fixed clashes and minimized energy.  
   - **Mutation modeling:** Introduced mutations at selected positions and calculated ΔΔG.  
   - **ΔΔG range analyzed:** -2 to 5 kcal/mol  
   - **CPU cores used:** 4  

### MutateX/FoldX Options Used

| Option | Description |
|--------|-------------|
| `-p 4` | Use 4 CPU cores for parallel processing. |
| `-m mutation_list.txt` | Specifies the list of mutations to introduce. |
| `-x /path/to/foldx` | Path to the FoldX executable used for calculations. |
| `-f suite5` | FoldX force field/parameter set. |
| `-R repair_runfile_template.txt` | Template for repairing PDB structure (removing clashes, fixing side chains). |
| `-M mutate_runfile_template.txt` | Template for mutation modeling (BuildModel step). |
| `-q poslist.txt` | List of residue positions to mutate. |
| `-L` | Log progress for each mutation to monitor long runs. |
| `-l` | Save all intermediate output files for detailed inspection. |
| `-v` | Verbose output for detailed process information. |
| `-C deep` | Deep scan mode for exhaustive rotamer sampling to improve ΔΔG accuracy. |

4. **Analysis and Plots**  
   - Generated tables of ΔΔG values.  
   - Created heatmaps, histograms, violin plots, and scatter plots to visualize stability changes.  
   - Positive ΔΔG → destabilizing mutation  
   - Negative ΔΔG → stabilizing mutation  

---

## Results

- `energies.csv` — ΔΔG values for all mutations  
- Plots in `analysis/` show the distribution of stability changes and highlight residues most sensitive to mutation.  