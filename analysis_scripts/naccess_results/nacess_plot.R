# Script to do a plot of Solvent accessability in out protein

# ----------------------------- Import Data --------------------------------
library(tidyverse)

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

# ---------------------------- Plotting ----------------------------------

# Define the motifs
motifs <- tibble(
  motif = c("BH3", "BH1", "BH2"),
  start = c(74, 117, 169),
  end   = c(88, 136, 184)
)

bind_rows(
  stability   |> mutate(source = "Monomer"),
  interaction |> mutate(source = "Complex")
) |>
  filter( chain == "A") |> 
  filter(res_num > 69, res_num < 200) |>   # widened to include BH2
  mutate(burial = case_when(
    side_rel < 20 ~ "Buried",
    side_rel < 50 ~ "Intermediate",
    TRUE          ~ "Exposed"
  ),
  burial = factor(burial, levels = c("Buried", "Intermediate", "Exposed")),
  source = factor(source, levels = c("Monomer", "Complex"))) |>
  ggplot(aes(x = res_num, y = side_rel)) +
  # Shaded motif regions (drawn first so bars sit on top)
  geom_rect(data = motifs,
            aes(xmin = start - 0.5, xmax = end + 0.5,
                ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE,
            fill = "grey80", alpha = 0.4) +
  # Motif labels at the top
  geom_text(data = motifs,
            aes(x = (start + end) / 2, y = Inf, label = motif),
            inherit.aes = FALSE,
            vjust = 1.5, fontface = "bold", size = 3.5) +
  geom_col(aes(fill = burial)) +
  geom_hline(yintercept = c(20, 50), linetype = "dashed", color = "grey40") +
  scale_fill_manual(values = c("Buried" = "#3b528b",
                               "Intermediate" = "#21918c",
                               "Exposed" = "#fde725")) +
  facet_wrap(~ source, ncol = 1) +
  labs(x = "Residue number", y = "Side-chain relative SASA (%)",
       fill = NULL) +
  theme_minimal()

# What you're seeing is the natural alternation between buried and exposed residues 
# along the sequence — and this pattern is actually a signature of α-helices, not 
# evidence against them.
