- André Godinho s253707

Q16611 - BAK_HUMAN
Protein - Bcl-2 homologous antagonist/killer
Gene - BAK1

Assesssment of effects of mutations on STABILITY using MutateX (i.e., FoldX) changes in folding free energies (Lecture 4)

# Domain

Motif		74-88	BH3	
Motif		117-136	BH1	
Motif		169-184	BH2

Intact BH3 motif is required by BIK, BID, BAK, BAD and BAX for their pro-apoptotic activity and for their interaction with anti-apoptotic members of the Bcl-2 family.

## Binding site for cofactor

Binding site		160	Zn2+ (UniProtKB | ChEBI); ligand shared between dimeric partners	

Binding site		164	Zn2+ (UniProtKB | ChEBI); ligand shared between dimeric partners

# Important things for mutateX

0. Make sure that we have no waters and cofactors

1. Modifications needed in the input if we have missing residues - solve with AlphaFold

Remember also to check for missing residues in the structure you aim to use. FoldX will not be able to reconstruct missing residues. If there are missing residues, FoldX will try to run the calculation in the presence of missing residues within the structure. As FoldX does not reconstruct missing residues, it performs the calculation on the input structure used. If your candidate structure has missing residues, it is good to reconstruct them, for example, using homology modeling or evaluating if a model from AlphaFold can recapitulate the known experimental structure and use it for your calculations.

We need to make sure that there are no missing residues in this PDB file, apart from residues in the N- and C-terminal regions which are not a big problem

2. Visual inspection of the mutation sites with PyMOL

2.1 Should look into the intresting mutation sites and localize them in PyMOL. 

- Where are the mutations located on the protein? What does the location in the structure imply? 

- Identify if there are other residue side chains in contact with the mutation site (less than 4 Å of distance) and which properties they have. Show the residues within 4 Å of each site and reflect on interactions with the mutational site. ( show sticks, residue 120 + residue 181 + residue 270) (navigate through the menu option and select modify -> expand -> residues within 4 Å. This widens the selection to include residues around residue 181)

3. Preparation of a folder to run NACCESS and MutateX on the server

> naccess

usage naccess pdb_file [-p probe_size] [-r vdw_file] [-s stdfile] [-z zslice] -[hwyfaclq]

output: 2XWRA_noHOH.rsa

The file has a tabular format,it is structured in rows (one per residue) and columns (different ASA values).

We are interested in the column of Total-Side and Relative values (REL) since it provides a percentage estimate of the solvent accessibility of the side chain with respect to the accessibility for that residue type in a tripeptide, in which the residue is surrounded by alanine residue

We can basically undestand if the resideu is burried or in the surface

Example of usage: > grep 270 2XWRA_noHOH.rsa

4. Free energy calculations with MutateX to estimate changes in folding free energy upon mutation

So typical MutateX command line should look like:

> mutatex -x /home/ctools/foldx/foldx -f suite5 --all --other --option



