rm(list=ls())
library(grid)
library(gridExtra)
library(png)
library(ggplot2)

comb_stats = read.csv("C:/Users/dwo11kg/combined_jordan_hap1_hap2.pacbio.bam.stats.cov_stats", sep = "\t", header = F, skip = 1)

xmax = max(comb_stats$V1)+10

comb_stats_report = comb_stats
colnames(comb_stats_report) = c("Coverage", "N_Sites")

#write.csv(comb_stats_report, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS2.1.csv")


#Arranging multiple panels from different R scripts...

S1A_plot = ggplot(data = comb_stats, aes(x = V1, y = V2))+geom_point()+xlab("Coverage")+ylab("N_sites")+xlim(0, xmax)+
  theme_minimal(base_size = 10) +
  theme(
    axis.title = element_text(size = 11, family = "Arial", color = "black"),
    axis.text = element_text(size =  10, family = "Arial", color = "black"),
    legend.position = "none")

labelA <- textGrob("a", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 11))

S1A = grid.arrange(arrangeGrob(S1A_plot, top = labelA), nrow = 1, ncol = 1)


S1B_plot = S1A_plot+xlim(0, 500)

labelB <- textGrob("b", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 11))

S1B = grid.arrange(arrangeGrob(S1B_plot, top = labelB), nrow = 1, ncol = 1)

S1C_plot = S1A_plot+xlim(0,100)

labelC <- textGrob("c", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 11))

S1C = grid.arrange(arrangeGrob(S1C_plot, top = labelC), nrow = 1, ncol = 1)

S1 = grid.arrange(S1A, S1B, S1C, nrow = 3, ncol = 1)

plot(S1)

ggsave(
  filename = ("NC3_FigS2.png"),
  plot = S1,
  width = 188,
  height = 185,
  units = "mm",
  dpi = 300
)


plot(comb_stats$V1, comb_stats$V2)
plot(comb_stats$V1, log10(comb_stats$V2))

par(mfrow = c(3,2))

plot(hap1_stats, xlim = c(0, 200), xlab = "Coverage", ylab = "N_positions", main = "BATG-1.0")
plot(hap1_stats, xlab = "Coverage", ylab = "N_positions", main = "BATG-1.0")
plot(hap2_stats, xlim = c(0, 200), xlab = "Coverage", ylab = "N_positions", main = "Hap2")
plot(hap2_stats, xlab = "Coverage", ylab = "N_positions", main = "Hap2")
plot(comb_stats, xlim = c(0, 200), xlab = "Coverage", ylab = "N_positions", main = "BATG-1.0+Hap2")
plot(comb_stats, xlab = "Coverage", ylab = "N_positions", main = "BATG-1.0+Hap2")

sum(hap1_stats[hap1_stats$V1 > 140,]$V2)/sum(hap1_stats$V2)
sum(hap2_stats[hap2_stats$V1 > 140,]$V2)/sum(hap2_stats$V2)
sum(comb_stats[comb_stats$V1 > 140,]$V2)/sum(comb_stats$V2)

ggsave(
  filename = ("NC3_FigS.png"),
  plot = combined_plot,
  width = 188,
  height = 185,
  units = "mm",
  dpi = 300
)
}

max(hap1_stats$V2)
