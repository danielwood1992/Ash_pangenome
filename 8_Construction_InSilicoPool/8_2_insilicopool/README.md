#### 8_2 - construction of an in silico pool of individuals
### 8_2_1_pickfiles.sh - based on file size, picks 21 sick and 21 healthy individuals from the 150 individuals sequenced in Stocks et al. Subsamples these down to produce a file equivalent to the Stocks et al. 2019 poolseq files using seqkit.
### 8_2_2_map.sh - maps the individual files to the pangenome using vg giraffe
### 8_2_3_map_refonly.sh - the same, but mapping to the BATG-1.0 only pangenome
### 8_2_4_PGvRefOnly_stats.sh - calculates stats for mapping quality etc, comparing the pangenome to the BATG-1.0 only data structure
### 8_2_4_PGvRefOnly_stats.sh -extracts mapping statistics from mapping to the pangenome vs. BATG-1.0
### 8_2_5_plotstats.R - plots these stats in R
### 8_2_6_SVCall.sh - generates a .pack file using vg pack, then calls SVs using vg call 
### 8_2_7_surject.sh - surjects the gam file: projects the co-ordinates back into the BATG-1.0 co-ordinate system. Then uses samtools to filter, removing alignments with MAPQ < 20.
### 8_2_8.1_SNPCallInd.sh - calls SNPS from the individual files. Note this uses the files not filtered for mapq for some stupid reason
### 8_2_8.2_PoolCall.sh - calls SNPs from the pool file
### 8_2_9.1_indSVStats.sh - gets some SV stats from individually called files. Uses the below subfunction
### 8_2_9.2_indSNPstats.sh - same but for the individual SNP files
#### sub_8_2_9.1_getinfo.pl - perl subfunction that retrieves info from vcfs. Should have just used bcftools query
### 8_2_10_ADplot.R - plots the SNP/SV information for one particular individaul 
### 8_2_11.1_mergeSVs.sh - merges the individually called SVs
### 8_2_11.2_mergeSNPs.sh - merges the individually called SNPs
### 8_2_12_filtermerged.sh - filters the merged SNPs based on missingness, MAF etc. Subsets the SNPs down to get an approximately similar number to the SVs 
### 8_2_12.1_plotmergedstats.R - R scripts, plots out figures for the MAF and HWE of individual SNP and SV calls
### 8_2_13_mergeSVsSNPs.sh - merges SNPs and SVs together into a single vcf for LD calculations
### 8_2_14_calcLD.sh - calculates pairwise LD between the markers. Uses the script below to split the pairwise values by SNP/SV
#### sub_8_2_14_LDpertype.pl - splits the pairwsie LD into SNP-SNP, SV-SNP and SV-SV values
### 8_2_14.1_plotLD.R - plots the resulting LDs by distance along the genome
### 8_2_15.1_SVpoolAF.sh - using the below subfunction, merges the allele frequencies estimated from the artificial pool, with those estimated from the individually genotyped samples
#### sub_8_2_15_join.pl - joins the two files. Surely there is a bcftools way of doing this 
### 8_2_15.2_SNPpoolAF.sh - does the same but with SNPs. Uses DP4 rather than AD.
#### sub_8_2_15.2_joinSNPs.pl - does the same. Note - seemingly broken at the min, perhaps a bit got deleted.
### 8_2_15.3_plotPoolVsInd.R - plots the in silico pool vs. individually estimated AFs. Fits linear models for the correlation. Also includes just the sites identified as significant in the SV GWAS. 
