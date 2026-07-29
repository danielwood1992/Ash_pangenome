rm(list=ls())
library("reshape2")
library("ggplot2")
library("gridExtra")
#install.packages("ggnewscale")
#library("ggnewscale")
options(scipen=999)

cantata_sv_total_length = read.csv("C:/Users/dwo11kg/variants.vcf.filt3.vcf.hap2.lengths", header = F)
cantata_sv_total_length$V1 = as.numeric(cantata_sv_total_length$V1)
cantata_sv_total_length = na.omit(cantata_sv_total_length)
sum(cantata_sv_total_length$V1) #94Mb. 

results_ST = read.csv("C:/Users/dwo11kg/PG2_12_3_ST_results.txt", sep = " ", header = T)
results_ST

results_ST = read.csv("C:/Users/dwo11kg/NC_4_4_1.1_ST_results.txt.DEL", sep = " ", header = T)
#results_ST = read.csv("C:/Users/dwo11kg/NC_4_4_1.1_ST_results.txt.INS", sep = " ", header = T)
#results_ST = read.csv("C:/Users/dwo11kg/NC_4_4_1.1_ST_results.txt.INV", sep = " ", header = T)
#results_ST = read.csv("C:/Users/dwo11kg/NC_4_4_1.1_ST_results.txt.DUP", sep = " ", header = T)

results_ST$Type = factor(results_ST$Type, levels = rev(c("ST_1_AND_2_bothreadmapping", "3S_svim_cantata", "4S_svim_ont_shasta", 
                                                     "5S_svim_ont_flye", "6S_svim_ont_nextdenovo", 
                                                     "ST_3S_AND_4S", "ST_3S_AND_5S", "ST_3S_AND_6S",
                                                     "ST_1_AND_2_AND_3S", "ST_1_AND_2_AND_4S",
                                                     "ST_1_AND_2_AND_5S", "ST_1_AND_2_AND_6S",
                                                     "ST_1_AND_2_OR_4S", "ST_1_AND_2_OR_5S", 
                                                     "ST_1_AND_2_OR_6S", "ST_B_1_AND_2_OR_4S_B_AND_3S",
                                                     "ST_B_1_AND_2_OR_5S_B_AND_3S", "ST_B_1_AND_2_OR_6S_B_AND_3S")))

ggplot(data = results_ST, aes(x = Type, y = Number))+geom_bar(stat="identity",aes())+xlab("SV Set")+
  ylab("Number of SVs")+theme(text=element_text(size=20), legend.position="none")+coord_flip()+
  ggtitle("")

results_ST

resultsA = results_ST[c(1,2,3,4,5,6,7,8,9,10,11,12),]
resultsA

resultsA$Type = factor(resultsA$Type, levels = rev(c("ST_1_AND_2_bothreadmapping", "3S_svim_cantata", "4S_svim_ont_shasta", 
                                                         "5S_svim_ont_flye", "6S_svim_ont_nextdenovo", 
                                                         "ST_3S_AND_4S", "ST_3S_AND_5S", "ST_3S_AND_6S",
                                                         "ST_1_AND_2_AND_3S", "ST_1_AND_2_AND_4S",
                                                         "ST_1_AND_2_AND_5S", "ST_1_AND_2_AND_6S")))


resultsA$Plot1 = rep("black", nrow(resultsA))
resultsA
resultsA[1,4] = "orange"
resultsA[5,4] = "orange"
resultsA[6,4] = "orange"

resultsA$Plot2 = rep("black", nrow(resultsA))
resultsA
resultsA[2,5] = "orange"
resultsA[10,5] = "orange"
resultsA[3,5] = "blue"
resultsA[11,5] = "blue"
resultsA[4,5] = "green"
resultsA[12,5] = "green"

resultsA$Plot3 = rep("black", nrow(resultsA))
resultsA
resultsA[2,6] = "orange"
resultsA[7,6] = "orange"
resultsA[3,6] = "blue"
resultsA[8,6] = "blue"
resultsA[4,6] = "green"
resultsA[9,6] = "green"

ggplot(data = resultsA, aes(x = Type, y = Number))+geom_bar(stat="identity",aes(fill=Plot1))+xlab("SV Set")+
  ylab("Number of SVs")+theme(text=element_text(size=20), legend.position="none")+coord_flip()+
  ggtitle("SVIM-asm overlaps way more with mapping")


