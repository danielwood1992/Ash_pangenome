# 3_3 - Calls SNPs from ONT reads mapped to BATG-1.0, produces a PCA from these
#### 3_3_1_clair3.sh - calls SNPs from individual bams using Clair3
#### 3_3_2_indfilter.sh - filters Clair3 SNP calls on the individuals by depth
#### 3_3_3_merge.sh - merges Clair3 vcfs across individuals, then filters: removes the ONT sample of the BATG-1.0 individual
#### 3_3_4_plink_pca.sh - extracts unlinked SNPs from filtered vcf file; runs a PCA on this
#### 3_3_5_plotPCA.R - R script that plots the first 2 PCs, along with labels and country of origin
