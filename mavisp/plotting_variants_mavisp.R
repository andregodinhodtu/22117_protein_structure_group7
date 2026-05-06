library(ggplot2)
library(dplyr)
library(stringr)
library(tibble)
library(tidyr)
library(ggnewscale)

# 1. Read the CSV
mavisp_data_path <- "mavisp/raw_data/BAK1-simple_mode-view_without_saturation_mut_list.csv"
df <- read.csv(mavisp_data_path, stringsAsFactors = FALSE)

# 2. Extract position number from "Mutation"
df$Position <- as.integer(str_extract(df$Mutation, "(?<=^[A-Z])\\d+(?=[A-Z]$)"))

# 3. Clean up classification: empty strings -> "unclassified"
df <- df %>%
  mutate(AlphaMissense.classification = na_if(AlphaMissense.classification, ""),
         AlphaMissense.classification = replace_na(AlphaMissense.classification, "unclassified"))

# 4. Count mutations per (position, classification) -> for stacked bars
counts <- df %>%
  filter(!is.na(Position)) %>%
  count(Position, AlphaMissense.classification, name = "n_mutations") %>%
  mutate(AlphaMissense.classification = factor(
    AlphaMissense.classification,
    levels = c("benign", "ambiguous", "pathogenic", "unclassified")))

# 5. Motifs
motifs <- tibble(
  motif = c("BH3", "BH1", "BH2"),
  start = c(74, 117, 169),
  end   = c(88, 136, 184)
)
motifs$motif <- factor(motifs$motif, levels = motifs$motif)

# 6. y-axis limit from the per-position totals (since bars are stacked)
y_max <- counts %>% group_by(Position) %>% summarise(t = sum(n_mutations)) %>% pull(t) %>% max()

# 7. Plot
p <- ggplot() +
  # motif bands (first fill scale)
  geom_rect(data = motifs,
            aes(xmin = start - 0.5, xmax = end + 0.5,
                ymin = 0, ymax = y_max + 0.5,
                fill = motif),
            alpha = 0.25) +
  scale_fill_brewer(palette = "Set2", name = "Motif") +
  
  # switch fill scale so bars get their own colors
  new_scale_fill() +
  
  # stacked bars colored by AlphaMissense classification
  geom_col(data = counts,
           aes(x = Position, y = n_mutations,
               fill = AlphaMissense.classification),
           colour = "black", linewidth = 0.15) +
  scale_fill_manual(name = "AlphaMissense",
                    values = c(benign       = "#2c7bb6",
                               ambiguous    = "#fdae61",
                               pathogenic   = "#d7191c",
                               unclassified = "grey70")) +
  
  scale_x_continuous(breaks = seq(0, 220, 20)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Residue position",
       y = "Number of mutations",
       title = "Mutations per residue position",
       subtitle = "Bars: AlphaMissense classification • Shaded bands: BH motifs") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank(),
        legend.position = "top")

ggsave("mavisp/mutations_per_position.png", p, width = 14, height = 5, dpi = 150)
print(p)