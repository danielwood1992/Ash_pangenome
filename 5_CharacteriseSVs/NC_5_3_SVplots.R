rm(list=ls())

library("reshape2")
#install.packages("ggplot2")
library("ggplot2")
library("gridExtra")
#install.packages("ggnewscale")
#library("ggnewscale")
library("grid")
options(scipen=999)


#PG2_12_1
cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#0072B2", "#CC79A7")

results = read.csv("C:/Users/dwo11kg/PG2_13_1_results.txt", sep = " ", header = F)

head(results)
#results = read.csv("C:/Users/dwo11kg/PG2_13_1_results.txt.new", sep = " ", header = F)

#results = read.csv("C:/Users/dwo11kg/blork", sep = "", header = F)
results = results[results$V2 != "Total",]
results$V3 = results$V3/1000000
results
sum(results[results$V1 == 1,]$V3)

results2 = read.csv("C:/Users/dwo11kg/PG2_13_3_results.txt", sep  =" ", header = F)
head(results2)
results3 = data.frame()

results3[1,1] = 1
results3[1,2] = sum(results[results$V1 == 1,]$V3)
results3[1,3] = results2[results2$V1 == 1,]$V2
results3
results3[2,1] = 2
results3[2,2] = sum(results[results$V1 == 2,]$V3)
results3[2,3] = results2[results2$V1 == 2,]$V2

results3[3,1] = 3
results3[3,2] = sum(results[results$V1 == 3,]$V3)
results3[3,3] = results2[results2$V1 == 3,]$V2

results3[4,1] = 4
results3[4,2] = sum(results[results$V1 == 4,]$V3)
results3[4,3] = results2[results2$V1 == 4,]$V2

results3[5,1] = 5
results3[5,2] = sum(results[results$V1 == 5,]$V3)
results3[5,3] = results2[results2$V1 == 5,]$V2



#png(file="C:/Users/dwo11kg/Documents/poster1.png", width=1200, height=920)
#dev.off()
#grid.arrange(true_hist, type1_hist, type2_hist, ncol = 1, nrow = 3)
results3[6,1] = 10
results3[6,2] = sum(results[results$V1 == 10,]$V3)
results3[6,3] = results2[results2$V1 == 10,]$V2

results3$V4 =  as.numeric(results3$V3)/as.numeric(results3$V2)
results3
ggplot(results3, aes(x=V1, y=V4))+geom_point(size=5)+geom_line()+theme(text=element_text(size=30))+xlab("SV called in at least X samples")+ylab("Genes per Mb in SV sequences")+geom_hline(yintercept = 58.0, col = "red")
ggplot(results3, aes(x=V1, y=V2))+geom_point(size=5)+geom_line()+theme(text=element_text(size=30))+xlab("SV called in at least X samples")+ylab("Genes per Mb in SV sequences")

results
colnames(results) = c("Min_samples", "Type", "Sequence")
size_plot = ggplot(data=results, aes(x=Min_samples, y=Sequence, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_line(aes(col=Type, lwd = 1))+geom_point(aes(size=1))+theme(text=element_text(size=50))+
  ggtitle("Total SV sequence")+xlab("Minimum Samples")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 5)), linewidth = "none")+scale_x_continuous(breaks=c(1:50))

cbPalette

#write.csv(results, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/Fig2B.1.csv")

labelA <- textGrob("a", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 7))


size_plot
PG_Plot2C = ggplot(data=results, aes(x=Min_samples, y=Sequence, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Sequence), yend = 0),color = "red", lwd = 1)+theme_minimal(base_size = 12)+
  geom_line(aes(col=Type), lwd = 1)+geom_point(size=0.5)+
  theme(
    axis.title = element_text(size = 7, family = "Arial", color = "black"),
    axis.text = element_text(size = 6, family = "Arial", color = "black"),
    legend.text = element_text(size = 7, family = "Arial"),
    legend.title = element_text(size = 7, family = "Arial")
  )+
  xlab("Minimum Number of Individuals")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))+theme(legend.position = "none")

labelC <- textGrob("c", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 7))

PG2_Plot2C = grid.arrange(arrangeGrob(PG_Plot2C, top = labelC), nrow = 1, ncol = 1)


save(PG2_Plot2C, file = "~/PG2_Plot2C.RData")

