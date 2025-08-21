rm(list=ls())
library("tidyverse")
library("ggplot2")
library(grid)
library(gridExtra)


#Order in this file should be the same as in the PCA, so important to keep the order of this one
names = read.csv("C:/Users/dwo11kg/filtered_reads_PG2_5_2.txt_nomandshurica.names.noref", sep = "\t", header = F)
head(names)
names$V1 <- sub("DW-", "", names$V1)
names$V1 <- sub("DW_", "", names$V1)
names
names$V1 <- sub("_[^_]*$", "", names$V1)
names$V1 <- sub("_[^_]*$", "", names$V1) #needed twice

locations = read.csv("C:/Users/dwo11kg/Documents/PG_TableX1_forR.txt", sep = "\t", header = T)
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

pca <- read_table("C:/Users/dwo11kg/PG2_22_2.combined.PG2_22_2.noref.filt2.vcf.LD.eigenvec", col_names = TRUE)
eigenval <- scan("C:/Users/dwo11kg/PG2_22_2.combined.PG2_22_2.noref.filt2.vcf.LD.eigenval")

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


PC1_2 = ggplot(pca_wnames, aes(x = PC1, y = PC2, color = V2))+geom_point(size = 4)+theme_minimal(base_size = 12)+
xlab(paste("PC1 - ", 100*round(prop_explained[1],4), "% variance explained", sep = ""))+
ylab(paste("PC2 - ", 100*round(prop_explained[2],4), "% variance explained" , sep = ""))+
  scale_color_manual(values = color_map)+
theme(axis.title= element_text(size = 14))+guides(color = "none")

PC1_2

labelB <- textGrob("B", x = 0.05, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

#Figure 1BPCA
PG2_Plot1B = grid.arrange(arrangeGrob(PC1_2, top = labelB), nrow = 1, ncol = 1)
save(PG2_Plot1B, file = "~/PG2_Plot1B.RData")
