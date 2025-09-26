rm(list=ls())

library(gridExtra)
library(grid)
library(ggplot2)

#Not sure why this is called q5 - oh probably referring to the pack file filtering
file_SV_q5_PATCH = read.csv("C:/Users/dwo11kg/fake_pool_p0.1.PATCH.gam.snarls.PG2_15_2.filt.vcf.AD.PG2_25_10.out", sep = "\t", header = F)

SV_plot_q5_PATCH = ggplot(data = file_SV_q5_PATCH, aes(x = as.numeric(V4), y = as.numeric(V5)))+
  geom_bin_2d(bins = 150)+xlab("Alternate AF from individual calls")+ylab("AD from artificial pool")+theme_minimal()
SV_plot_q5_PATCH

summary(lm(file_SV_q5_PATCH$V5 ~ file_SV_q5_PATCH$V4)) #R^2 = 0.85

file_SV_e13 = read.csv("C:/Users/dwo11kg/fake_pool_p0.1.PATCH.gam.snarls.PG2_15_2.filt.vcf.AD.PG2_25_10.out.e13", sep = "\t", header = F)
head(file_SV_e13)


dim(file_SV_e13)

summary(lm(file_SV_e13$V5 ~ file_SV_e13$V4)) 

SV_plot_e13 = ggplot(data = file_SV_e13, aes(x = as.numeric(V4), y = as.numeric(V5)))+
  geom_bin_2d(bins = 50)+xlab("Alternate AF from individual calls")+ylab("AD from artificial pool")+theme_minimal(base_size=12)+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size = 8))

SV_plot_e13

#SNPs
file_SNP = read.csv("C:/Users/dwo11kg/fake_pool_p0.1.PATCH.surject.bam.tomerge2.vcf.DP4.PG2_25_10.out", sep = "\t", header = F)
dim(file_SNP)
library(ggplot2)

SV_plot_e13
dim(file_SV_e13)
dim(file_SV_e13[file_SV_e13$V4+0.25 < file_SV_e13$V5,]) #So nearly half of them are in this weird subset then...

SNP_plot = ggplot(data = file_SNP, aes(x = V3, y = V4))+geom_bin_2d(bins = 150)+xlab("Alternate AF from individual calls")+ylab("AD from artificial pool")+theme_minimal()
SNP_plot
summary(lm(file_SNP$V4 ~ file_SNP$V3)) #R^2 = 0.93
#So then the adjusted R^2 there is 0.93
#Yep so it's still 0.93. Cool, done. 

labelA <- textGrob("A", x = 0.03, y = 0.5, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

labelB <- textGrob("B", x = 0.03, y = 0.5, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S6_A = grid.arrange(arrangeGrob(SNP_plot, top = labelA), nrow = 1, ncol = 1)
PG_S6_B = grid.arrange(arrangeGrob(SV_plot_q5_PATCH, top = labelB), nrow = 1, ncol = 1)

PG_S6_B

save(PG_S6_A, file = "~/PG_S6_A.RData")
save(PG_S6_B, file = "~/PG_S6_B.RData")


labelB <- textGrob("B", x = 0.03, y = 0.5, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG_S8_B = grid.arrange(arrangeGrob(SV_plot_e13, top = labelB), nrow = 1, ncol = 1)
save(SV_plot_e13, file = "C:/Users/dwo11kg/Documents/PG_S8_B.RData")

