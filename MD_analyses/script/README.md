# MD Analysis – Bak1 2IMS

This folder contains the molecular dynamics (MD) analysis of Bak1 protein (2IMS chain A) performed on three independent simulations. The workflow includes trajectory concatenation, RMSD calculation, and clustering analysis.

---

## Workflow

1. **Concatenate Trajectories**  
   Combine the three independent simulations into a single trajectory:

```bash
gmx trjcat -f 2ims_A_R1.xtc 2ims_A_R2.xtc 2ims_A_R3.xtc -o 2ims_A_concat.xtc
```

2. **RMSD Analysis**
    Calculate RMSD over the concatenated trajectory and generate RMSD matrix:
```bash
gmx_mpi rms -f 2ims_A_concat.xtc -s 2ims_A_R1.tpr -o rmsd_concat.xvg -m rmsd_matrix_concat.xpm
```

3. **Clustering Analysis**
    Perform GROMOS clustering (cutoff 0.24 nm) on the RMSD matrix:

```bash
gmx_mpi cluster -f 2ims_A_concat.xtc -s 2ims_A_R1.tpr -dm rmsd_matrix_concat.xpm \
-o rmsd_clust.xpm -g cluster.log -sz clust_size.xvg -cl clusters.pdb \
-clid clust_id.xvg -method gromos -cutoff 0.24
```