# ============================================================
# Circular genome plot in ggplot2 (vector, combinable as a grob)
#
# Why this exists: circlize draws straight to the active graphics
# device rather than returning a grob, which is why the original
# script had to rasterize to a PNG and reinsert it with
# grid.raster() - that bakes it to pixels and it's no longer
# vector. A ggplot object converts cleanly to a grob with
# ggplotGrob(), so it can sit inside grid.arrange(), patchwork,
# or cowplot::plot_grid() and remain fully vector when exported
# to PDF/SVG.
#
# Approach: lay chromosomes end-to-end along one continuous
# x-axis (in Mb, with a small gap inserted between each), plot
# every track as ordinary geom_rect() bars, then wrap the whole
# thing into a circle with coord_polar(theta = "x"). This is the
# standard trick for "circos-style" plots in ggplot2.
# ============================================================

library(dplyr)
library(ggplot2)
library(grid)   # only needed later, for combining/labeling grobs

## ---- 1. file paths -----------------------------------------------------
base <- "C:/Users/dwo11kg/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta.nocontam.fa.top23.fai"

fai_file     <- base
genes_file   <- paste0(base, ".1Mb.genes")
ins_file     <- paste0(base, ".1Mb.SVs.INS")
del_file     <- paste0(base, ".1Mb.SVs.DEL")
inv_file     <- paste0(base, ".1Mb.SVs.INV")
dup_file     <- paste0(base, ".1Mb.SVs.DUP")      # read but not plotted, same as original (commented out there)
repeats_file <- paste0(base, ".1Mb.repeats")      # read but not plotted, same as original

## ---- 2. chromosome table + cumulative (global) coordinates -------------
fai <- read.table(fai_file, header = FALSE)
colnames(fai) <- c("chr", "length", "V3", "V4", "V5")

genome <- fai[, c("chr", "length")]
genome$num       <- seq_len(nrow(genome))
genome$length_mb <- genome$length / 1e6

# gap between chromosomes, in Mb, standing in for circos.par(gap.degree = 2)
gap_mb <- sum(genome$length_mb) * 0.003   # tweak this fraction to open/close the gaps

genome$offset     <- c(0, cumsum(genome$length_mb + gap_mb)[-nrow(genome)])
genome$end_global <- genome$offset + genome$length_mb
genome$mid        <- genome$offset + genome$length_mb / 2

total_span <- sum(genome$length_mb) + gap_mb * nrow(genome)

## helper: attach global_start / global_end to any chr/start/end table
add_global <- function(df, genome) {
  df %>%
    left_join(genome[, c("chr", "offset")], by = "chr") %>%
    mutate(global_start = start / 1e6 + offset,
           global_end   = end   / 1e6 + offset)
}

## ---- 3. read data tracks -------------------------------------------------
genes <- read.table(genes_file, header = FALSE); colnames(genes) <- c("chr", "start", "end", "count")
ins   <- read.table(ins_file,   header = FALSE); colnames(ins)   <- c("chr", "start", "end", "cov")
del   <- read.table(del_file,   header = FALSE); colnames(del)   <- c("chr", "start", "end", "cov")
inv   <- read.table(inv_file,   header = FALSE); colnames(inv)   <- c("chr", "start", "end", "cov")
# dup     <- read.table(dup_file,     header = FALSE); colnames(dup)     <- c("chr","start","end","cov")
# repeats <- read.table(repeats_file, header = FALSE); colnames(repeats) <- c("chr","start","end","cov")

genes <- add_global(genes, genome)
ins   <- add_global(ins,   genome)
del   <- add_global(del,   genome)
inv   <- add_global(inv,   genome)

## ---- 4. track radii ------------------------------------------------------
# Order, inner -> outer: hole, INV (purple), DEL (red), INS (orange),
# genes (blue) - matching the reference SVG exactly (confirmed by sampling
# pixel colours along several radii of Circos_plot.svg). The chromosome
# numbers sit just outside the genes track with no filled/bordered ring
# behind them, because that label track was drawn with bg.border = NA in
# the original circlize code - it's text-only, not a ring.
track_gap <- 3   # visible white space between rings, like circlize's cell margin

r_hole  <- -30
inv_b   <- 0;         inv_t   <- inv_b   + 15
del_b   <- inv_t   + track_gap; del_t   <- del_b   + 15
ins_b   <- del_t   + track_gap; ins_t   <- ins_b   + 15
genes_b <- ins_t   + track_gap; genes_t <- genes_b + 20
label_r <- genes_t + 8       # radius for the chromosome-number text (moved further out)

norm_h <- function(x, bottom, top) bottom + (x / max(x)) * (top - bottom)

