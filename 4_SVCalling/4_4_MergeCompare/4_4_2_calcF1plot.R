rm(list=ls())
library("reshape2")
library("ggplot2")
library("gridExtra")
#install.packages("ggnewscale")
library("ggnewscale")
options(scipen=999)

cantata_sv_total_length = read.csv("C:/Users/dwo11kg/variants.vcf.filt3.vcf.hap2.lengths", header = F)
cantata_sv_total_length$V1 = as.numeric(cantata_sv_total_length$V1)
cantata_sv_total_length = na.omit(cantata_sv_total_length)
sum(cantata_sv_total_length$V1) #94Mb. 


results_ST = read.csv("C:/Users/dwo11kg/PG2_12_3_ST_results.txt", sep = " ", header = T)
results_ST
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


#Plots that didn't make it into the paper

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


#Calculating F1, precision and recall - assuming 3S_svim_cantata (hap2 mapped against BATG-1.0, called using
#svim-asm) is the "truth set", or as close as we can get to it. 


F1_df = data.frame(names =  c("1:cuteSV+sniffles", "2:shasta", "3:flye", "4:nextdenovo", 
                              "1 OR 2", "1 OR 3", "1 OR 4"))
F1_df$precision = rep(1, nrow(F1_df))
F1_df$recall = rep(1, nrow(F1_df))
F1_df$F1 = rep(1, nrow(F1_df))
F1_df

#So precisionision is going to be 3S_AND_METHOD/METHOD
#and recall will be 3S_AND_METHOD/total_3S

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
F1_df$names = c("1", "2", "3", "4", "5", "6", "7")

F1_df$names = factor(F1_df$names, levels = F1_df$names)
F1_df

F1_df_melt = melt(F1_df)
F1_df_melt
#Claim1
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73")

library(grid)
library(gridExtra)

labelA <- textGrob("A", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))


#Fig2A
PG2_Supp1 = ggplot(data=F1_df_melt, aes(x=names, y = value, group = variable))+geom_line(aes(col = variable), lwd = 2)+theme_minimal()+
  geom_point(size=3)+
  scale_size(guide="none")+
  theme(text=element_text(size=14), legend.key.width=unit(1, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+
  xlab("Method")+theme(legend.position = "none")

F1_df_melt
PG2_Supp1

ggsave("PG_S1.png", PG2_Supp1, width = 200, height = 150, units = "mm", dpi = 600, bg = "white")
