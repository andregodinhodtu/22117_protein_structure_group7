# ============================================================
#  AlphaMissense heatmap viewer  (AlphaFold DB style)
#  Reads the "Heatmap data" CSV from the AlphaFold DB protein
#  page and renders it to match the on-site visualization.
# ============================================================

library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)

# ---- Constants -------------------------------------------------------------

# AlphaFold DB y-axis order (top -> bottom):
# small/aliphatic | polar | sulfur | acidic/amide | basic | aromatic | proline
AA_ORDER <- c("G","A","V","L","I",
              "S","T","C","M",
              "D","N","E","Q",
              "R","K","H",
              "F","Y","W",
              "P")


# ---- Main function ---------------------------------------------------------

plot_am_heatmap <- function(csv_path,
                            residues   = NULL,         # numeric vector, or NULL for all
                            save_path  = NULL,         # e.g. "heatmap.svg" / .pdf / .png
                            width      = NULL,         # inches, auto if NULL
                            height     = 5,
                            title      = NULL) {
  
  # 1. Load and parse -----------------------------------------------------
  df <- read.csv(csv_path, stringsAsFactors = FALSE)
  
  pick <- function(d, candidates) {
    nm <- tolower(gsub("[_\\s-]", "", names(d)))
    for (c in candidates) {
      hit <- which(nm == tolower(gsub("[_\\s-]", "", c)))
      if (length(hit)) return(names(d)[hit[1]])
    }
    NA_character_
  }
  
  vcol <- pick(df, c("protein_variant", "variant", "mutation"))
  scol <- pick(df, c("am_pathogenicity", "pathogenicity", "score"))
  
  if (is.na(vcol) || is.na(scol))
    stop("CSV must contain 'protein_variant' and 'am_pathogenicity' columns.")
  
  parsed <- str_match(df[[vcol]], "^([A-Z])(\\d+)([A-Z])$")
  d <- tibble(
    ref   = parsed[, 2],
    pos   = as.integer(parsed[, 3]),
    alt   = parsed[, 4],
    score = as.numeric(df[[scol]])
  ) |> filter(!is.na(pos), !is.na(score))
  
  # 2. Filter -------------------------------------------------------------
  filtered <- !is.null(residues)
  if (filtered) {
    d <- d |> filter(pos %in% as.integer(residues))
    if (nrow(d) == 0) stop("No rows match the requested residues.")
  }
  
  # 3. Build a complete grid (every position x every AA) ------------------
  ref_lookup <- d |> distinct(pos, ref)
  all_pos    <- sort(unique(d$pos))
  
  full_grid <- expand_grid(pos = all_pos, alt = AA_ORDER) |>
    left_join(ref_lookup, by = "pos") |>
    left_join(d |> select(pos, alt, score), by = c("pos", "alt")) |>
    mutate(
      is_ref = ref == alt,
      score  = ifelse(is_ref, NA_real_, score),     # NA -> rendered black
      alt_y  = match(alt, rev(AA_ORDER))            # numeric y for dual axis
    )
  
  # 4. Plot ---------------------------------------------------------------
  if (filtered) {
    # Discrete x-axis: residues placed adjacent and fully labeled.
    full_grid$x_lab <- factor(paste0(full_grid$ref, full_grid$pos),
                              levels = unique(paste0(ref_lookup$ref,
                                                     ref_lookup$pos)[order(ref_lookup$pos)]))
    p <- ggplot(full_grid, aes(x = x_lab, y = alt_y, fill = score)) +
      geom_tile() +
      scale_x_discrete(name = "Residue", expand = c(0, 0))
  } else {
    # Continuous x-axis with sparse numeric breaks (1, 50, 100, ..., max).
    mx  <- max(all_pos)
    brk <- unique(c(1, seq(50, mx, by = 50), mx))
    p <- ggplot(full_grid, aes(x = pos, y = alt_y, fill = score)) +
      geom_tile() +
      scale_x_continuous(
        name   = "Residue sequence number",
        breaks = brk,
        expand = c(0, 0)
      )
  }
  
  p <- p +
    scale_y_continuous(
      name     = "Alternative amino acids",
      breaks   = 1:20,
      labels   = rev(AA_ORDER),
      sec.axis = dup_axis(name = NULL),
      expand   = c(0, 0)
    ) +
    scale_fill_gradient2(
      low      = "#2166ac",   # deep blue   -> benign
      mid      = "#f7f7f7",   # off-white   -> ambiguous
      high     = "#b2182b",   # deep red    -> pathogenic
      midpoint = 0.5,
      limits   = c(0, 1),
      breaks   = c(0, 0.5, 1),
      name     = "AlphaMissense\npathogenicity",
      na.value = "black"      # reference cells render solid black
    ) +
    labs(title = title) +
    theme_minimal(base_size = 11) +
    theme(
      panel.grid        = element_blank(),
      panel.background  = element_rect(fill = "white", color = NA),
      plot.background   = element_rect(fill = "white", color = NA),
      axis.text.y       = element_text(family = "mono", size = 9),
      axis.text.y.right = element_text(family = "mono", size = 9),
      axis.text.x       = if (filtered) {
        element_text(angle = 60, hjust = 1, family = "mono", size = 8)
      } else {
        element_text(family = "sans", size = 9)
      },
      axis.ticks        = element_line(color = "grey60", linewidth = 0.3),
      axis.ticks.length = unit(2, "pt"),
      axis.title.x      = element_text(margin = margin(t = 8), size = 11),
      axis.title.y      = element_text(margin = margin(r = 6), size = 11),
      plot.title        = element_text(face = "bold", size = 11),
      legend.position   = "right",
      legend.key.height = unit(1.4, "cm"),
      legend.key.width  = unit(0.4, "cm"),
      legend.title      = element_text(size = 9),
      legend.text       = element_text(size = 8)
    )
  
  # 5. Save ---------------------------------------------------------------
  if (!is.null(save_path)) {
    if (is.null(width)) {
      width <- if (filtered) max(4, length(all_pos) * 0.25 + 2)
      else          min(16, max(8, length(all_pos) / 30))
    }
    ggsave(save_path, p, width = width, height = height, dpi = 300)
    message("Saved: ", normalizePath(save_path))
  }
  
  p
}

#  USAGE EXAMPLES

# 1) All residues from the CSV

path <- "alpha_missense/raw_heatmap_data/AF-Q16611-F1-aa-substitutions.csv"
plot_am_heatmap(path)

# 2) Only the 12 BRCA2 sites from the project report
# brca2_sites <- c(2491, 2520, 2533, 2561, 2566, 2650,
#                  2687, 2790, 2800, 2896, 3036, 3039)
# plot_am_heatmap("BRCA2_AlphaMissense_heatmap.csv",
#                 residues  = brca2_sites,
#                 save_path = "brca2_am_heatmap.svg",
#                 title     = "BRCA2 DBD — AlphaMissense at DSS1 interface")

# 3) Just the binding-interface residues from the paper
# plot_am_heatmap("BRCA2_AlphaMissense_heatmap.csv",
#                 residues = c(2520, 2687, 2790, 2800, 3036),
#                 save_path = "brca2_interface.pdf")