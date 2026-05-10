library(tidyverse)

# ---- 3-letter -> 1-letter amino acid lookup ----
aa_3to1 <- c(ALA="A", ARG="R", ASN="N", ASP="D", CYS="C",
             GLU="E", GLN="Q", GLY="G", HIS="H", ILE="I",
             LEU="L", LYS="K", MET="M", PHE="F", PRO="P",
             SER="S", THR="T", TRP="W", TYR="Y", VAL="V")

read_rsa <- function(path) {
  read_lines(path) |>
    keep(~ str_starts(.x, "RES ")) |>
    paste(collapse = "\n") |>
    read_table(col_names = c("record", "res_name", "chain", "res_num",
                             "all_abs",      "all_rel",
                             "side_abs",     "side_rel",
                             "main_abs",     "main_rel",
                             "nonpolar_abs", "nonpolar_rel",
                             "polar_abs",    "polar_rel"))
}

stability   <- read_rsa("stability/naccess/results/2IMT_no_solvent/2IMT_no_solvent.rsa")
interaction <- read_rsa("interaction/Naccess/6UXR_dimer_clean.rsa")

motifs <- tibble(
  motif = c("BH3", "BH1"),
  start = c(74, 117),
  end   = c(88, 136)
)

# ---- Build the data ----
plot_df <- bind_rows(
  stability   |> mutate(source = "Monomer"),
  interaction |> mutate(source = "Complex")
) |>
  filter(chain == "A", res_num > 68, res_num < 147) |>
  mutate(
    burial = case_when(
      side_rel < 20 ~ "Buried",
      side_rel < 50 ~ "Intermediate",
      TRUE          ~ "Exposed"
    ),
    burial    = factor(burial, levels = c("Buried", "Intermediate", "Exposed")),
    source    = factor(source, levels = c("Monomer", "Complex")),
    res_label = paste0(aa_3to1[res_name], res_num)   # e.g. "A74"
  )

# ---- Per-residue tick labels ----
x_lookup <- plot_df |>
  distinct(res_num, res_label) |>
  arrange(res_num)

# ---- Plot ----
p <- ggplot(plot_df, aes(x = res_num, y = side_rel)) +
  # motif bands
  geom_rect(data = motifs,
            aes(xmin = start - 0.5, xmax = end + 0.5,
                ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE,
            fill = "grey80", alpha = 0.4) +
  
  # bars
  geom_col(aes(fill = burial)) +
  
  # SASA cutoffs
  geom_hline(yintercept = c(20, 50), linetype = "dashed", color = "grey40") +
  
  # motif labels above the bars
  geom_text(data = motifs,
            aes(x = (start + end) / 2, y = 130, label = motif),
            inherit.aes = FALSE,
            fontface = "bold", size = 4) +
  
  scale_fill_manual(values = c("Buried"       = "#3b528b",
                               "Intermediate" = "#21918c",
                               "Exposed"      = "#fde725")) +
  scale_x_continuous(breaks = x_lookup$res_num,
                     labels = x_lookup$res_label,
                     expand = expansion(mult = 0.005)) +
  scale_y_continuous(limits = c(0, 135),
                     breaks = c(0, 25, 50, 75, 100)) +
  
  facet_wrap(~ source, ncol = 1) +
  labs(x = "Residue", y = "Side-chain relative SASA (%)", fill = NULL) +
  theme_minimal(base_size = 11) +
  theme(
    axis.text.x      = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 6),
    axis.title.x     = element_text(margin = margin(t = 5)),
    panel.grid.minor = element_blank(),
    panel.spacing    = unit(1.2, "lines"),
    strip.text       = element_text(face = "bold"),
    legend.position  = "top",
    legend.text      = element_text(size = 10),         # text smaller
    legend.key.size  = unit(0.5, "cm"),               # color swatches smaller
    legend.margin    = margin(t = 0, b = -5)           # tighter spacing around legend
  )

print(p)


ggsave("analysis_scripts/naccess/nacess_plot_final.png", p,
       width = 8, height = 5, dpi = 300)