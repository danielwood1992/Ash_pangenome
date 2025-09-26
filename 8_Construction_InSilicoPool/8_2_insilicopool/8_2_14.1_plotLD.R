# Load necessary libraries
rm(list=ls())
library(ggplot2)

#SNP_SNP
SNP_SNP_ld_file <- "C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf.update.vcf.plusSNPs.vcf.plink2.bigger.ld.tab.SNP_SNP"     # Name of the PLINK LD output file
SV_SNP_ld_file <- "C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf.update.vcf.plusSNPs.vcf.plink2.bigger.ld.tab.SV_SNP"     # Name of the PLINK LD output file
SV_SV_ld_file <- "C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf.update.vcf.plusSNPs.vcf.plink2.bigger.ld.tab.SV_SV"     # Name of the PLINK LD output file


# Load the LD data
calc_ld <- function(ld_file){
  ld_data <- read.table(ld_file, header=TRUE)

  # Calculate the distance between each pair of SNPs (in base pairs)
  ld_data$Distance <- abs(ld_data$BP_A - ld_data$BP_B)

  # Bin distances (adjust bins as needed based on your data)
  # Here, we define custom bins in base pairs (1 kb, 5 kb, 10 kb, etc.)
  bins <- c(0, 100, 1000, 5000, 10000, 50000, 100000, 200000, 300000, 400000, 500000, 1000000, 2000000)
  #bins <- c(0, 200, 400, 600, 800, 1000, 2000, 3000, 4000)  
  ld_data$DistanceBin <- cut(ld_data$Distance, breaks=bins, include.lowest=TRUE)

  # Calculate mean R2 value for each distance bin
  ld_decay <- aggregate(R2 ~ DistanceBin, data=ld_data, mean)
  
  # Convert bins to numeric for plotting purposes
  ld_decay$DistanceBinMid <- as.numeric(gsub(",", "", gsub("\\(|\\]", "", 
                                                         sapply(strsplit(as.character(ld_decay$DistanceBin), ","), function(x) x[1]))))
  return(ld_decay)
}

ld_snps = calc_ld(SNP_SNP_ld_file)
ld_SVs = calc_ld(SV_SV_ld_file)
ld_SV_SV = calc_ld(SV_SNP_ld_file)

ld_snps$type = "snp_snp"
ld_SVs$type = "sv_sv"
ld_SV_SV$type = "sv_snp"

ld_all = rbind(ld_snps, ld_SVs, ld_SV_SV)
ld_all

head(ld_snps)
cbPalette_2 <- c("#E69F00", "#56B4E9", "#CC79A7")
# Plot LD decay curve using ggplot2
ggplot(ld_all, aes(x=DistanceBinMid, y=R2, colour = type )) +
  geom_line(group = "type", size=1) +
  geom_point(color="red", size=2) +
  xlab("Distance (bp)") +
  ylab(expression("Mean " * R^2)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45, hjust=1))+scale_colour_manual(values = cbPalette_2)

#SNp_SNp = orange
#SV-SV = purple
#SNP-SV = blue

plot_PG_S5_C = ggplot(ld_all, aes(x=DistanceBinMid, y=R2, colour = type )) +
  geom_line(group = "type", size=1) +
  geom_point(color="red", size=2) +
  xlab("Distance (bp)") +
  ylab(expression("Mean " * R^2)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45, hjust=1))+scale_colour_manual(values = cbPalette_2)+theme(legend.position = "none")

library(grid)
library(gridExtra)

labelC <- textGrob("C", x = 0.025, y = 0.4, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S5_C = grid.arrange(arrangeGrob(plot_PG_S5_C, top = labelC), nrow = 1, ncol = 1)

save(PG_S5_C, file = "~/PG_S5_C.RData")

PG_S5_C

#orange = snp_snp
#blue = sv_snp
#purple - sv_sv


