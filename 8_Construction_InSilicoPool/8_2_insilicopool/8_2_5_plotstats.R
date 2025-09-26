rm(list=ls())

library(ggplot2)
library(reshape2)
library(gridExtra)



whatever = read.csv("C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_8_6.2_statsummaryResults.txt", header = F, sep = " ")
head(whatever)
table(whatever$V3)

#So then we can subset this
whatever[whatever$V2 == "vg_all",]$V2 = "Pangenome"
whatever[whatever$V2 == "vg_ref",]$V2 = "BATG-1.0"

aligned = ggplot(whatever[whatever$V3 == "aligned",], aes(x = V2, y = V4/1000000, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Millions of reads")+xlab("Reference")+ggtitle("Aligned reads")

paired = ggplot(whatever[whatever$V3 == "paired",], aes(x = V2, y = V4/1000000, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Millions of reads")+xlab("Reference")+ggtitle("Paired reads")

proper_pair = ggplot(whatever[whatever$V3 == "proper_pair",], aes(x = V2, y = V4/1000000, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Millions of reads")+xlab("Reference")+ggtitle("Properly paired reads")

softclips = ggplot(whatever[whatever$V3 == "softclips",], aes(x = V2, y = V4/1000000, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Mb softclipped sequence")+xlab("Reference")+ggtitle("Mb softclipped total")

alscore = ggplot(whatever[whatever$V3 == "alscore",], aes(x = V2, y = V4, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Alignment score")+xlab("Reference")+ggtitle("Mean alignment score")

mapq = ggplot(whatever[whatever$V3 == "mapq",], aes(x = V2, y = V4, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("MAPQ")+xlab("Reference")+ggtitle("Mean mapping quality")

subs = ggplot(whatever[whatever$V3 == "subs",], aes(x = V2, y = V4, group = V1, color = V1))+geom_point(size=3)+geom_line(aes(group=V1), lwd = 1)+theme_minimal()+
  theme(text=element_text(size = 14), legend.position = "none",   plot.margin = margin(1, 1, 1, 1, "cm"), plot.title = element_text(hjust=0.5))+ylab("Substitutions")+xlab("Reference")+ggtitle("Total substitutions")

plot = arrangeGrob(aligned, paired, proper_pair, softclips, alscore, mapq, subs, nrow = 3, ncol = 3, padding = unit(0, "cm"))

ggsave("PG_S3.png", plot, width = 300, height = 300, units = "mm", dpi = 600, bg = "white")
