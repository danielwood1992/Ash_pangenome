### Running BRAKER on the long and short reads
#### 2_4_1_brakerBATG1.0_short.sh - runs BRAKER3 on BATG-1.0 10 times, using the same input data - bams of short-read samples mapped to the assebmly, the Viridiplantae.fa file from OrthoDB 11, the softmasked assembly file.
#### 2_4_2_brakerBATG1.0_long.sh - runs a build of BRAKER3 capable of analysing long-read RNA-seq data (singularity build braker3_lr.sif docker://teambraker/braker3:devel) on BATG-1.0 10 times, using the same input data - bams of long-read samples mapped to the assebmly, the Viridiplantae.fa file from OrthoDB 11, the softmasked assembly file.
#### 2_4_3_LRSRaas.sh - for each number 1-10, gets the corresponding amino acid sequences associated with that run - selects the longest aa sequence per gene, (skips if none are >30 aas), renames headers/files to be able to distinguish between repeated runs, outputs into directory for running OrthoFinder. Uses the two subfunctions below
##### sub_2_4_3_1_fastaoneline.sh - converts fasta from interleaved to non-interleaved
##### sub_2_4_3_2_longestaa.pl - perl script, gets the longest amino acid sequence per gene from the BRAKER .aa files
#### 2_4_4_orthofinder.sh - runs OrthoFinder v2.5.5 on the amino acid sequences from the 10 runs of LR BRAKER3 and SR BRAKER3.
#### 2_4_5_overlaps.sh - . This script takes the outputs of Orthofinder, and within each Orthogroup across runs identifies non-overlapping sets of gene, noting how many are found across different LR and SR runs, and selecting the longest of these. For each of these, outputs a .gt file and an amino acid fasta file, with information from each of the individual runs. Uses the subfunctions below
##### sub_2_4_5_1_findbeds.pl - for an Orthogroups.txt file and a list of gtfs, for each member of each Orthogroup, extracts the location information for that gene from the relevant gtf and outputs them all in a bed file, one per Orthogroup. Also outputs the amino acids.
##### sub_2_4_5_2_splitfile.pl - for non-overlapping groups within an ortholog, outputs one bed entry per run of BRAKER (the longest) into a new file per non-overlapping group.
##### sub_2_4_5_3_longestbed.sh - very short awk command that selects the longest bed entry for each of the non-overlapping orthogroups
##### sub_2_4_5_4_getfinalgtf.pl - for each representative gene sequnece, retrieves the relevant gtf entries for each run
##### sub_2_4_5_5_getfinalaas.pl - for each representative gene sequence, retrieves the relevant amino acids from each .fa from a BRAKER run (which were annotated with a unique run ID in the fasa header in 2_4_3_LRSRaas.sh
#### 2_4_6_consistency.R - R script that uses the output of 2_4_5 to summarise how many genes are consistently annotated across the SR and LR runs.
