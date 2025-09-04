rm(list=ls())
library(reshape2)
library(ggplot2)
library(gridExtra)
library(grid)

results = read.csv("C:/Users/dwo11kg/PG2_20_9_results.txt.F1", sep = "\t", header = F)
dim(results) #Ok...so at least the potein seqs and this agree with each other. 

#results = read.csv("C:/Users/dwo11kg/doink", sep = "\t", header = F)
head(results)
colnames(results) = c("Gene", "Type", "N_Gene", "N_NGene", "N_SV", "N_SV_Gene", "N_NSV_Gene", "N_SV_NGene", "N_NSV_NGene", "SV_Name", "F1")
head(results)
results = results[results$Type != "",]
head(results)
#split_results = split(results, results$Gene)

barplot(table(results$Type))
woof = table(results$Type)
bark = data.frame(c(woof[1], woof[2]+woof[3]+woof[4]+woof[5]))
par(mfrow = c(1,1))
barplot(bark$c.woof.1...woof.2....woof.3....woof.4....woof.5.., ylim = c(0,35000), col =c("#E69F00", "#56B4E9"))

barplot(c(woof[1], woof[5], woof[4], woof[3], woof[2]), col =c("#E69F00", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9"))
barplot(c(woof[1], woof[5], woof[4], woof[3], woof[2]), col =c("#E69F00", "#56B4E9", "#E69F00", "#56B4E9", "grey"))


sum(table(results$Type))
table(results$Type)[1]/sum(table(results$Type))

#data <- data.frame(
#  Category = c("AR", "AR", "AR", "NR_NSV", "NR_NSV", "NR_NSV"),
#  Subset = c("II", "IV", "E", "II", "IV", "E"),
#  Value = c(3, 5, 4, 2, 6, 3) 
#)
#So we have table(results$Type) for each one
#We then need subsets, I guess of i) included as invariant, 
#ii) included as variable, iii) excluded
#

#Which are we suspicious of? 
hist(results[results$Type == "NR_NSV",]$'N_Gene', breaks = 25, main = "NR_NSV (new gene - no SV overlap)", xlab = "Individuals where gene present") #again I think that's very encouraging: almost all are in just one or two individuals.

hist(results[results$Type == "NR_SV",]$'N_Gene', breaks = 25, main = "NR_SV (extra gene - SV overlap)", xlab = "Individuals where gene present") #So they are present in 50 individuals...
par(mfrow = c(2,1))
hist(results[results$Type == "NR_NSV",]$'N_Gene', breaks = 25, main = "NR_NSV (extra gene - no SV overlap)", xlab = "Individuals where gene present") #again I think that's very encouraging: almost all are in just one or two individuals.
hist(results[results$Type == "NR_SV",]$'N_Gene', breaks = 25, main = "NR_SV (extra gene - SV overlap)", xlab = "Individuals where gene present") #So they are present in 50 individuals...
par(mfrow = c(1,1))

hist(results[results$Type == "NR_SV",]$F1, breaks = 25, main = "NR_SV - F1", xlab = "(#Gene_SV)/(#Gene_SV + 0.5*NGene_SV + 0.5*Gene_NSV)") #So they are present in 50 individuals...


par(mfrow = c(2,2))
hist(results[results$Type == "R_NSV",]$N_NGene, breaks = 25, main = "R_NSV (missing ref gene - no SV overlap", xlab = "Individuals where ref gene is missing") #So they are present in 50 individuals...
hist(results[results$Type == "R_SV",]$N_NGene, breaks = 25, main = "R_Ref gene missing - SV overlap", xlab = "Individuals where ref gene is missing") #So they are present in 50 individuals...
par(mfrow = c(2,1))
hist(results[results$Type == "R_NSV",]$N_NGene, breaks = 25, main = "Missing ref gene - no SV overlap", xlab = "Individuals where ref gene is missing") #So they are present in 50 individuals...
hist(results[results$Type == "R_SV",]$N_NGene, breaks = 25, main = "Ref gene missing - SV overlap", xlab = "Individuals where ref gene is missing") #So they are present in 50 individuals...
par(mfrow = c(1,1))
hist(results[results$Type == "R_SV",]$F1, breaks = 25, main = "ref gene missing - F1", xlab = "(NGene_SV)/(NGene_SV+0.5*Gene_SV+0.5*NGene_SV)") #So they are present in 50 individuals...

#Ok Ok so what's going on here..

results_filter = results
dim(results)
dim(results_filter)

#Fig3 - the sum of all those that are present in every individual
AR_II1 = sum(results_filter$Type == "AR")

#X% were present in all individuals, including the reference

par(mfrow = c(2,2))


labelA <- textGrob("A", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

labelB <- textGrob("B", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

labelC <- textGrob("C", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

labelD <- textGrob("D", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))



# Create ggplot histograms
S2_A <- ggplot(results_filter[results_filter$Type == "NR_NSV", ], aes(x = N_Gene)) +
  geom_histogram(bins = 25) +
  labs(title = "", x = "Individuals with gene") +
  theme_minimal(base_size = 12)

S2_B <- ggplot(results_filter[results_filter$Type == "R_NSV", ], aes(x = N_NGene)) +
  geom_histogram(bins = 25) +
  labs(title = "", x = "Individuals missing gene") +
  theme_minimal(base_size = 12)

S2_C <- ggplot(results_filter[results_filter$Type == "NR_SV", ], aes(x = F1)) +
  geom_histogram(bins = 25) +
  labs(title = "", x = "F1 score") +
  theme_minimal(base_size = 12)

S2_D <- ggplot(results_filter[results_filter$Type == "R_SV", ], aes(x = F1)) +
  geom_histogram(bins = 25) +
  labs(title = "", x = "F1 score") +
  theme_minimal(base_size = 12)



# Arrange the plots with labels
PG2_S2 <- grid.arrange(
  arrangeGrob(S2_A, top = labelA),
  arrangeGrob(S2_B, top = labelB),
  arrangeGrob(S2_C, top = labelC),
  arrangeGrob(S2_D, top = labelD),
  nrow = 2, ncol = 2
)

ggsave("PG_S2.png", PG2_S2, width = 200, height = 150, units = "mm", dpi = 600, bg = "white")



#"31,117...were present in all individuals including the reference"
table(results_filter$Type)
#...65.6%...
table(results_filter$Type)[1]/dim(results_filter)[1]

sum(table(results_filter$Type)[c(2,3,4,5)])
barplot(table(results_filter$Type))

#"Of the 9,449 genes absent in the reference genome" (sum of NR_SV and NR_NSV)
sum(table(results_filter$Type)[c(2,3)])

#"5,615 did not overlap with an SV in any individual" (NR_NSV)
sum(table(results_filter$Type)[c(2)])

#Fig3 - all the NR_NSV are excluded
NR_NSV_E1 = sum(results_filter$Type == "NR_NSV")
NR_NSV_E1

#Excluded: i) All NR_NSV genes
excluded_genes = results_filter[results_filter$Type == "NR_NSV",]
dim(excluded_genes) #So 5k

#But surely these should be...R_NSV? (as in they are variable, present in the ref, but no SV?)
#results_filter[results_filter$Type == "NR_NSV",]$Type <- "AR" #I think this is wrong

table(results_filter$Type)

dim(results_filter)

#Those not overlapping with an SV were removed...
results_filter = results_filter[!(results_filter$Type == "NR_NSV"),]
dim(results_filter) #41,327 genes

hist(results[results$Type == "NR_SV",]$'N_Gene', breaks = 25, main = "NR_SV (extra gene - SV overlap)", xlab = "Individuals where gene present") #So they are present in 50 individuals...

#Add to the xclude genes: those overlapping with an SV, but with F1 < 0.8

#Excluded: i) NR_NSV genes and then ii) NR_SV genes with F1 < 0.8
excluded_genes = rbind(excluded_genes, results_filter[results_filter$Type == "NR_SV" & results_filter$F1 < 0.8,])
#Fig3 - for NR_SV, those with F1 < 0.8 are excluded
NR_SV_E1 = sum(results_filter$Type == "NR_SV" & results_filter$F1 < 0.8)
NR_SV_E1 

#Fig3 - for NR_SV, those wih F1 >= 0.8 are included
NR_SV_IV1 = sum(results_filter$Type == "NR_SV" & results_filter$F1 >= 0.8)
#...only 1,240 did so with an F1 score of 0.8 or above
NR_SV_IV1

dim(excluded_genes)

dim(results_filter) #41,327
#Excluding those that don't consistently overlap with an SV
results_filter = results_filter[!(results_filter$Type == "NR_SV" & results_filter$F1 < 0.8),]
dim(results_filter) #38,733

#FILTERING THE GENES PRESENT IN THE REFERENCE GENOME, BUT ABSENT IN THE SAMPLES
table(results_filter$Type) #3469
#oF THE 6,376 genes present in the reference but absent in at least one or more of the other individuals
sum(table(results_filter$Type)[c(3,4)])
#2,907 did not overlap with an SV in any individual
table(results_filter$Type) #3469/

dim(excluded_genes) 
##Excluded: i) NR_NSV genes and then ii) NR_SV genes with F1 < 0.8, ii) R_NSV genes

#Fig3 - R_SV - those with F1 < 0.8 are set as invariant
R_SV_II1 = sum(results_filter$Type == "R_SV" & results_filter$F1 < 0.8)
#Fig3 - those with F1 >= 0.8 are set as variable
R_SV_IV1 = sum(results_filter$Type == "R_SV" & results_filter$F1 >= 0.8)

R_SV_II1
#"For those that did overlap with an SV, Only 1,825 did with an F1 score of 0.8 or above"
R_SV_IV1

R_NSV_II1 = sum(results_filter$Type == "R_NSV")
results_filter[results_filter$Type == "R_NSV",]$Type <- "AR"

table(results_filter$Type) #3469

dim(results_filter[results_filter$Type == "R_SV" & results_filter$F1 < 0.8,])

dim(excluded_genes) #So 5k
##Excluded: i) NR_NSV genes and then ii) NR_SV genes with F1 < 0.8, ii) R_NSV genes and iv) R_SV genes with F1 < 0.8

results_filter[results_filter$Type == "R_SV" & results_filter$F1 < 0.8,]$Type = "AR"
table(results_filter$Type) #2768

length(results_filter$Type)
table(results_filter$Type)
sum(table(results_filter$Type)) #"This brought the total number of pangenome genes as 44,348" 

sum(table(results_filter$Type)[c(2,3)]) #"of which 2,940 were variable"
sum(table(results_filter$Type)[c(2,3)])/length(results_filter$Type) #(6.6% of the total)
barplot(table(results_filter$Type))

par(mfrow = c(1,2))
barplot(table(results$Type))
sum(table(results$Type))
table(results$Type)[1]/sum(table(results$Type))
1-table(results$Type)[1]/sum(table(results$Type))

#So we are now making a data frame describing for each of the original sets of genes:
#AR - all samples, and the reference
#R_SV - in the reference, absent in some samples, overlaps an SV
#R_NSV - in the reference, absent in some samples, no SV overlap
#NR_SV  - absent in the reference, present in some samples, SV overlap
#NR_NSV - absent in the reference, present in some samples, no SV overlap

#data <- data.frame(
#  Category = c("AR", "AR", "AR", "NR_NSV", "NR_NSV", "NR_NSV"),
#  Subset = c("II", "IV", "E", "II", "IV", "E"),
#  Value = c(3, 5, 4, 2, 6, 3) 
#)
#So we have table(results$Type) for each one
#We then need subsets, I guess of i) included as invariant, 
#ii) included as variable, iii) excluded

AR_row = c(AR_II1,0,0) #This is the sites that are present in all individuals, so this goes in column 1
NR_NSV_row = c(0,0,NR_NSV_E1) #All the NR_NSV genes are excluded, so go in col 3
NR_SV_row = c(0, NR_SV_IV1, NR_SV_E1)
R_NSV_row =c(R_NSV_II1, 0, 0) 
R_SV_row = c(R_SV_II1,R_SV_IV1,0)
summary_frame = t(data.frame(R = AR_row, R_SV = R_SV_row, R_NSV = R_NSV_row, NR_SV = NR_SV_row, NR_NSV = NR_NSV_row))
colnames(summary_frame) = c("II", "IV", "E")
summary_frame = melt(summary_frame)

summary_frame$Initial = "Variable"
summary_frame[summary_frame$Var1 == "R" & summary_frame$Var2 == "II",]$Initial = "Invariant"
summary_frame

summary_frame

labelB <- textGrob("B", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

#labelC <- textGrob("C", x = 0.05, y = 0.3, hjust = 0, vjust = 1, 
 #                  gp = gpar(fontface = "bold", fontsize = 20))




cbPalette <- c("#E69F00", "#56B4E9", gray(0.5), "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
label_colours = c("#E69F00","#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9") 
PG_Figure3B = ggplot(as.data.frame(summary_frame), aes(x = Var1, y = value, fill = Var2)) +
  geom_bar(stat = "identity") +
  labs(y = "Number of genes", x = "Gene category") +
  theme_minimal(base_size = 8)+scale_fill_manual(values=cbPalette)+scale_x_discrete(labels = c("R" = "1", "R_SV" = "2", "R_NSV" = "3", "NR_SV" = "4", "NR_NSV" = "5")) +

  theme(axis.text.x = element_text(face = "bold", size = 12),
        legend.position = "none")

PG_Figure3B

#PG2_3B <- grid.arrange(arrangeGrob(PG_Figure3B, top = labelB))
PG2_3B = PG_Figure3B

save(PG2_3B, file = "~/PG_3B.RData")




summary_frame
cbPalette <- c("#E69F00", "#56B4E9")
label_colours = c("#E69F00","#56B4E9") 
PG_Figure3B = ggplot(as.data.frame(summary_frame), aes(x = Var1, y = value, fill = Initial)) +
  geom_bar(stat = "identity") +
  labs(y = "Number of genes", x = "") +
  theme_minimal(base_size = 15)+scale_fill_manual(values=cbPalette)+scale_x_discrete(labels = c("R" = "1", "R_SV" = "2", "R_NSV" = "3", "NR_SV" = "4", "NR_NSV" = "5")) +
  
  theme(axis.text.x = element_text(face = "bold", size = 20),
        legend.position = "none")

PG_Figure3B
PG2_3B <- grid.arrange(arrangeGrob(PG_Figure3B, top = labelB))



color_map = readRDS("~/PG2_color_map.rds")

#So this doesn't look right - why are there so many NR_NSV genes? 

#Ok so something like this.
#Need to check these numbers are all correct...

par(mfrow = c(2,1))
hist(results_filter[results_filter$Type == "R_SV",]$N_NGene, main = "Filtered - R_SV (ref genes missing, SV overlap)", xlab = "Individuals in which gene is missing", breaks = 50)
hist(results_filter[results_filter$Type == "NR_SV",]$N_Gene, main = "Filtered - NR_SV (extra genes, SV overlap)", xlab = "Individuals in which gene is present", breaks = 50)
#hist(results_filter[results_filter$Type == "R_SV",]$N_withSV/(results_filter[results_filter$Type == "R_SV",]$N_withSV+results_filter[results_filter$Type == "R_SV",]$N_withoutSV), breaks = 25, main = "ref gene missing - N(SV + no_gene)/N(SV)", xlab = "(Individuals with no gene + SV)/(Individuals with SV)") #So they are present in 50 individuals...
#hist(results_filter[results_filter$Type == "R_SV",]$N_withSV/(results_filter[results_filter$Type == "R_SV",]$N_withSV+results_filter[results_filter$Type == "R_SV",]$N_withoutSV), breaks = 25, main = "ref gene missing - N(SV + no_gene)/N(SV)", xlab = "(Individuals with no gene + SV)/(Individuals with SV)") #So they are present in 50 individuals...

#Most SVs are associated with 1 gene - a few are associated with more than 1. 
write.table(results_filter, "C:/Users/dwo11kg/PG2_20_9_results.txt.F1.filtered", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(excluded_genes, "C:/Users/dwo11kg/PG2_20_9_results.txt.excluded", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
#Ok so there you go.

dim(results_filter)
dim(excluded_genes)

#Ok...so the excluded genes are the genes that would have been classified as variable, but aren't? 
#I'm not 100% sure that is right though...is it? Or is it. I thought included was just the final set of genes? 
#So...excluded is too big here then. It should just be for grey stuff, right? 


