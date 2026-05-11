library(tidyverse)

# Load files
energies <- read_csv("energies.csv")
poslist <- read_lines("poslist.txt")

# Convert wide MutateX table to long format
ddg_long <- energies %>%
  rename(
    WT = `WT residue type`,
    Chain = `chain ID`,
    Residue_number = `Residue #`
  ) %>%
  mutate(
    Residue = paste0(WT, Chain, Residue_number)
  ) %>%
  filter(Residue %in% poslist) %>%
  pivot_longer(
    cols = c(G,A,V,L,I,M,F,W,P,S,T,C,Y,N,Q,D,E,K,R,H),
    names_to = "Mutant",
    values_to = "ddG"
  ) %>%
  mutate(
    Residue = factor(Residue, levels = poslist),
    Mutant = factor(Mutant, levels = c(
      "G","A","V","L","I","M","F","W","P","S",
      "T","C","Y","N","Q","D","E","K","R","H"
    )),
    mutation_type = case_when(
      Mutant %in% c("A","V","L","I","M") ~ "Hydrophobic",
      Mutant %in% c("F","W","Y") ~ "Aromatic",
      Mutant %in% c("S","T","C","N","Q") ~ "Polar",
      Mutant %in% c("D","E","K","R","H") ~ "Charged",
      Mutant == "G" ~ "Glycine",
      Mutant == "P" ~ "Proline",
      TRUE ~ "Other"
    ),
    effect_class = case_when(
      ddG >= 3 ~ "Destabilising",
      ddG >= 2 & ddG < 3 ~ "Uncertain destabilising",
      ddG > -2 & ddG < 2 ~ "Neutral",
      ddG <= -3 ~ "Stabilising",
      ddG <= -2 & ddG > -3 ~ "Uncertain stabilising"
    )
  )

# Per-residue summary
residue_summary <- ddg_long %>%
  group_by(Residue) %>%
  summarise(
    mean_ddG = mean(ddG, na.rm = TRUE),
    median_ddG = median(ddG, na.rm = TRUE),
    max_ddG = max(ddG, na.rm = TRUE),
    n_destabilising = sum(ddG >= 3, na.rm = TRUE),
    n_strong_destabilising = sum(ddG >= 5, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(ddg_long, "BH3_ddG_long_format.csv")
write_csv(residue_summary, "BH3_residue_summary.csv")

print(residue_summary)

# Figure 11: ΔΔG heatmap
p_heatmap <- ggplot(ddg_long, aes(x = Residue, y = Mutant, fill = ddG)) +
  geom_tile() +
  theme_bw() +
  labs(
    x = "BH3 residue",
    y = "Substituted amino acid",
    fill = expression(Delta * Delta * "G"),
    title = expression("MutateX " * Delta * Delta * "G values for BH3 substitutions")
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Figure11_BH3_ddG_heatmap.png", p_heatmap, width = 8, height = 5, dpi = 300)
ggsave("Figure11_BH3_ddG_heatmap.pdf", p_heatmap, width = 8, height = 5)

# Figure 12: mean ΔΔG per residue
p_bar <- ggplot(residue_summary, aes(x = Residue, y = mean_ddG)) +
  geom_col() +
  theme_bw() +
  labs(
    x = "BH3 residue",
    y = expression("Mean " * Delta * Delta * "G across substitutions"),
    title = expression("Average mutational sensitivity of BH3 residues")
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Figure12_BH3_mean_ddG_per_residue.png", p_bar, width = 8, height = 4, dpi = 300)
ggsave("Figure12_BH3_mean_ddG_per_residue.pdf", p_bar, width = 8, height = 4)

# Figure 13: number of destabilising substitutions per residue
p_count <- ggplot(residue_summary, aes(x = Residue, y = n_destabilising)) +
  geom_col() +
  theme_bw() +
  labs(
    x = "BH3 residue",
    y = expression("Number of substitutions with " * Delta * Delta * "G" >= 3),
    title = "Number of destabilising substitutions per BH3 residue"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Figure13_BH3_destabilising_counts.png", p_count, width = 8, height = 4, dpi = 300)
ggsave("Figure13_BH3_destabilising_counts.pdf", p_count, width = 8, height = 4)

# Chemical class summary
class_summary <- ddg_long %>%
  group_by(mutation_type) %>%
  summarise(
    mean_ddG = mean(ddG, na.rm = TRUE),
    median_ddG = median(ddG, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(class_summary, "BH3_mutation_class_summary.csv")
print(class_summary)

######### NEW ###################
library(tidyverse)

poslist <- read_lines("poslist.txt")

aa_cols <- c("G","A","V","L","I","M","F","W","P","S",
             "T","C","Y","N","Q","D","E","K","R","H")

energies <- read_csv("energies.csv", show_col_types = FALSE)

ddg_long <- energies %>%
  mutate(
    Residue = paste0(`WT residue type`, `chain ID`, `Residue #`)
  ) %>%
  filter(Residue %in% poslist) %>%
  pivot_longer(
    cols = all_of(aa_cols),
    names_to = "Mutant",
    values_to = "ddG"
  )

residue_summary <- ddg_long %>%
  group_by(Residue) %>%
  summarise(
    mean_ddG = mean(ddG, na.rm = TRUE),
    sd_ddG = sd(ddG, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    Residue = factor(Residue, levels = poslist)
  )

p <- ggplot(residue_summary, aes(x = Residue, y = mean_ddG)) +
  geom_col() +
  geom_errorbar(
    aes(
      ymin = mean_ddG - sd_ddG,
      ymax = mean_ddG + sd_ddG
    ),
    width = 0.25
  ) +
  theme_bw() +
  labs(
    x = "BH3 residue",
    y = expression("Mean " * Delta * Delta * "G across substitutions (kcal/mol)"),
    title = expression("Average mutational sensitivity of BH3 residues")
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Figure12_BH3_mean_ddG_SD_substitutions.png", p, width = 8, height = 4, dpi = 300)
ggsave("Figure12_BH3_mean_ddG_SD_substitutions.pdf", p, width = 8, height = 4)