#Sup fig
labelA <- textGrob("a", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

PG_Plot2B_INV = ggplot(data=results[results$Type == "INV",], aes(x=Min_samples, y=Sequence, group=Type))+
  scale_color_manual(values=cbPalette[4])+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Sequence), yend = 0),color = "red", lwd = 1)+theme_minimal(base_size = 11)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme(axis.title = element_text(size = 11, family = "Arial", color = "black"),
axis.text = element_text(size = 11, family = "Arial", color = "black"))+
  xlab("Minimum Number of Individuals")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))+theme(legend.position = "none")

PG_Plot2B_INV
labelC <- textGrob("c", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

PG_Plot2B_INV = grid.arrange(arrangeGrob(PG_Plot2B_INV, top = labelA), nrow = 1, ncol = 1)

PG_Plot2B_DUP = ggplot(data=results[results$Type == "DUP",], aes(x=Min_samples, y=Sequence, group=Type))+
  scale_color_manual(values=cbPalette[2])+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Sequence), yend = 0),color = "red", lwd = 1)+theme_minimal(base_size = 11)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme(axis.title = element_text(size = 11, family = "Arial", color = "black"),
                                                               axis.text = element_text(size = 11, family = "Arial", color = "black"))+
  xlab("Minimum Number of Individuals")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))+theme(legend.position = "none")

labelB <- textGrob("b", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))


PG_Plot2B_DUP = grid.arrange(arrangeGrob(PG_Plot2B_DUP, top = labelB), nrow = 1, ncol = 1)


ggplot(results, aes(x=V2, y = V3))+geom_bar(stat="identity")+ylab("Total Length (Mb)")+theme(text=element_text(size=30))+
  ggtitle("No filtering")+xlab("Type")
#So it's because there are...a billion, enormous inversions?

results_lengths = read.csv("C:/Users/dwo11kg/complete_merged_PG2_12_2.missing.0.vcf.lengths", header = F)
head(results_lengths)
sum(results_lengths$V1)
ggplot(results_lengths, aes(x=log10(V1)))+geom_histogram()+xlab("log10(length)")+theme(text=element_text(size=30))
max(results_lengths$V1) #So the maximum is 49Mb - that does seem a bit too long really...
results_lengths_shorter = results_lengths[results_lengths$V1 < 100000,]
dim(results_lengths)
sum(results_lengths$V1)
length(results_lengths_shorter)
length(results_lengths$V1)-length(results_lengths_shorter)



sum(results_lengths_shorter) #So that is actually 613,884,713

results = read.csv("C:/Users/dwo11kg/PG2_13_1_results.txt", sep = " ", header = F)
results$V3 = results$V3/1000000
results
#cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  
colnames(F1_df_melt) = c("names", "Statistic", "value")
ggplot(data=F1_df_melt, aes(x=names, y = value, group = Statistic))+geom_line(aes(col = Statistic, lwd = 5))+
  geom_point(size=5)+
  scale_size(guide="none")+
  theme(text=element_text(size=40), legend.key.width=unit(3, "line"))+
  scale_color_manual(values=cbbPalette)+
  guides(color = guide_legend(override.aes = list(lwd = 5)), linewidth = "none")+
  xlab("Method")


#Figure 3A

results = read.csv("C:/Users/dwo11kg/PG2_13_1_results.txt.nums", sep = " ", header = F)
results
colnames(results) = c("Type", "Number", "Samples")
results

sum(results[results$Samples == 1,]$Number)

#results = results[results$Samples > 2,]
#Claim2

sum(results[results$Samples == 3,]$Number)
results[results$Samples == 3,]

sv_numbers = ggplot(data=results, aes(x=Samples, y=Number, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_line(aes(col=Type, lwd = 5))+geom_point(aes(size=5))+theme_minimal(base_size = 12)+theme(axis.title=element_text(size=14))+
  ggtitle("Number of SVs")+xlab("Minimum Number of Individuals")+ylab("Number of SVs")+
  guides(color = guide_legend(override.aes = list(lwd = 5)), linewidth = "none")+scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10))

#write.csv(results, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/Fig2C.1.csv")

PG_Plot2A = ggplot(data=results, aes(x=Samples, y=Number, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Number), yend = 0),color = "red", lwd = 1)+
  geom_line(aes(col=Type), lwd = 1)+geom_point(size=0.4)+theme_minimal()+
  theme(
    axis.title = element_text(size = 7, family = "Arial", color = "black"),
    axis.text = element_text(size = 6, family = "Arial", color = "black"),
    legend.position = "none"
  )+
  xlab("Minimum Number of Individuals")+ylab("Number of SVs")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))

