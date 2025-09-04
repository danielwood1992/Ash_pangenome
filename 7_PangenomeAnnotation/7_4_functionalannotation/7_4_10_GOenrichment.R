rm(list=ls())

library(grid)
library(gridExtra)
library(ggplot2)
library(reshape2)
library("topGO")


#### 1- Annotation success of included vs. excluded pangenome genes
annotation = read.csv("C:/Users/dwo11kg/PG2_26_5_results.txt", sep = " ", header = T)

annotation = annotation[c(3,5,7),]
annotation$File <- gsub("eggnog_pc", "eggNOG", annotation$File)
annotation$File <- gsub("interpro_pc", "InterPro", annotation$File)
annotation$File <- gsub("uniprot_pc", "UniProt", annotation$File)

cbPalette_1 <- c("black", gray(0.5), "#56B4E9",  "#E69F00")

annotation = melt(annotation)
plot_4A = ggplot(annotation, aes(x = File, y = value*100, fill = variable))+geom_bar(stat= "identity", position = position_dodge())+
  scale_fill_manual(values = cbPalette_1)+xlab("Database")+ylab("% genes with annotation")+theme_minimal(base_size = 12)+theme(legend.position = "None", axis.title = element_text(size = 14))
plot_4A


labelA <- textGrob("A", x = 0.025, y = 0.7, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG2_Plot4A = grid.arrange(arrangeGrob(plot_4A, top = labelA), nrow = 1, ncol = 1)
save(PG2_Plot4A, file = "~/PG2_Plot4A.RData")

##### 2 - GO enrichment

### i) enrichment of dispensible genes, against a background of all included genes (i.e. variiable + nonvariable)

gene_universe = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.V_NV", sep = "\t", header = F) #this is not the right list...
dim(gene_universe)
gene_universe = gene_universe[gene_universe$V2 != "-",]
dim(gene_universe)

genes_of_interest = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.V", sep = "\t", header = F)
head(genes_of_interest)
genes_of_interest = genes_of_interest[,1]
length(genes_of_interest)

genes_of_interest = genes_of_interest[genes_of_interest %in% gene_universe$V1]
length(genes_of_interest)
#SO it's 3,307
dim(gene_universe)

colnames(gene_universe) <- c("Gene", "GO_terms")
geneID2GO <- strsplit(gene_universe$GO_terms, ",")
names(geneID2GO) <- gene_universe$Gene
names(geneID2GO)

geneList <- factor(as.integer(names(geneID2GO) %in% genes_of_interest))
names(geneList) <- names(geneID2GO)
levels(geneList)

GOdata <- new("topGOdata",
              ontology = "BP",  # Choose "BP", "MF", or "CC" depending on your focus
              allGenes = geneList,
              annot = annFUN.gene2GO,
              gene2GO = geneID2GO,
              nodeSize = 10)  # You can adjust the node size as needed

resultFisher = runTest(GOdata, statistic = "fisher")

allGO = usedGO(object = GOdata)
results = GenTable(GOdata, classicFisher = resultFisher, topNodes = length(allGO))
head(results)

#GO:0006950 - response to stress
results[grepl("GO:0006950", results[,1]), ]
#GO:0006952 - defense
#GO:0032502 - development 

results$adjusted = as.numeric(results$classicFisher)*dim(results)[1]
results[results$adjusted < 0.05,]

V_NV_sig = results[results$adjusted < 0.05,]$GO.ID
V_NV_sig


write.csv(results, "C:/Users/dwo11kg/results_PG2_26_GOenrichment.csv")

sig_results = results[results$adjusted < 0.05,]

#exploring results

#So it's basically transposition, and meristem growth. Weird. Defense? 
defense = results[grepl("defense", results[,2]), ]
defense #With adjusting for multiple testing, no defense responses significant. 

auxin = results[grepl("auxin", results[,2]), ]
auxin #With adjusting for multiple testing, no defense responses significant. 


### ii) enrichment of genes included in the pangenome, against a background of incuded vs. excluded
#
gene_universe_all = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.I_NI", sep = "\t", header = F) #this is not the right list...
gene_universe_all = gene_universe_all[gene_universe_all$V2 != "-",]

dim(gene_universe)[1]

genes_of_interest_not_included = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.NI", sep = "\t", header = F)
genes_of_interest_not_included = genes_of_interest_not_included[,1]
length(genes_of_interest_not_included)
genes_of_interest_not_included = genes_of_interest_not_included[genes_of_interest_not_included %in% gene_universe_all$V1]
length(genes_of_interest_not_included)
dim(gene_universe_all)

head(gene_universe_all)

colnames(gene_universe_all) <- c("Gene", "GO_terms")
geneID2GO_not_included <- strsplit(gene_universe_all$GO_terms, ",")
names(geneID2GO_not_included) <- gene_universe_all$Gene
names(geneID2GO_not_included)

geneList_not_included <- factor(as.integer(names(geneID2GO_not_included) %in% genes_of_interest_not_included))
names(geneList_not_included) <- names(geneID2GO_not_included)
levels(geneList_not_included)
table(geneList_not_included)


GOdata_not_included <- new("topGOdata",
              ontology = "BP",  # Choose "BP", "MF", or "CC" depending on your focus
              allGenes = geneList_not_included,
              annot = annFUN.gene2GO,
              gene2GO = geneID2GO_not_included,
              nodeSize = 10)  # You can adjust the node size as needed

resultFisher_not_included = runTest(GOdata_not_included, statistic = "fisher")


allGO_not_included = usedGO(object = GOdata_not_included)
results_not_included = GenTable(GOdata_not_included, classicFisher = resultFisher_not_included, topNodes = length(allGO_not_included))

head(results_not_included)

dim(results_not_included)[1]
dim(results)[1]

results_not_included$adjusted = as.numeric(results_not_included$classicFisher)*dim(results_not_included)[1]
results_not_included
results_not_included[results_not_included$adjusted < 0.05,]

write.csv(results_not_included, "C:/Users/dwo11kg/results_not_included_PG2_26_GOenrichment.csv")


NI_I_sig = results_not_included[results_not_included$adjusted < 0.05,]$GO.ID

sig_results_not_included = results_not_included[results_not_included$adjusted < 0.05,]

results_not_included[results_not_included$adjusted < 0.05,]

#So it's basically transposition, and meristem growth. Weird. Defense? 
defense_not_included = results_not_included[grepl("defense", results_not_included[,2]), ]
defense_not_included #With adjusting for multiple testing, no defense responses significant. 


#iii) enrichment of included and variable vs. included and variable + not included (the latter of which would also be classified as variable under a naive approach)

gene_universe_potentially_variable = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.NI_V", sep = "\t", header = F) 
gene_universe_potentially_variable = gene_universe_potentially_variable[gene_universe_potentially_variable$V2 != "-",]

genes_of_interest_truly_variable = read.csv("C:/Users/dwo11kg/PG2_26_4_eggnog.emapper.annotations.list.V", sep = "\t", header = F)
genes_of_interest_truly_variable = genes_of_interest_truly_variable[,1]

#genes_of_interest_truly_variable = genes_of_interest_truly_variable[genes_of_interest_truly_variable %in% gene_universe_potentially_variable$V1]

length(genes_of_interest_truly_variable)
dim(gene_universe_potentially_variable)

head(gene_universe_potentially_variable)

colnames(gene_universe_potentially_variable) <- c("Gene", "GO_terms")
geneID2GO_truly_variable <- strsplit(gene_universe_potentially_variable$GO_terms, ",")
names(geneID2GO_truly_variable) <- gene_universe_potentially_variable$Gene
names(geneID2GO_truly_variable)

geneList_truly_variable <- factor(as.integer(names(geneID2GO_truly_variable) %in% genes_of_interest_truly_variable))
names(geneList_truly_variable) <- names(geneID2GO_truly_variable)
levels(geneList_truly_variable)
table(geneList_truly_variable)


GOdata_truly_variable <- new("topGOdata",
                       ontology = "BP",  # Choose "BP", "MF", or "CC" depending on your focus
                       allGenes = geneList_truly_variable,
                       annot = annFUN.gene2GO,
                       gene2GO = geneID2GO_truly_variable,
                       nodeSize = 10)  # You can adjust the node size as needed

#resultFisher_truly_variable = runTest(GOdata_truly_variable, algorithm = "classic", statistic = "fisher")
resultFisher_truly_variable = runTest(GOdata_truly_variable, statistic = "fisher")


#Comparing the GO enrichment of the putatively variable genes against i) truly variable genes and ii) all genes

allGO_truly_variable = usedGO(object = GOdata_truly_variable)
results_truly_variable = GenTable(GOdata_truly_variable, classicFisher = resultFisher_truly_variable, topNodes = length(allGO_truly_variable))
dim(results_truly_variable)[1]
#dim(results)[1]


results_truly_variable$adjusted = as.numeric(results_truly_variable$classicFisher)*dim(results_truly_variable)[1]
results_truly_variable
results_truly_variable$ratio = results_truly_variable$Significant/results_truly_variable$Expected
results_truly_variable$log10 = -log10(results_truly_variable$adjusted)

head(results_truly_variable)
results_truly_variable$colour = "black"
head(results_truly_variable)

results_truly_variable$colour <- ifelse(results_truly_variable$GO.ID %in% NI_I_sig & results_truly_variable$GO.ID %in% V_NV_sig, "both",
                     ifelse(results_truly_variable$GO.ID %in% NI_I_sig, "NI_I_only",
                            ifelse(results_truly_variable$GO.ID %in% V_NV_sig, "V_NV_only", "neither")))

head(results_truly_variable)
table(results_truly_variable$colour)

results_truly_variable_layer1 = results_truly_variable[results_truly_variable$colour == "neither",]
results_truly_variable_layer2 = results_truly_variable[results_truly_variable$colour != "neither",]


library(ggplot2)
cbPalette_2 <- c("#E69F00", "#56B4E9", gray(0.5), "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
palette_1 = cbPalette_2[3]
palette_2 = cbPalette_2[c(4,2,3,7)]
palette_2

plot_4B = ggplot() +  theme_minimal(base_size = 12)+theme(legend.position = "none")+
  geom_point(data = results_truly_variable_layer1, size = 4,
             aes(x = ratio, y = log10, colour = factor(colour))) +

  geom_point(data = results_truly_variable_layer2, size = 4,
             aes(x = ratio, y = log10, colour = factor(colour))) +
  scale_colour_manual(values = palette_2) +
  
    geom_hline(yintercept = -log10(0.05), color = "red", linetype = "dashed", size = 1)+xlab("Observed/Expected ratio")+ylab(expression(-log[10](pvalue)))
   # White panel with black border

plot_4B

library(grid)
library(gridExtra)

labelB <- textGrob("B", x = 0.025, y = 0.4, hjust = 0, vjust = 1, 
                   gp = gpar(fontface = "bold", fontsize = 20))

PG2_Plot4B = grid.arrange(arrangeGrob(plot_4B, top = labelB), nrow = 1, ncol = 1)
save(PG2_Plot4B, file = "~/PG2_Plot4B.RData")

#So that's the ratio of observed/expected, and the p-value? 

write.csv(results_truly_variable, "C:/Users/dwo11kg/results_truly_variable_PG2_26_GOenrichment.csv")

#So it's basically transposition, and meristem growth. Weird. Defense? 
defense_truly_variable = results_truly_variable[grepl("defense", results_truly_variable[,2]), ]
defense_truly_variable #With adjusting for multiple testing, no defense responses significant. 

auxin_truly_variable = results_truly_variable[grepl("auxin", results_truly_variable[,2]), ]
auxin_truly_variable #With adjusting for multiple testing, no defense responses significant. 

floral_meristem_truly = results_truly_variable[grepl("floral meristem growth", results_truly_variable[,2]), ]
floral_meristem_truly #With adjusting for multiple testing, no defense responses significant. 
