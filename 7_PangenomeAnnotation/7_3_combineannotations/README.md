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
#### 7_3_4_gtf2refcoords.sh - this uses the SVs used to build the fasta to convert coordinates in the gtf file from those in the converted fasta co-ordinate system, to the BATG-1.0 coordinate system. If a gene overlaps an insertion, it will be included like this: Scaf 400+INS.500, i.e. the position is at the 500th base inside an insertion that starts at position 400 in the reference genome. Uses the following subfunctions: 
#### sub_7_3_4_1_convertgtf.pl - does the conversion described above. Outputs: braker.gtf.bed.refcoords for the LR and SR annotations.
### 7_3_5_genesfromorthologs_pan.sh - using the LR/SR gtfs converted to reference co-ordinates, splits Orthologs into non-overlapping genes. Uses the below subfunction to do this: 
#### sub_7_3_5_1_genesfromorthologs.pl - does this. Outputs are a bunch of files e.g. OG000001.bed.
### 7_3_6_geneSVoverlaps.sh - splits bed files into genes, and determines SV overlaps
#### i) sub_7_3_6_1_splitbeds.sh - splits bed files using the following subfunctions:
##### i.1) sub_7_3_6_1_1_splitbeds.pl - splits the bedfile into non-overlapping genes: e.g. OG00001.bed.0.txt
##### i.2) sub_7_3_6_1_2_getvcf.pl - identifies SVs overlapping with genes for each individual, and SVs in that region for individuals lacking the gene - outputs OG00001.bed.0.txt.SVs
### ii) sub_7_3_6_2_summariseSVoverlap.pl - summarises the overlappig genes/SVs - outputs OG00001.bed.0.txt.SVs.SVsGenes
### 7_3_7_combineOverlaps.sh - combines the overlapping gene/SV files
#### sub_7_3_7_1_F1.pl - for genes overlapping with SVs, calculates an F1 score for the association between the gene (or lack of gene) and the SV
#### 7_3_8_plotfilterF1s.R - R script to filter by F1 score, make plots. Output is PG2_20_9_results.txt.F1.filtered (for those that passed filtering) and PG2_20_9_results.txt.F1.excluded (for those that didn't)