PG_Plot2A
labelA <- textGrob("a", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 7))

PG2_Plot2A = grid.arrange(arrangeGrob(PG_Plot2A, top = labelA), nrow = 1, ncol = 1)
save(PG2_Plot2A, file = "~/PG2_Plot2A.RData")


PG_Plot2C_INV = ggplot(data=results[results$Type == "INV",], aes(x=Samples, y=Number, group=Type))+
  scale_color_manual(values=cbPalette[4])+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Number), yend = 0),color = "red", lwd = 1)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme_minimal(base_size = 11)+theme(axis.title = element_text(size = 11, family = "Arial", color = "black"),
                                                                                              axis.text = element_text(size = 11, family = "Arial", color = "black"),
                                                                                                                       legend.position = "none")+
  xlab("Minimum Number of Individuals")+ylab("Number of SVs")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))

labelC <- textGrob("c", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

labelD <- textGrob("d", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 15))

PG_Plot2C_INV = grid.arrange(arrangeGrob(PG_Plot2C_INV, top = labelC), nrow = 1, ncol = 1)

PG_Plot2C_DUP = ggplot(data=results[results$Type == "DUP",], aes(x=Samples, y=Number, group=Type))+
  scale_color_manual(values=cbPalette[2])+
  scale_size(guide = "none")+
  geom_segment(aes(x = 4, xend = 4, y = max(Number), yend = 0),color = "red", lwd = 1)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme_minimal(base_size = 12)+theme(axis.title = element_text(size = 11, family = "Arial", color = "black"),
                                                                                              axis.text = element_text(size = 11, family = "Arial", color = "black"),
                                                                                                                       legend.position = "none")+
  xlab("Minimum Number of Individuals")+ylab("Number of SVs")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))

PG_Plot2C_DUP = grid.arrange(arrangeGrob(PG_Plot2C_DUP, top = labelD), nrow = 1, ncol = 1)


plot = grid.arrange(PG_Plot2B_INV, PG_Plot2B_DUP, PG_Plot2C_INV, PG_Plot2C_DUP)

ggsave("C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/PG_NC3_SupFig7.png", plot, width = 250, height = 200, units = "mm", dpi = 600)



scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_line(aes(col=Type, lwd = 5))+geom_point(aes(size=5))+theme(text=element_text(size=40))+
  ggtitle("Total SV sequence")+xlab("Minimum Samples")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 5)), linewidth = "none")+scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10))


#cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


types_lengths = read.csv("C:/Users/dwo11kg/complete_merged_PG2_12_2_tags.vcf.type_lengths", sep = " ", header = F)
types_lengths$color = "whatever"
types_lengths[types_lengths$V1 == "DEL",]$color = cbPalette[1]
types_lengths[types_lengths$V1 == "DUP",]$color = cbPalette[2]
types_lengths[types_lengths$V1 == "INS",]$color = cbPalette[3]
types_lengths[types_lengths$V1 == "INV",]$color = cbPalette[4]

x.expression = expression(log[10](SV~Length))

mean(types_lengths[types_lengths$V1 == "DEL",]$V2)
mean(types_lengths[types_lengths$V1 == "INS",]$V2)

woof = rbind(types_lengths[types_lengths$V1 == "DEL",], types_lengths[types_lengths$V1 == "INS",])
mean(woof$V2)
del = ggplV1del = ggplot(types_lengths[types_lengths$V1 == "DEL",], aes(x=log10(V2)))+
  geom_histogram(aes(fill=color))+theme(text=element_text(size=40))+
  xlab(x.expression)+ggtitle("DEL")+ scale_fill_identity()+xlim(1.2,5.5)

ins = ggplot(types_lengths[types_lengths$V1 == "INS",], aes(x=log10(V2)))+
  geom_histogram(aes(fill=color))+theme(text=element_text(size=40))+xlim(1.2,5.5)+
  xlab(x.expression)+ggtitle("INS")+ scale_fill_identity()

dup = ggplot(types_lengths[types_lengths$V1 == "DUP",], aes(x=log10(V2)))+
  geom_histogram(aes(fill=color))+theme(text=element_text(size=40), plot.margin = margin(5.5, 5.5, 5.5, 40))+xlim(1.2,5.5)+
  xlab(x.expression)+ggtitle("DUP")+ scale_fill_identity()

