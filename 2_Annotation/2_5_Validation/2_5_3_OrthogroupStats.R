rm(list=ls())
#Orthogroups
groups = read.csv("C:/Users/dwo11kg/Orthogroups.GeneCounts.PG2_4_5.8.May30.tsv", sep = "\t", header = T)
head(groups)
head(groups$LR_SR.PG2_4_4_10.2.results.longest.bed.aa)
sum(groups$LR_SR.PG2_4_4_10.2.results.longest.bed.aa)

nrow(groups[groups$LR_SR.PG2_4_4_10.2.results.longest.bed.aa == groups$Total,])
#168 BATG-1.0 genes assigned orthogroups only within that assembly
dim(groups[groups$Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3.pep == groups$Total,])
#338 BATG-0.5 genes assigned orthogroups only within that assembly

batg0.5_num = 38949
batg1.0_num = 38276

#Total with Orthogroups assigned, minus those that only have orthogroups assigned within the assembly
batg0.5_outside = sum(groups$Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3.pep)-nrow(groups[groups$Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3.pep == groups$Total,])
1-batg0.5_outside/batg0.5_num #7.3%

batg1.0_outside = sum(groups$LR_SR.PG2_4_4_10.2.results.longest.bed.aa)-nrow(groups[groups$LR_SR.PG2_4_4_10.2.results.longest.bed.aa == groups$Total,])
1-batg1.0_outside/batg1.0_num #4.8%