ggplot(data = resultsA, aes(x = Type, y = Number))+geom_bar(stat="identity",aes(fill=Plot2))+xlab("SV Set")+
  ylab("Number of SVs")+theme(text=element_text(size=20), legend.position="none")+coord_flip()+
  ggtitle("SVIM-asm: Shasta ONT has least false +ves")

ggplot(data = resultsA, aes(x = Type, y = Number))+geom_bar(stat="identity",aes(fill=Plot3))+xlab("SV Set")+
  ylab("Number of SVs")+theme(text=element_text(size=20), legend.position="none")+coord_flip()+
  ggtitle("Almost all SVIM-asm calls overlap with read-mapping")


#So it would be nice to work out the precision, recall and F1 scores of these various approaches.
#I guess the approaches being...
F1_df = data.frame(names =  c("1:cuteSV+sniffles", "2:shasta", "3:flye", "4:nextdenovo", 
                              "1 OR 2", "1 OR 3", "1 OR 4"))
F1_df$precision = rep(1, nrow(F1_df))
F1_df$recall = rep(1, nrow(F1_df))
F1_df$F1 = rep(1, nrow(F1_df))
F1_df

#So precisionision is going to be 3S_AND_thing/thing
#and recall will be 3S_AND_thing/total_3S

#ST_1_AND_2 only
results_ST
results_ST[results_ST$Type == "ST_1_AND_2_bothreadmapping",]$Number

