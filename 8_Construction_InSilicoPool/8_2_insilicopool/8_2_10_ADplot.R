rm(list=ls())
library(ggplot2)

#SNPs
results_SNPs = read.csv("C:/Users/dwo11kg/Individual164.PATCH.surject.bam.tomerge2.0.01.vcf.SNPadstats", sep = "\t", header = F)

dim(results_SNPs)

colnames(results_SNPs) = c("Scaff", "Pos", "Name", "GT", "DP_Total", "DP_Ref", "DP_Alt", "Filename")
head(results_SNPs)
results_SNPs$AD = results_SNPs$DP_Alt/results_SNPs$DP_Total
head(results_SNPs)

GT_table = table(results_SNPs$GT)
GT_table = data.frame(table(results_SNPs$GT))

#Very few missing values...
ggplot(GT_table, aes(x = Var1, y = Freq))+geom_bar(stat = "identity")+theme(text=element_text(size = 30))+xlab("Genotype") #yeah so very few missing values again. Is this weird? Maybe?


panel1 = ggplot(results_SNPs[results_SNPs$GT == "0/0",], aes(x = DP_Alt)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel2 = ggplot(results_SNPs[results_SNPs$GT == "0/0",], aes(x = DP_Ref)) +theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel3 = ggplot(results_SNPs[results_SNPs$GT == "0/0",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05, 1.05)

panel4 = ggplot(results_SNPs[results_SNPs$GT == "0/1",], aes(x = DP_Alt)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)
 
panel5 = ggplot(results_SNPs[results_SNPs$GT == "0/1",], aes(x = DP_Ref)) +  theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel6 = ggplot(results_SNPs[results_SNPs$GT == "0/1",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05,1.05)

panel7 = ggplot(results_SNPs[results_SNPs$GT == "1/1",], aes(x = DP_Alt)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel8 = ggplot(results_SNPs[results_SNPs$GT == "1/1",], aes(x = DP_Ref)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel9 = ggplot(results_SNPs[results_SNPs$GT == "1/1",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05,1.05)

library(grid)
library(gridExtra)

plotA = grid.arrange(nrow = 3, ncol = 3, panel1, panel2, panel3, panel4, panel5, panel6, panel7, panel8, panel9)

library(grid)
library(gridExtra)

labelA <- textGrob("A", x = 0.01, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S4_A = grid.arrange(arrangeGrob(plotA, top = labelA), nrow = 1, ncol = 1)

save(PG_S4_A, file = "~/PG_S4_A.RData")


#SVs
results_SVs = read.csv("C:/Users/dwo11kg/Individual164.gam.PG2_15_2.vcf.adstats", sep = "\t", header = F)

dim(results_SVs)


colnames(results_SVs) = c("Scaff", "Pos", "Name", "GT", "DP_Total", "DP_Ref", "DP_Alt", "Filename")
head(results_SVs)
results_SVs$AD = results_SVs$DP_Alt/results_SVs$DP_Total
head(results_SVs)

top_SVs = read.csv("C:/Users/dwo11kg/PoolFileList.txt_notech.joint.out.rmh.Supp7e.sig.sites", header = F, sep = "\t")
head(top_SVs)
results_SVs$sv = paste(results_SVs$Scaff, results_SVs$Pos)
top_SVs$sv = paste(top_SVs$V1, top_SVs$V2)

results_SVs2 = results_SVs[results_SVs$sv %in% top_SVs$sv ,]
dim(results_SVs2)

par(mar=c(2,2,2,2) + 0.1)
GT_table = table(results_SVs$GT)
GT_table = data.frame(table(results_SVs$GT))


#Very few missing values...
ggplot(GT_table, aes(x = Var1, y = Freq))+geom_bar(stat = "identity")+theme(text=element_text(size = 30))+xlab("Genotype") #yeah so very few missing values again. Is this weird? Maybe?

par(mfrow = c(3,3))

panel1 = ggplot(results_SVs[results_SVs$GT == "0/0",], aes(x = DP_Alt)) +theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel2 = ggplot(results_SVs[results_SVs$GT == "0/0",], aes(x = DP_Ref)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel3 = ggplot(results_SVs[results_SVs$GT == "0/0",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 0/0 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05, 1.05)

panel4 = ggplot(results_SVs[results_SVs$GT == "0/1",], aes(x = DP_Alt)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel5 = ggplot(results_SVs[results_SVs$GT == "0/1",], aes(x = DP_Ref)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel6 = ggplot(results_SVs[results_SVs$GT == "0/1",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 0/1 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05,1.05)

panel7 = ggplot(results_SVs[results_SVs$GT == "1/1",], aes(x = DP_Alt)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Alt Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel8 = ggplot(results_SVs[results_SVs$GT == "1/1",], aes(x = DP_Ref)) + theme_minimal()+
  geom_histogram(binwidth = 1, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Ref Allele Depth", y = "Frequency") + xlim(-0.5,60)

panel9 = ggplot(results_SVs[results_SVs$GT == "1/1",], aes(x = AD)) + theme_minimal()+
  geom_histogram(binwidth = 0.05, fill = "grey", color = "black") +
  labs(x = "Genotype 1/1 - Alt Depth/(Alt+Ref Depth)", y = "Frequency") + xlim(-0.05,1.05)

library(grid)
library(gridExtra)

plotB = grid.arrange(nrow = 3, ncol = 3, panel1, panel2, panel3, panel4, panel5, panel6, panel7, panel8, panel9)

library(grid)
library(gridExtra)

labelB <- textGrob("B", x = 0.01, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S4_B = grid.arrange(arrangeGrob(plotB, top = labelB), nrow = 1, ncol = 1)

save(PG_S4_B, file = "~/PG_S4_B.RData")
