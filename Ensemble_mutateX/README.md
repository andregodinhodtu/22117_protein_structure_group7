# Ensemble-mode MutateX Workflow (BAK1 BH3 motif)

## 1. Clean working directory

Keep only the required files:

```bash
find . -maxdepth 1 \
! -name '.' \
! -name 'clusters_A.pdb' \
! -name 'poslist.txt' \
! -name 'mutation_list.txt' \
! -name 'repair_runfile_template.txt' \
! -name 'mutate_runfile_template.txt' \
-exec rm -rf {} +
```

---

## 2. Verify residue numbering in the ensemble structure

Check that the BH3 motif positions match the ensemble PDB numbering:

```bash
grep "^ATOM" clusters_A.pdb | awk '$5=="A" && $6>=59 && $6<=73 {print $4,$5,$6}' | sort -u
```

Expected BH3 motif:

```text
VA74
GA75
RA76
QA77
LA78
AA79 
IA80 
IA81 
GA82
DA83 
DA84
IA85 
NA86 
RA87 
RA88 
```

---

## 3. Prepare position list

Contents of `poslist.txt`:

```text
VA59
GA60
RA61
QA62
LA63
AA64
IA65
IA66
GA67
DA68
DA69
IA70
NA71
RA72
RA73
```

---

## 4. Launch ensemble-mode MutateX run

```bash
nohup mutatex clusters_A.pdb \
-p 4 \
-x /home/ctools/foldx/foldx \
-m mutation_list.txt \
-f suite5 \
-R repair_runfile_template.txt \
-M mutate_runfile_template.txt \
-q poslist.txt \
-c -L -l -v -a \
> ensemble_mutatex.out 2>&1 &
```


## 6. Check completion

Verify no FoldX jobs remain:

```bash
ps -u $USER | grep -E "mutatex|foldx"
```

Check for errors:

```bash
grep -i "error\|traceback\|failed\|exception" ensemble_mutatex.out
```

Locate final averaged results:

```bash
find results -type d -name "final_averages"
```

---

## 7. Generate CSV output

```bash
ddg2excel \
-p clusters_A.pdb \
-l mutation_list.txt \
-q poslist.txt \
-d results/mutation_ddgs/final_averages/ \
-F csv
```

---

## 8. Generate heatmap

```bash
ddg2heatmap \
-p clusters_A.pdb \
-l mutation_list.txt \
-q poslist.txt \
-d results/mutation_ddgs/final_averages/
```

---