F1_df[F1_df$names == "1:cuteSV+sniffles",]$precision = results_ST[results_ST$Type == "ST_1_AND_2_AND_3S",]$Number/results_ST[results_ST$Type == "ST_1_AND_2_bothreadmapping",]$Number
F1_df[F1_df$names == "1:cuteSV+sniffles",]$recall = results_ST[results_ST$Type == "ST_1_AND_2_AND_3S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "1:cuteSV+sniffles",]$F1 = 2*F1_df[F1_df$names == "1:cuteSV+sniffles",]$precision*F1_df[F1_df$names == "1:cuteSV+sniffles",]$recall/(F1_df[F1_df$names == "1:cuteSV+sniffles",]$precision + F1_df[F1_df$names == "1:cuteSV+sniffles",]$recall)
F1_df  

#4S only
F1_df[F1_df$names == "2:shasta",]$precision = results_ST[results_ST$Type == "ST_3S_AND_4S",]$Number/results_ST[results_ST$Type == "4S_svim_ont_shasta",]$Number
F1_df[F1_df$names == "2:shasta",]$recall = results_ST[results_ST$Type == "ST_3S_AND_4S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "2:shasta",]$F1 = 2*F1_df[F1_df$names == "2:shasta",]$precision*F1_df[F1_df$names == "2:shasta",]$recall/(F1_df[F1_df$names == "2:shasta",]$precision + F1_df[F1_df$names == "2:shasta",]$recall)

#5S only
F1_df[F1_df$names == "3:flye",]$precision = results_ST[results_ST$Type == "ST_3S_AND_5S",]$Number/results_ST[results_ST$Type == "5S_svim_ont_flye",]$Number
F1_df[F1_df$names == "3:flye",]$recall = results_ST[results_ST$Type == "ST_3S_AND_5S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "3:flye",]$F1 = 2*F1_df[F1_df$names == "3:flye",]$precision*F1_df[F1_df$names == "3:flye",]$recall/(F1_df[F1_df$names == "3:flye",]$precision + F1_df[F1_df$names == "3:flye",]$recall)

#6S only
F1_df[F1_df$names == "4:nextdenovo",]$precision = results_ST[results_ST$Type == "ST_3S_AND_6S",]$Number/results_ST[results_ST$Type == "6S_svim_ont_nextdenovo",]$Number
F1_df[F1_df$names == "4:nextdenovo",]$recall = results_ST[results_ST$Type == "ST_3S_AND_6S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "4:nextdenovo",]$F1 = 2*F1_df[F1_df$names == "4:nextdenovo",]$precision*F1_df[F1_df$names == "4:nextdenovo",]$recall/(F1_df[F1_df$names == "4:nextdenovo",]$precision + F1_df[F1_df$names == "4:nextdenovo",]$recall)
F1_df

results_ST[results_ST$Type == "ST_B_1_AND_2_OR_4S_B_AND_3S",]$Number/results_ST[results_ST$Type == "ST_1_AND_2_OR_4S",]$Number
#ST_1_AND_2 OR 4S
F1_df[F1_df$names == "1 OR 2",]$precision = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_4S_B_AND_3S",]$Number/results_ST[results_ST$Type == "ST_1_AND_2_OR_4S",]$Number
F1_df[F1_df$names == "1 OR 2",]$recall = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_4S_B_AND_3S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "1 OR 2",]$F1 = 2*F1_df[F1_df$names == "1 OR 2",]$precision*F1_df[F1_df$names == "1 OR 2",]$recall/(F1_df[F1_df$names == "1 OR 2",]$precision + F1_df[F1_df$names == "1 OR 2",]$recall)
F1_df

#ST_1_AND_2 OR 5S
F1_df[F1_df$names == "1 OR 3",]$precision = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_5S_B_AND_3S",]$Number/results_ST[results_ST$Type == "ST_1_AND_2_OR_5S",]$Number
F1_df[F1_df$names == "1 OR 3",]$recall = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_5S_B_AND_3S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "1 OR 3",]$F1 = 2*F1_df[F1_df$names == "1 OR 3",]$precision*F1_df[F1_df$names == "1 OR 3",]$recall/(F1_df[F1_df$names == "1 OR 3",]$precision + F1_df[F1_df$names == "1 OR 3",]$recall)
F1_df

#ST_1_AND_2 OR 6S
F1_df[F1_df$names == "1 OR 4",]$precision = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_6S_B_AND_3S",]$Number/results_ST[results_ST$Type == "ST_1_AND_2_OR_6S",]$Number
F1_df[F1_df$names == "1 OR 4",]$recall = results_ST[results_ST$Type == "ST_B_1_AND_2_OR_6S_B_AND_3S",]$Number/results_ST[results_ST$Type == "3S_svim_cantata",]$Number
F1_df[F1_df$names == "1 OR 4",]$F1 = 2*F1_df[F1_df$names == "1 OR 4",]$precision*F1_df[F1_df$names == "1 OR 4",]$recall/(F1_df[F1_df$names == "1 OR 4",]$precision + F1_df[F1_df$names == "1 OR 4",]$recall)
F1_df


#Deletions:
#names precision    recall        F1
#1 1:cuteSV+sniffles 0.7212347 0.8268112 0.7704228
#2          2:shasta 0.9258457 0.5111448 0.6586560
#3            3:flye 0.8219936 0.5286257 0.6434485
#4      4:nextdenovo 0.8767567 0.2519327 0.3913986
#5            1 OR 2 0.7262757 0.8919795 0.8006439
#6            1 OR 3 0.7034999 0.8966021 0.7883991
#7            1 OR 4 0.7207386 0.8668739 0.7870806

#Insertions:
#1 1:cuteSV+sniffles 0.7369099 0.7530028 0.7448694
#2          2:shasta 0.9140237 0.5051096 0.6506537
#3            3:flye 0.7998456 0.5800039 0.6724118
#4      4:nextdenovo 0.8286896 0.6337038 0.7181977
#5            1 OR 2 0.7433522 0.8335526 0.7858727
#6            1 OR 3 0.7143238 0.8260212 0.7661226
#7            1 OR 4 0.7262455 0.8277291 0.7736735

#Inversions: 
#names precision    recall        F1
#1 1:cuteSV+sniffles 0.4838710 0.3658537 0.4166667
#2          2:shasta 0.6111111 0.5365854 0.5714286
#3            3:flye 0.4920635 0.7560976 0.5961538
#4      4:nextdenovo 0.5757576 0.4634146 0.5135135
#5            1 OR 2 0.5000000 0.6585366 0.5684211
#6            1 OR 3 0.4533333 0.8292683 0.5862069
#7            1 OR 4 0.4901961 0.6097561 0.5434783
#Not very many inversions: 
#1  cantata_PG2_12_1.1.INV             3S_svim_cantata     41
#2  cantata_PG2_12_1.1.INV          4S_svim_ont_shasta     36
#3  cantata_PG2_12_1.1.INV            5S_svim_ont_flye     63
#4  cantata_PG2_12_1.1.INV      6S_svim_ont_nextdenovo     33
#5  cantata_PG2_12_1.1.INV  ST_1_AND_2_bothreadmapping     31
#6  cantata_PG2_12_1.1.INV           ST_1_AND_2_AND_3S     15
#7  cantata_PG2_12_1.1.INV           ST_1_AND_2_AND_4S     13
#8  cantata_PG2_12_1.1.INV           ST_1_AND_2_AND_5S     16
#9  cantata_PG2_12_1.1.INV           ST_1_AND_2_AND_6S     13
#10 cantata_PG2_12_1.1.INV                ST_3S_AND_4S     22
#11 cantata_PG2_12_1.1.INV                ST_3S_AND_5S     31
#12 cantata_PG2_12_1.1.INV                ST_3S_AND_6S     19
#13 cantata_PG2_12_1.1.INV            ST_1_AND_2_OR_4S     54
#14 cantata_PG2_12_1.1.INV            ST_1_AND_2_OR_5S     75
#15 cantata_PG2_12_1.1.INV            ST_1_AND_2_OR_6S     51
#16 cantata_PG2_12_1.1.INV ST_B_1_AND_2_OR_4S_B_AND_3S     27
#17 cantata_PG2_12_1.1.INV ST_B_1_AND_2_OR_5S_B_AND_3S     34
#18 cantata_PG2_12_1.1.INV ST_B_1_AND_2_OR_6S_B_AND_3S     25

#F1_df$names = c("1", "2", "3", "4", "5", "6", "7")

F1_df$names = c("A", "B", "C", "D", "E", "F", "G")


F1_df$names = factor(F1_df$names, levels = F1_df$names)
F1_df

F1_df_melt = melt(F1_df)
F1_df_melt
#Claim1
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73")

library(grid)
library(gridExtra)


#For supplementary Figure
#INS:
labelA <- textGrob("a", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                  gp = gpar(fontface = "bold", fontsize = 15))

#DEL:
labelB <- textGrob("b", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                  gp = gpar(fontface = "bold", fontsize = 15))

#INV:
labelC <- textGrob("c", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

#DUP
labelD <- textGrob("d", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

#write.csv(F1_df_melt, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigE1.1.csv")
#write.csv(F1_df_melt, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS4.1.csv")
#write.csv(F1_df_melt, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS4.2.csv")
#write.csv(F1_df_melt, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS4.3.csv")
#write.csv(F1_df_melt, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS4.4.csv")

PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value, group = variable))+geom_line(aes(col = variable), lwd = 2)+theme_minimal()+
  geom_point(size=3)+
  scale_size(guide="none")+
  theme(text=element_text(size=14), legend.key.width=unit(1, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
  xlab("Method")+theme(legend.position = "none")

F1_df_melt
PG2_Supp1

#PG2_PlotS3_INS = grid.arrange(arrangeGrob(PG2_Supp1, top = labelA), nrow = 1, ncol = 1)
#save(PG2_PlotS3_INS, file = "~/PG2_PlotS3_INS.RData")

#PG2_PlotS3_DEL = grid.arrange(arrangeGrob(PG2_Supp1, top = labelB), nrow = 1, ncol = 1)
#save(PG2_PlotS3_DEL, file = "~/PG2_PlotS3_DEL.RData")
#
#PG2_PlotS3_INV = grid.arrange(arrangeGrob(PG2_Supp1, top = labelC), nrow = 1, ncol = 1)
#save(PG2_PlotS3_INV, file = "~/PG2_PlotS3_INV.RData")

PG2_PlotS3_DUP = grid.arrange(arrangeGrob(PG2_Supp1, top = labelD), nrow = 1, ncol = 1)
save(PG2_PlotS3_DUP, file = "~/PG2_PlotS3_DUP.RData")

#For extended data Figure

labelA <- textGrob("a", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))


#Fig2A
PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value, group = variable))+geom_line(aes(col = variable), lwd = 2)+theme_minimal()+
  geom_point(size=3)+
  scale_size(guide="none")+
  theme(text=element_text(size=11, family = "Arial"), legend.key.width=unit(1, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
  xlab("Method")+theme(legend.position = "none")

F1_df_melt
PG2_Supp1


PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value, group = variable))+geom_line(aes(col = variable), lwd = 2)+theme_minimal()+
  geom_point(size=3)+
  scale_size(guide="none")+
  theme(text=element_text(size=14), legend.key.width=unit(1, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
  xlab("Method")+theme(legend.position = "none")#+ggtitle("INS")


#PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value, group = variable, color = variable))+theme_minimal()+
#  geom_point(size=3)+
 # scale_size(guide="none")+
#  theme(text=element_text(size=14), legend.key.width=unit(1, "line"))+
 # scale_color_manual(values=cbbPalette)+
#  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
#  xlab("Method")+theme(legend.position = "none")+ggtitle("INS")

PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value))+theme_minimal()+
  geom_point(size=3, col = variable)+
  scale_size(guide="none")+
  theme(text=element_text(size=11, family = "Arial"), legend.key.width=unit(1, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
  xlab("Method")+theme(legend.position = "none")#+ggtitle("INS")




F1_df_melt
PG2_Supp1



ggsave("PG_S1.png", PG2_Supp1, width = 200, height = 150, units = "mm", dpi = 600, bg = "white")



#PG2_Plot2A = grid.arrange(arrangeGrob(Fig2A, top = labelA), nrow = 1, ncol = 1)
#PG2_Plot2A = grid.arrange(arrangeGrob(Fig2A, top = labelA), nrow = 1, ncol = 1)

#save(PG2_Plot2A, file = "~/PG2_Plot2A.RData")

"\u2229" #
"\u222A"

#Looking at lengths of the "TRUE", "TYPE1" and "TYPE2" sets
#Should get the paper trail for this if you mention it. 
true_set = read.csv("C:/Users/dwo11kg/variants.vcf.filt3.vcf.hap2.lengths", header = F)
true_set$V2 = "true"
true_set$V1 = as.numeric(true_set$V1)

type1_set = read.csv("C:/Users/dwo11kg/variants.vcf.filt3.vcf.AnotB.Type1_Type2.lengths", header = F, sep = "\t")
type1_set$V2 = "type1"
type2_set = read.csv("C:/Users/dwo11kg/cantata_PG2_12_1.1.PG2_12_3_ST_results.txt.ST_1_AND_2_OR_4S.vcf.AnotB.Type1_Type2.lengths", header = F, sep = "\t")
type2_set$V2 = "type2"
dim(type1_set)
dim(type2_set)
dim(true_set)
min(type1_set$V1)
min(type2_set$V1)
min(true_set$V1)

x.expression = expression(log[10](SV~Length))

true_hist = ggplot(true_set, aes(x = log10(V1)))+geom_histogram(fill = "#009E73")+
  theme(text=element_text(size=40), axis.text.x = element_text(size=30))+xlab("log10(SV Length)")+xlim(1,5)+xlab(x.expression)+
  ggtitle("\"Truth\" set")
true_hist
type2_hist = ggplot(type1_set, aes(x = log10(V1)))+geom_histogram(fill = "#009E73")+
  theme(text=element_text(size=40), axis.text.x = element_text(size=30), plot.margin = margin(5.5, 5.5, 5.5, 30))+xlab("log10(SV Length)")+xlim(1,5)+
  xlab(x.expression)+
  ggtitle("\"Type 2 Errors\"")
#type1_hist

type1_hist = ggplot(type2_set, aes(x = log10(V1)))+geom_histogram(fill = "#009E73")+
  theme(text=element_text(size=40), axis.text.x = element_text(size=30), plot.margin  = margin(5.5, 5.5, 5.5, 30))+xlab(x.expression)+xlim(1,5)+
  ggtitle("\"Type 1 Errors\"")
type2_hist
grid.arrange(true_hist, type1_hist, type2_hist, ncol = 1, nrow = 3)
png(file="C:/Users/dwo11kg/Documents/poster1.png", width=1200, height=920)
grid.arrange(true_hist, type1_hist, type2_hist, ncol = 1, nrow = 3)
dev.off()


#ST_1_AND_2 OR 6S
#ST_1_AND_2 OR 6S
#ST_1_AND_2 OR 6S
#Also try the haplotype method I guess...

results_ST_red = results_ST[c(1,13,14),]
results_ST_red$Type = c("Cantata hap2", "Mapping+ONT Assembly", "Overlap")
results_ST_red$Type = factor(results_ST_red$Type, levels = rev(c("Cantata hap2", "Mapping+ONT Assembly", "Overlap")))
ggplot(data = results_ST_red, aes(x = Type, y = Number))+geom_bar(stat="identity",aes())+xlab("SV Set")+
  ylab("Number of SVs")+theme(text=element_text(size=15), legend.position="none")+coord_flip()+
  ggtitle("")
results_ST_red[3,3]/results_ST_red[1,3]

