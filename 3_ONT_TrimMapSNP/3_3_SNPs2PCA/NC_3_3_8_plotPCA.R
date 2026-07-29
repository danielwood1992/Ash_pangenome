#PG_misc
#install.packages("tidyverse")
#Note: to get this to work, had to do sudo apt-get install libssl-dev
rm(list=ls())
library("tidyverse")
library("ggplot2")
library(grid)
library(gridExtra)
source("C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/theme_nature.R")

#Order in this file should be the same as in the PCA, so important to keep the order of this one
names = read.csv("C:/Users/dwo11kg/filtered_reads_PG2_5_2.txt_nomandshurica.names.noref", sep = "\t", header = F)
head(names)
names$V1 <- sub("DW-", "", names$V1)
names$V1 <- sub("DW_", "", names$V1)
names
names$V1 <- sub("_[^_]*$", "", names$V1)
names$V1 <- sub("_[^_]*$", "", names$V1) #needed twice

names

#names = read.csv("C:/Users/dwo11kg/test_rest_names.phenotypes", sep ="\t", header = F)
#head(names)

locations = read.csv("C:/Users/dwo11kg/PG_TableX1_forR.txt", sep = "\t", header = T)
locations$Provenance = sub(".*?, ", "", locations$Provenance)
colnames(locations) = c("V1", "V2")
locations$V1 <- sub("DW-", "", locations$V1)
locations$V1 <- sub("DW_", "", locations$V1)
locations
locations$V1 <- sub("_[^_]*$", "", locations$V1)
locations$V1 <- sub(".*_", "", locations$V1)
locations

names2 <- merge(names, locations, by = "V1", sort = FALSE)
names = names2

pca <- read_table("C:/Users/dwo11kg/NC_clair3_combined.noref.bcf.LD.eigenvec", col_names = TRUE)
eigenval <- scan("C:/Users/dwo11kg/NC_clair3_combined.noref.bcf.LD.eigenval")

#Old
##pca <- read_table("C:/Users/dwo11kg/PG2_22_2.combined.PG2_22_2.noref.filt2.vcf.LD.eigenvec", col_names = TRUE)
#eigenval <- scan("C:/Users/dwo11kg/PG2_22_2.combined.PG2_22_2.noref.filt2.vcf.LD.eigenval")


#pca <- read_table("C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PG2_25_5.1.SVs.tags.vcf.sigsites.LD.eigenvec", col_names = TRUE)
#eigenval <- scan("C:/Users/dwo11kg/test_set_individuals.txt.PG2_25_1.txt.rest.PG2_25_5.1.SVs.tags.vcf.sigsites.LD.eigenval")


prop_explained = eigenval/sum(eigenval)
prop_explained
dim(eigenval)

head(names)

pca_wnames = cbind(names, pca)
head(pca_wnames)

countries = unique(pca_wnames$V2)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC")

color_map = setNames(safe_colorblind_palette, countries)
color_map
saveRDS(color_map, "~/PG2_color_map.rds")

pca_wnames
#write.csv(pca_wnames, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/Fig1B.1.csv")




PC1_2 = ggplot(pca_wnames, aes(x = PC1, y = PC2, color = V2))+geom_point(size = 4)+theme_minimal(base_size = 12)+
xlab(paste("PC1 - ", 100*round(prop_explained[1],4), "% variance explained", sep = ""))+
ylab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance explained" , sep = ""))+
  scale_color_manual(values = color_map)+
theme(axis.title= element_text(size = 14))+guides(color = "none")

windowsFonts(Arial = windowsFont("Arial"))
PC1_2 <- ggplot(pca_wnames, aes(x = PC1, y = PC2, colour = V2)) +
  geom_point(size = 1.2) +
  xlab(paste("PC1 - ", 100 * round(prop_explained[1], 3), "% variance explained", sep = "")) +
  ylab(paste("PC2 - ", 100 * round(prop_explained[2], 3), "% variance explained", sep = "")) +
  scale_colour_manual(values = color_map) +
  theme_minimal(base_size = 7) +
  theme(
    axis.title = element_text(size = 7, family = "Arial", color = "black"),
    axis.text = element_text(size = 6, family = "Arial", color = "black"),
    legend.text = element_text(size = 7, family = "Arial"),
    legend.title = element_text(size = 7, family = "Arial")
  ) +
  guides(colour = "none")

PC1_2

#Hmmm..S34 and S28? That doesn't seem to fit...with 2 weird samples? 

PC1_2

labelB <- textGrob("b", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 7))


PC3_4 = ggplot(pca_wnames, aes(x = PC3, y = PC4, color = V2))+geom_point(size = 4)+theme_minimal(base_size = 12)+
  xlab(paste("PC1 - ", 100*round(prop_explained[1],4), "% variance explained", sep = ""))+
  ylab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance explained" , sep = ""))+
  scale_color_manual(values = color_map)+
  theme(axis.title= element_text(size = 14))+guides(color = "none")



#Figure 1BPCA
PG2_Plot1B = grid.arrange(arrangeGrob(PC1_2, top = labelB), nrow = 1, ncol = 1)
save(PG2_Plot1B, file = "~/PG2_Plot1B.RData")


PC1_2 = ggplot(pca_wnames, aes(x = PC1, y = PC2, label = V1, color = V2))+geom_point()+geom_text(hjust = 1, vjust = 1)+
xlab(paste("PC1 - ", 100*round(prop_explained[1],4), "% variance" ))+
ylab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance" ))+
theme(text= element_text(size = 21))
PC1_2


PC3_4 = ggplot(pca_wnames, aes(x = PC3, y = PC4, label = V1, color = V2))+geom_point()+geom_text(hjust = 1, vjust = 1)+
  xlab(paste("PC3 - ", 100*round(prop_explained[1],4), "% variance" ))+
  ylab(paste("PC4 - ", 100*round(prop_explained[2],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC3_4

PC1_2


PC1_2 = ggplot(pca_wnames, aes(x = PC1, y = PC2, color = V2))+geom_point(size = 10)+
  xlab(paste("PC1 - ", 100*round(prop_explained[1],4), "% variance" ))+
  ylab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC1_2

PC3_4 = ggplot(pca_wnames, aes(x = PC3, y = PC4, color = V2))+geom_point(size = 10)+
  xlab(paste("PC1 - ", 100*round(prop_explained[3],4), "% variance" ))+
  ylab(paste("PC2 - ", 100*round(prop_explained[4],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC3_4

PC5_6 = ggplot(pca_wnames, aes(x = PC5, y = PC6, color = V2))+geom_point(size = 10)+
  xlab(paste("PC1 - ", 100*round(prop_explained[5],4), "% variance" ))+
  ylab(paste("PC2 - ", 100*round(prop_explained[6],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC5_6



#


#I guess it's possible it's going to have a lot more reference calls than everything else: potentially that should be excluded...
PC2_3 = ggplot(pca_wnames, aes(x = PC2, y = PC3, label = V1))+geom_point()+geom_text(hjust = 1, vjust = 1)+
  xlab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance" ))+
  ylab(paste("PC3 - ", 100*round(prop_explained[3],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC2_3

PC2_4 = ggplot(pca_wnames, aes(x = PC2, y = PC4, label = V1))+geom_point()+geom_text(hjust = 1, vjust = 1)+
  xlab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance" ))+
  ylab(paste("PC4 - ", 100*round(prop_explained[4],4), "% variance" ))+
  theme(text= element_text(size = 21))

PC2_4

#Those that jump out are i) Mircze and ii) Bois

