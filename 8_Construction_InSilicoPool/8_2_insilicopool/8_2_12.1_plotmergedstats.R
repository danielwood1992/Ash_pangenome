#Unfiltered
rm(list=ls())
library(ggplot2)

#Filtered
file_svs = read.csv("C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SNPs.vcf.gz.filt.vcf.0.01.vcf.stats", sep = "\t", header = F)
file_snps = read.csv("C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf.stats", sep = "\t", header = F)

table(file_svs$V1)

head(file_snps)
par(mfrow = c(2,2))
hist(as.numeric(file_svs$V1), breaks = 20, main = "MAF for SVs (42 individuals)")
hist(as.numeric(file_snps$V1), breaks = 20, main = "MAF for SNPs (42 individuals)")

median(as.numeric(file_svs$V1))
median(as.numeric(file_snps$V1))


library(grid)
library(gridExtra)


labelA <- textGrob("A", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

labelB <- textGrob("B", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

MAF_SV = ggplot(file_svs, aes(x = V1)) +
  geom_histogram(binwidth = 0.02, fill = "grey", color = "black") +
  labs(x = "Minor Allele Frequency of SVs", y = "Frequency") + xlim(0,0.5)+
  theme_minimal()+geom_vline(xintercept = median(as.numeric(file_svs$V1)), color = "red", linetype = "dashed")
MAF_SV


MAF_SNP = ggplot(file_snps, aes(x = V1)) +
  geom_histogram(binwidth = 0.02, fill = "grey", color = "black") +
  labs(x = "Minor Allele Frequency of SNPs", y = "Frequency") + xlim(0,0.5)+
  theme_minimal()+geom_vline(xintercept = median(as.numeric(file_snps$V1)), color = "red", linetype = "dashed")
MAF_SNP

S5_A = grid.arrange(MAF_SV, MAF_SNP, nrow = 2, ncol = 1)
PG_S5_A = grid.arrange(arrangeGrob(S5_A, top = labelA), nrow = 1, ncol = 1)

save(PG_S5_A, file = "~/PG_S5_A.RData")


#Ok so let's do these with a dotted line...

par(mfrow = c(2,1))
hist(as.numeric(file_svs$V2), breaks = 20, main = "HWE for SVs (42 individuals)")
hist(as.numeric(file_snps$V2), breaks = 20, main = "HWE for SNPs (42 individuals)")

HWE_SV = ggplot(file_svs, aes(x = V2)) +
  geom_histogram(binwidth = 0.03, fill = "grey", color = "black") +
  labs(x = "HWE test - SVs", y = "Frequency") + xlim(-0.05,1.05)+
  theme_minimal()
HWE_SV

HWE_SNP = ggplot(file_snps, aes(x = V2)) +
  geom_histogram(binwidth = 0.03, fill = "grey", color = "black") +
  labs(x = "HWE test - SNPs", y = "Frequency") + xlim(-0.05,1.05)+
  theme_minimal()

HWE_panel = grid.arrange(HWE_SV, HWE_SNP)
labelB <- textGrob("B", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S5_B = grid.arrange(arrangeGrob(HWE_panel, top = labelB), nrow = 1, ncol = 1)
save(PG_S5_B, file = "~/PG_S5_B.RData")