genes$ybot <- genes_b; genes$ytop <- norm_h(genes$count, genes_b, genes_t)
ins$ybot   <- ins_b;   ins$ytop   <- norm_h(ins$cov,     ins_b,   ins_t)
del$ybot   <- del_b;   del$ytop   <- norm_h(del$cov,     del_b,   del_t)
inv$ybot   <- inv_b;   inv$ytop   <- norm_h(inv$cov,     inv_b,   inv_t)

## ---- 5. chromosome-number label angles (so text reads outward, not upside-down)
genome$label_angle <- 90 - 360 * genome$mid / total_span
genome$label_angle <- ifelse(genome$label_angle < -90,
                             genome$label_angle + 180,
                             genome$label_angle)

## ---- 6. build the plot ----------------------------------------------------
# per-chromosome sector border, drawn as an outline box for a given track's
# (bottom, top) - this reproduces circlize's default cell border (visible
# in the reference SVG as the thin black arcs bounding each ring), broken
# at the inter-chromosome gaps rather than one continuous circle.
sector_border <- function(genome, bottom, top) {
  geom_rect(data = genome,
            aes(xmin = offset, xmax = end_global, ymin = bottom, ymax = top),
            fill = NA, color = "black", linewidth = 0.15)
}

p <- ggplot() +
  # inversions (innermost)
  geom_rect(data = inv, aes(xmin = global_start, xmax = global_end, ymin = ybot, ymax = ytop),
            fill = "purple", color = NA) +
  sector_border(genome, inv_b, inv_t) +
  # deletions
  geom_rect(data = del, aes(xmin = global_start, xmax = global_end, ymin = ybot, ymax = ytop),
            fill = "red", color = NA) +
  sector_border(genome, del_b, del_t) +
  # insertions
  geom_rect(data = ins, aes(xmin = global_start, xmax = global_end, ymin = ybot, ymax = ytop),
            fill = "orange", color = NA) +
  sector_border(genome, ins_b, ins_t) +
  # gene density (outermost data ring)
  geom_rect(data = genes, aes(xmin = global_start, xmax = global_end, ymin = ybot, ymax = ytop),
            fill = "steelblue", color = NA) +
  sector_border(genome, genes_b, genes_t) +
  # chromosome numbers - text only, no ring behind them (bg.border = NA
  # in the original circlize label track)
  # size.unit = "pt" needs ggplot2 >= 3.5.0. On an older version, drop that
  # argument and use size = 7 / .pt instead (ggplot2's geom_text size is in
  # mm by default, and .pt is its mm-to-pt conversion constant).
  geom_text(data = genome,
            aes(x = mid, y = label_r, label = num, angle = label_angle),
            size = 6, size.unit = "pt", fontface = "plain", family = "Arial") +
  coord_polar(theta = "x", start = 0) +
  scale_x_continuous(limits = c(0, total_span), expand = c(0, 0)) +
  scale_y_continuous(limits = c(r_hole, label_r + 4), expand = c(0, 0)) +
  theme_void() +
  theme(legend.position = "none",
        plot.margin = margin(0, 0, 0, 0))

p

## ---- 7. save as a grob so it combines like your other three panels --------
# ggplotGrob() turns the ggplot object into an ordinary grob (same kind of
# object gridExtra expects for PG2_Plot2A/B/C), and that stays fully vector
# all the way through to the final PDF - no PNG round-trip needed.
circos_grob <- ggplotGrob(p)

# Bake the "d" panel label onto the circos grob itself (equivalent to the
# grid.text() call in the original script). grid::grobTree() layers a plain
# text grob on top using npc coordinates (0-1 over the whole panel), so it
# travels with circos_grob through grid.arrange() rather than needing a
# separate grid.text() call added after arranging.
circos_grob <- grid::grobTree(
  circos_grob,
  grid::textGrob("d", x = 0.05, y = 0.95, just = c("left", "top"),
                 gp = grid::gpar(fontface = "bold", fontsize = 7))
)

save(circos_grob, file = "~/circos_plot.RData")

## ---- 8. combine into the 2x2 layout and export ----------------------------
library(gridExtra)

load("~/PG2_Plot2A.RData")
load("~/PG2_Plot2B.RData")
load("~/PG2_Plot2C.RData")
load("~/circos_plot.RData")

plot2 <- grid.arrange(PG2_Plot2A, PG2_Plot2B, PG2_Plot2C, circos_grob, ncol = 2, nrow = 2)

# ggsave("C:/Users/dwo11kg/PG_Plot2.png", plot2, width = 300, height = 300, units = "mm", dpi = 600)
ggsave(
  "~/PG_Plot2.pdf",
  plot = plot2,
  width = 188,
  height = 185,
  units = "mm",
  device = cairo_pdf
)



##################################################
# Making individual plots - S30-S52 (rewritten with diagnostics)
##################################################

library(patchwork)
library(ggplot2)
library(dplyr)

