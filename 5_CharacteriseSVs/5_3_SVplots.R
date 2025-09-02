library("reshape2")
#install.packages("ggplot2")
library("ggplot2")
library("gridExtra")
#install.packages("ggnewscale")
library("ggnewscale")
library("grid")
options(scipen=999)

rm(list=ls())

#PG2_12_1
cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#0072B2", "#CC79A7")

results = read.csv("C:/Users/dwo11kg/PG2_13_1_results.txt", sep = " ", header = F)

head(results)

results = results[results$V2 != "Total",]
results$V3 = results$V3/1000000
results
sum(results[results$V1 == 1,]$V3)

colnames(results) = c("Min_samples", "Type", "Sequence")

PG_Plot2B = ggplot(data=results, aes(x=Min_samples, y=Sequence, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_segment(aes(x = 3, xend = 3, y = max(Sequence), yend = 0),color = "red", lwd = 1)+theme_minimal(base_size = 12)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme(axis.title = element_text(size = 14))+
  xlab("Minimum Number of Individuals")+ylab("Mb Sequence")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))+theme(legend.position = "none")

PG_Plot2B

labelB <- textGrob("B", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG2_Plot2B = grid.arrange(arrangeGrob(PG_Plot2B, top = labelB), nrow = 1, ncol = 1)

PG2_Plot2B

save(PG2_Plot2B, file = "~/PG2_Plot2B.RData")


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

PG_Plot2C = ggplot(data=results, aes(x=Samples, y=Number, group=Type))+
  scale_color_manual(values=cbPalette)+
  scale_size(guide = "none")+
  geom_segment(aes(x = 3, xend = 3, y = max(Number), yend = 0),color = "red", lwd = 1)+
  geom_line(aes(col=Type), lwd = 2)+geom_point(size=1.5)+theme_minimal(base_size = 12)+theme(axis.title=element_text(size=14), legend.position = "none")+
  xlab("Minimum Number of Individuals")+ylab("Number of SVs")+
  guides(color = guide_legend(override.aes = list(lwd = 1)), linewidth = "none")+scale_x_continuous(breaks=c(seq(0,50,5)))

PG_Plot2C
labelC <- textGrob("C", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG2_Plot2C = grid.arrange(arrangeGrob(PG_Plot2C, top = labelC), nrow = 1, ncol = 1)
save(PG2_Plot2C, file = "~/PG2_Plot2C.RData")

#PG2_13_5 - looking at SV curves...
library(ggplot2)
curves = read.csv("C:/Users/dwo11kg/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.PG2_13_5.3.txt.out", sep = " ", header = F)
head(curves)
curves = curves[,c(2,1,3)]
colnames(curves) = c("V1", "V2", "V3")
#curves = read.csv("C:/Users/dwo11kg/PG2_13_5.2_results.txt", sep = " ", header = F)
head(curves)
curves$Repeats = as.character(curves$V2)
Fig2A = ggplot(curves, aes(x=V1, y=V3, col=Repeats))+geom_line(aes(group=Repeats), linewidth=0.5)+
  geom_point(size=1)+theme_minimal(base_size = 12)+theme(axis.title=element_text(size=14), legend.position = "none")+
  ylab("Number of SVs")+xlab("Individuals")+ylim(100000,800000)+xlim(0,51)

Fig2A
#So I guess the question is...why doesn't this add up to 350,000? Oh is this because it's being done on all of them? 


library(grid)
library(gridExtra)

labelA <- textGrob("A", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG2_Plot2A = grid.arrange(arrangeGrob(Fig2A, top = labelA), nrow = 1, ncol = 1)

save(PG2_Plot2A, file = "~/PG2_Plot2A.RData")



curves_plot
#ggplot(curves, aes(x=V1, group=V1, y=V3))+geom_boxplot()+theme(text=element_text(size=0))+ylab("SVs")+xlab("Individuals")+ylim(0,800000)


library(grid)
library(gridExtra)

labelA <- textGrob("A", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))



png(file="C:/Users/dwo11kg/Documents/poster5.png", width=1250, height=920)
curves_plot
dev.off()


