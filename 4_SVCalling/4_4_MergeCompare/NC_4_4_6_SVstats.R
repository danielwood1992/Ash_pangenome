#Arranging multiple panels from different R scripts...
rm(list=ls())
library("reshape2")
library("ggplot2")
#install.packages("gridExtra")
library("gridExtra")
#install.packages("ggnewscale")
library("ggnewscale")
options(scipen=999)
library(grid)
library(gridExtra)
library(png)

#PG2_12_1

results = read.csv("C:/Users/dwo11kg/PG2_12_1_results.txt", sep = " ", header = T)
dim(results)
results = results[results$Name != "S47_fastq",]
dim(results)

results[results$Type == "1_AND_2_bothreadmapping",]$Type = "cuteSV+Sniffles2"
results[results$Type == "1_AND_4",]$Type = "sniffles+svim_asm"
results[results$Type == "2_AND_4",]$Type = "cutesv+svim_asm"
results[results$Type == "1_AND_2_AND_4",]$Type = "cuteSV+Sniffles2+svim_asm"
results[results$Type == "svim_nums",]$Type = "svim_asm"
results[results$Type == "1_AND_2_OR_4",]$Type = "cuteSV+Sniffles2_AND/OR_svim_asm"

results$Type = factor(results$Type, levels = c("sniffles", "cutesv", "svim_asm", "cuteSV+Sniffles2", "sniffles+svim_asm", "cutesv+svim_asm", "cuteSV+Sniffles2+svim_asm", "cuteSV+Sniffles2_AND/OR_svim_asm"))

#results$Type = factor(results$Type, levels = c("1+2_bothreadmapping", "3_assemblytics_cantata", "4_assemblytics_ont_shasta", "5_assemblytics_ont_flye", "6_assemblytics_nextdenovo", "1+2+3", "1+2+4", "1+2+5", "1+2+6", "3+4", "3+5", "3+6", "3+4+5+6"))

ggplot(data = results, aes(x = Type, y = Number))+geom_boxplot()+xlab("SV Set")+ylab("Number of SVs")+theme(text=element_text(size=40), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

to_keep = c("svim_asm", "cuteSV+Sniffles2", "cuteSV+Sniffles2+svim_asm", "cuteSV+Sniffles2_AND/OR_svim_asm")

results2 = results[results$Type %in% to_keep,]

labelA <- textGrob("a", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))


plot1 = ggplot(data = results2, aes(x = Type, y = Number))+geom_boxplot()+xlab("SV Set")+ylab("Number of SVs")+theme(text=element_text(size=11), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+ylim(0,200000)

head(results2)

#write.csv(results2, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS5.1.csv")


X1A = grid.arrange(arrangeGrob(plot1, top = labelA), nrow = 1, ncol = 1)


svim_asm = results2[results2$Type == "svim_asm",]
all = results2[results2$Type == "cuteSV+Sniffles2+svim_asm",]
sniffles_cutesv = results2[results2$Type == "cuteSV+Sniffles2",]
svim_asm_prop_all = merge(svim_asm, all, by = "Name")
svim_asm_prop_all$prop = svim_asm_prop_all$Number.y / svim_asm_prop_all$Number.x
sniffles_cutesv_prop_all = merge(sniffles_cutesv, all, by = "Name")
sniffles_cutesv_prop_all$prop = sniffles_cutesv_prop_all$Number.y / sniffles_cutesv_prop_all$Number.x
head(sniffles_cutesv_prop_all)
sniffles_cutesv_prop_all$Comp = "cuteSV+Sniffles2"
svim_asm_prop_all$Comp = "svim-asm"
both_comps = rbind(sniffles_cutesv_prop_all, svim_asm_prop_all)

labelB <- textGrob("b", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

head(both_comps)

#write.csv(both_comps, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS5.2.csv")


plot2 = ggplot(data = both_comps, aes(x = Comp, y = prop))+geom_boxplot()+xlab("Comparison")+ylab("Proportion")+theme(text=element_text(size=11), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+ylim(0,1)

X1B = grid.arrange(arrangeGrob(plot2, top = labelB), nrow = 1, ncol = 1)


plot = grid.arrange(X1A, X1B, ncol = 2, nrow = 1)

median(both_comps[both_comps$Comp == "cuteSV+Sniffles2",]$prop)
median(both_comps[both_comps$Comp == "svim-asm",]$prop)

save(PGX1A, file = "~/PGX1A.RData")

ggsave("C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/PG_NC3_SupFig6.png", plot, width = 250, height = 200, units = "mm", dpi = 600)