# ---- normalize chr names across every table --------------------------
# Strips whitespace and any "chr" prefix, so "chr1" and "1" both become
# "1". If your files already agree on naming this is a no-op; if they
# don't, this is almost certainly why tracks 2-5 were blank.
clean_chr <- function(df) {
  df$chr <- trimws(as.character(df$chr))
  df$chr <- sub("^chr", "", df$chr, ignore.case = TRUE)
  df
}

genome_scaled  <- clean_chr(genome_scaled)
windows_scaled <- clean_chr(windows_scaled)
INS_scaled     <- clean_chr(INS_scaled)
DEL_scaled     <- clean_chr(DEL_scaled)
INV_scaled     <- clean_chr(INV_scaled)
DUP_scaled     <- clean_chr(DUP_scaled)
repeats_scaled <- clean_chr(repeats_scaled)

# ---- diagnostic: row counts per chromosome per track ------------------
# Run this once and look at the output before trusting the plots. If
# INS/DEL/INV/DUP show 0 rows for every chr while windows/repeats don't,
# that confirms the naming mismatch (now fixed above) was the cause.
diag <- data.frame(
  chr      = genome_scaled$chr,
  windows  = sapply(genome_scaled$chr, function(x) sum(windows_scaled$chr == x)),
  ins      = sapply(genome_scaled$chr, function(x) sum(INS_scaled$chr == x)),
  del      = sapply(genome_scaled$chr, function(x) sum(DEL_scaled$chr == x)),
  inv      = sapply(genome_scaled$chr, function(x) sum(INV_scaled$chr == x)),
  dup      = sapply(genome_scaled$chr, function(x) sum(DUP_scaled$chr == x)),
  repeats  = sapply(genome_scaled$chr, function(x) sum(repeats_scaled$chr == x))
)
print(diag)

# ---- order chromosomes largest -> smallest -----------------------------
chrom_order <- genome_scaled %>%
  arrange(desc(length)) %>%
  mutate(number = 1:n())

chromosomes    <- chrom_order$chr
chrom_numbers  <- chrom_order$number
names(chrom_numbers) <- chromosomes

# ---- loop over chromosomes ---------------------------------------------
for (chr_i in chromosomes) {
  
  chr_num <- chrom_numbers[chr_i]
  
  w   <- windows_scaled[windows_scaled$chr == chr_i, ]
  ins <- INS_scaled[INS_scaled$chr == chr_i, ]
  del <- DEL_scaled[DEL_scaled$chr == chr_i, ]
  inv <- INV_scaled[INV_scaled$chr == chr_i, ]
  dup <- DUP_scaled[DUP_scaled$chr == chr_i, ]
  rep <- repeats_scaled[repeats_scaled$chr == chr_i, ]
  
  # safety net: warn (rather than silently plot nothing) if a track is
  # empty for this chromosome specifically
  for (nm in c("w", "ins", "del", "inv", "dup", "rep")) {
    if (nrow(get(nm)) == 0) {
      message(sprintf("chr %s: track '%s' has 0 rows", chr_i, nm))
    }
  }
  
  base_theme <- theme_bw() +
    theme(plot.margin = margin(2, 5, 2, 5),
          axis.title.x = element_blank())
  
  # small helper so an empty track still returns a valid (blank-but-
  # labeled) ggplot instead of patchwork choking on a bad object
  make_panel <- function(df, xcol, ycol, fill_col, ylabel, title = NULL) {
    p <- ggplot(df, aes(x = .data[[xcol]], y = .data[[ycol]])) +
      { if (nrow(df) > 0) geom_col(fill = fill_col, width = 0.9) } +
      ylab(ylabel) +
      base_theme
    if (!is.null(title)) p <- p + ggtitle(title)
    if (nrow(df) == 0) {
      p <- p + annotate("text", x = 0.5, y = 0.5, label = "no data",
                        size = 3, color = "grey50")
    }
    p
  }
  
  p1 <- make_panel(w,   "start", "count", "steelblue",  "count", paste0(chr_num, ": ", chr_i))
  p2 <- make_panel(ins, "start", "cov",   "orange",     "count")
  p3 <- make_panel(del, "start", "cov",   "red",        "count")
  p4 <- make_panel(inv, "start", "cov",   "purple",     "count")
  p5 <- make_panel(dup, "start", "cov",   "darkgreen",  "count")
  p6 <- make_panel(rep, "start", "cov",   "brown",      "count") +
    xlab("Position (bp)")
  
  combined_plot <- p1 / p2 / p3 / p4 / p5 / p6
  
  ggsave(
    filename = paste0("NC_Chromosome_", chr_num, ".png"),
    plot = combined_plot,
    width = 188,
    height = 185,
    units = "mm",
    dpi = 300
  )
}

# =========================================
# Done
# =========================================
