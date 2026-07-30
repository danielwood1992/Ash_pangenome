### 5_CharacteriseSVs - explores frequencies of SV types, generates/plots saturation curves 
#### NC_5_1_totalbp.sh - produces summary output files, for each of the minimum number of samples an SV is present in, detailing i) the total bp covered by each SV type, and ii) the total number of SVs. Note that the final vcf for use in pangenome construction is produced here: complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf with minum number of samples = 3
##### sub_5_1_lengths.pl - subfunction that calculates the total length for each SV type, for a given MAF
#### NC_5_2_satcurves.sh - from the final vcf, generates satuation curves: removes one individual at a time and calculates how many SVs remain
#### NC_5_3_SVplots.R - plots the outputs from 5_1 and 5_2
#### NC_5_4_SVRepeatOverlap.sh - identifies overlap of SVs and repeats
#### NC_5_4.1_PlotRepeatOverlaps.R - plots repeat type overlaps (Figure S8)
#### NC_5_5_repeat_gene_SV.sh - produces summaries of numbers of features per megabase
#### NC_5_5.1_CircosPlot.R - plots Circos plot of SVs, genes, repeats etc. (Figure 2D)
