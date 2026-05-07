

# Structure Selection

## Overview
This folder contains the structure selection section for the BAK1 project.
The aim of this analysis was to identify the most appropriate BAK1 structures for downstream work, including structure assessment and docking-related interpretation.

## Methods
To select appropriate BAK1 structures for downstream analysis, the available entries for the human BAK1 protein (UniProt ID Q16611) were filtered using structural quality criteria. 
The structures were screened according to experimental method, resolution, R-free, presence of mutations, whether they represented a free protein or a complex, and coverage of the regions of interest. 
PDBMiner was used to rank the available structures, and AlphaFold/AlphaFold3 were used as comparison models to evaluate agreement with the experimental structures.

## Filtering steps
1. Filter the Excel file for structures solved by X-ray diffraction.
2. Keep only structures with a resolution better than 2.5 Å.
3. Check the coverage of each structure.
4. Remove protein complexes. (skipped for the filtering of the active protein structure)
5. Select the structure with no mutations, the highest coverage, and the best resolution.

## Selected Structures
- 2IMT: selected as the main structure for most of the downstream analysis because it gave the best overall balance between structural quality and biological relevance.
- 6UXR: included as a complementary structure for local interaction analysis and the dimer-related part of the project.

## Results Summary
2IMT was chosen as the primary reference structure because it was solved by X-ray diffraction at 1.49 Å resolution, had an R-free value of 0.2201, had no reported mutations, and provided good coverage of the protein region of interest. 
6UXR was retained as a supporting structure because it provides additional information for local interactions and conformational differences relevant to the dimeric state.

## Files in this folder
- `structure_selection_script.sh`: Shell script used to run the structure selection workflow.
- `structure_selection_script.log`: Log file generated during the run, containing the output and any messages from the script.
- `structure_selection_script.err`: Error file generated during the run, containing any warnings or errors.
- `input_file.csv`: Input file used by the script, containing the structure data that was filtered during selection.
- `results`: folder in which the output csv file was saved to, which includes the list of all Q16611 Uniprot entries that were experimentally resolved.

## Notes
This section was prepared to support the later docking analysis and to justify the choice of 2IMT as the main structure and 6UXR as the supporting structure.
