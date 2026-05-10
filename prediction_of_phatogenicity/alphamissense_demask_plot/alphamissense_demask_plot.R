library(ggplot2)
library(dplyr)
library(stringr)
library(tibble)

# ----- 0. Paths -----
path_alpha_missense <- "prediction_of_phatogenicity/alpha_missense/raw_heatmap_data/AF-Q16611-F1-aa-substitutions.csv"
path_demask         <- "prediction_of_phatogenicity/demask/raw_data/175ddae87fe0fedbff3e.pos_rank.txt"

# ----- 1. Load -----
df_alpha_missense <- read.csv(path_alpha_missense, stringsAsFactors = FALSE) |>
  mutate(origin = "alpha_missense")

df_demask <- read.table(path_demask, header = TRUE, sep = "\t",
                        stringsAsFactors = FALSE) |>
  mutate(origin = "demask")

# ----- 2. Parse protein_variant in AlphaMissense -----
df_alpha_missense <- df_alpha_missense |>
  mutate(
    WT  = str_sub(protein_variant, 1, 1),
    var = str_sub(protein_variant, -1, -1),
    pos = as.integer(str_extract(protein_variant, "\\d+"))
  )

# ----- 3. Common schema and stack -----
df_am <- df_alpha_missense |>
  select(pos, WT, var, score = am_pathogenicity, origin)

df_dm <- df_demask |>
  select(pos, WT, var, score, origin)

df_all <- bind_rows(df_am, df_dm)

# ----- 4. Orient so high = damaging, rank-normalize, then CENTER at 0 -----
df_all <- df_all |>
  mutate(score_oriented = if_else(origin == "demask", -score, score)) |>
  group_by(origin) |>
  mutate(score_rank     = rank(score_oriented, na.last = "keep") /
           sum(!is.na(score_oriented)),
         score_centered = score_rank - 0.5) |>     # now in [-0.5, 0.5]
  ungroup() |>
  mutate(origin = factor(origin,
                         levels = c("alpha_missense", "demask"),
                         labels = c("AlphaMissense", "DeMaSk")))   # <-- renamed

# ----- 5. Per-position mean and SD on the centered score -----
summary_df <- df_all |>
  group_by(origin, pos) |>
  summarise(mean_score = mean(score_centered, na.rm = TRUE),
            sd_score   = sd(score_centered,   na.rm = TRUE),
            .groups = "drop")

# ----- 6. Motifs -----
motifs <- tibble(
  motif = c("BH3", "BH1", "BH2"),
  start = c(74, 117, 169),
  end   = c(88, 136, 184)
)

# ----- 7. Plot -----
y_lo  <- -0.6
y_hi  <-  0.6
y_lab <- -0.5

p <- ggplot() +
  # motif bands behind everything
  geom_rect(data = motifs,
            aes(xmin = start, xmax = end, ymin = y_lo, ymax = y_hi),
            fill = "grey70", alpha = 0.20) +
  
  # bold motif labels
  geom_text(data = motifs,
            aes(x = (start + end) / 2, y = y_lab, label = motif),
            size = 4.2, fontface = "bold", colour = "black") +
  
  # zero reference line
  geom_hline(yintercept = 0, linetype = "dashed",
             colour = "grey40", linewidth = 0.3) +
  
  # ±1 SD ribbon
  geom_ribbon(data = summary_df,
              aes(x = pos,
                  ymin = pmax(mean_score - sd_score, y_lo),
                  ymax = pmin(mean_score + sd_score, y_hi),
                  fill = origin),
              alpha = 0.25, colour = NA) +
  
  # mean line
  geom_line(data = summary_df,
            aes(x = pos, y = mean_score, colour = origin),
            linewidth = 0.7) +
  
  facet_wrap(~ origin, ncol = 1) +
  
  scale_colour_manual(values = c(AlphaMissense = "#d7191c",
                                 DeMaSk        = "#2c7bb6")) +  
  scale_fill_manual(values   = c(AlphaMissense = "#d7191c",
                                 DeMaSk        = "#2c7bb6")) +
  scale_y_continuous(limits = c(y_lo, y_hi),
                     breaks = c(-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6),
                     expand = expansion(mult = c(0.01, 0.01))) +
  scale_x_continuous(breaks = seq(0, max(summary_df$pos, na.rm = TRUE), by = 5),
                     expand = expansion(mult = c(0.005, 0.005))) +
  labs(x = "Residue position",
       y = "Centered rank-normalized damaging score (± SD)") +
  theme_minimal(base_size = 12) +
  theme(legend.position  = "none",
        panel.grid.minor = element_blank(),
        strip.text       = element_text(face = "bold", size = 17),   # bigger panel titles
        plot.margin      = margin(t = 4, r = 8, b = 4, l = 4),
        axis.text.x      = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 11),
        axis.text.y      = element_text(size = 11),
        axis.title.y     = element_text(size = 14))

print(p)
ggsave("analysis_scripts/alphamissense_demask/score_by_position_centered.png", p, width = 10, height = 6, dpi = 150)
