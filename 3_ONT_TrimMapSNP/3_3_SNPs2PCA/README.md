# 3_3 - Calls SNPs from ONT reads mapped to BATG-1.0, produces a PCA from these
#### NC_3_3_1_clair3.sh - calls SNPs from individual bams using Clair3
#### NC_3_3_2_indfilter.sh - filters Clair3 SNP calls on the individuals by depth
#### NC_3_3_3_chunk.sh - reheaders and chunks individual vcf files (10Mb chunks) prior to merging
#### NC_3_3_4_merge.sh - merges Clair3 vcfs across individuals using glnexus, then filters: removes the ONT sample of the BATG-1.0 individual
##### NC_3_3_5_dp.sh - gets mapped depth for each bam file
##### NC_3_3_6_rmref.sh - removes SNPS from the BATG-1.0 individual (DW-S26)
##### NC_3_3_7_plink_pca.sh - gets the PCA from plink
##### NC_3_3_8_plotPCA.R - plots PCA in R
###### mergeClair3.yml - yml used for merging with glnexus