inv = ggplot(types_lengths[types_lengths$V1 == "INV",], aes(x=log10(V2)))+
  geom_histogram(aes(fill=color))+theme(text=element_text(size=40), plot.margin = margin(5.5, 5.5, 5.5, 50))+xlim(1.2,5.5)+
  xlab(x.expression)+ggtitle("INV")+ scale_fill_identity()



grid.arrange(nrow = 2, ncol = 2, del, ins, dup, inv)

png(file="C:/Users/dwo11kg/Documents/poster4.png", width=1250, height=920)

grid.arrange(nrow = 2, ncol = 2, del, ins, dup, inv)

dev.off()



ggplot(types_lengths[types_lengths$V1 == "DUP",], aes(x=log10(V2)))+geom_histogram()+theme(text=element_text(size=30))+xlab("log10(Length)")+ggtitle("DUP")
ggplot(types_lengths[types_lengths$V1 == "INS",], aes(x=log10(V2)))+geom_histogram()+theme(text=element_text(size=30))+xlab("log10(Length)")+ggtitle("INS")
ggplot(types_lengths[types_lengths$V1 == "INV",], aes(x=log10(V2)))+geom_histogram()+theme(text=element_text(size=30))+xlab("log10(Length)")+ggtitle("INV")


#So it is actually...

results
#colnames(results) = c("MAF_filter", "Type", "Length", "Mb_Sequence")
colnames(results) = c("MAF_filter", "Type", "Mb_Sequence")
head(results)
results$Mb_Sequence = results$Mb_Sequence/1000000
results
#results[results$Length == "0",]$Length = ">0bp"
#results
#results[results$Length == "500",]$Length = ">500bp"#
#results
#results[results$Length == "100000",]$Length = "<100000bp"
#results$Length = factor(results$Length, levels=c(">0",">500"))

#results$Length = factor(results$Length, levels=c("0","500"))
#results$Length
#ggplot(data=results, aes(x=MAF_filter, y=Mb_Sequence, group=paste(Type, Length), linetype=Length))+geom_point()+geom_line(aes(col=Type))+theme(text=element_text(size=30))+ggtitle("50 Sample Total SVs")
ggplot(data=results, aes(x=MAF_filter, y=Mb_Sequence, group=Type))+
  geom_point()+geom_line(aes(col=Type))+theme(text=element_text(size=30))+
  ggtitle("50 Sample Total SVs")+xlab("")

#PG2_13_5 - looking at SV curves...
library(ggplot2)
curves = read.csv("C:/Users/dwo11kg/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.PG2_13_5.3.txt.out", sep = " ", header = F)
head(curves)
curves = curves[,c(2,1,3)]
colnames(curves) = c("V1", "V2", "V3")
#curves = read.csv("C:/Users/dwo11kg/PG2_13_5.2_results.txt", sep = " ", header = F)
head(curves)
curves$Repeats = as.character(curves$V2)
Fig2B = ggplot(curves, aes(x=V1, y=V3, col=Repeats))+geom_line(aes(group=Repeats), linewidth=0.5)+
  geom_point(size=0.4)+theme_minimal()+
  theme(
    axis.title = element_text(size = 7, family = "Arial", color = "black"),
    axis.text = element_text(size = 6, family = "Arial", color = "black"),
    legend.position = "none"
  )+
  ylab("Number of SVs")+xlab("Individuals")+ylim(100000,800000)+xlim(0,51)

plot(Fig2B)
#So I guess the question is...why doesn't this add up to 350,000? Oh is this because it's being done on all of them? 
curves_print = curves
colnames(curves_print) = c("N_individuals", "Replicate", "N_Svs", "Replicate_again")

#write.csv(curves_print, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/Fig2A.1.csv")

  
library(grid)
library(gridExtra)

labelB <- textGrob("b", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 7))

PG2_Plot2B = grid.arrange(arrangeGrob(Fig2B, top = labelB), nrow = 1, ncol = 1)

save(PG2_Plot2B, file = "~/PG2_Plot2B.RData")



curves_plot
#ggplot(curves, aes(x=V1, group=V1, y=V3))+geom_boxplot()+theme(text=element_text(size=0))+ylab("SVs")+xlab("Individuals")+ylim(0,800000)


library(grid)
library(gridExtra)

labelA <- textGrob("A", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))



png(file="C:/Users/dwo11kg/Documents/poster5.png", width=1250, height=920)
curves_plot
dev.off()


