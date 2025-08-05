### Running BRAKER on the long and short reads
#### 2_4_1_brakerBATG1.0_short.sh - runs BRAKER3 on BATG-1.0 10 times, using the same input data - bams of short-read samples mapped to the assebmly, the Viridiplantae.fa file from OrthoDB 11, the softmasked assembly file.
#### 2_4_2_brakerBATG1.0_long.sh - runs a build of BRAKER3 capable of analysing long-read RNA-seq data (singularity build braker3_lr.sif docker://teambraker/braker3:devel) on BATG-1.0 10 times, using the same input data - bams of long-read samples mapped to the assebmly, the Viridiplantae.fa file from OrthoDB 11, the softmasked assembly file.
#### 2_4_3_LRSRaas.sh - for each number 1-10, gets the corresponding amino acid sequences associated with that run - selects the longest aa sequence per gene, (skips if none are >30 aas), renames headers/files to be able to distinguish between repeated runs, outputs into directory for running OrthoFinder
##### sub_2_4_3_1_fastaoneline.sh - converts fasta from interleaved to non-interleaved
##### sub_2_4_3_2_longestaa.pl - perl script, gets the longest amino acid sequence per gene from the BRAKER .aa files

