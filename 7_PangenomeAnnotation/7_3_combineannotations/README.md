## 7_PangenomeAnnotation - annotating the pangenome, including identifying and filtering putative dispensible genes. 
### 7_1_reftransform - for each individual sample, transforming the BATG-1.0 seuqence taking into account the SVs called in that individual
###
### 7_3_1_SRLR_orthofinder.sh - adds run information to the header of the long-read annotated/short-read annotated amino acid fastas for each individual, selects longest aa transcript per gene. Runs orthofinder on these
#### sub_7_3_1_1_longesttranscript.pl - selects longest aa sequnce per gene
#### sub_7_3_2_1_findbeds.pl - from the gtf files, gets the equivalent bed file for each gene
#### sub_7_3_2_2_splitbed.pl - splits the Orthogroup files into non-overlapping segments, retaining the longest gene for the SR and LR annotations
#### sub_7_3_2_3_longestbed.sh - gets the longest entry in the bed files of sequence
#### sub_7_3_2_4_getaas.pl - for each of the final genes, retrieves the amino acid sequeneces
### 7_3_3_pangenome_orthofinder.sh - for each set of predicted proteins from the individually annotated fasta files, and the BATG-1.0 proteins, runs Orthofinder
### 7_3_4_geneSVoverlaps.sh - from the output of Orthofinder, splits genes by overlapping sequence as before - also identifies which SVs overlap with which genes in which individuals. Runs two subfunctions
#### i) sub_7_3_4_1_splitbed_getSVoverlaps.sh - for each of the genes described by an orthogroup, runs subfunction below:
##### sub_7_3_4_1_1_SVoverlaps.pl - splits each into non-overlapping orthologs
##### sub_7_3_4_1_2_NAME.pl

#### i) sub_7_3_4_2_summariseoverlap.pl
