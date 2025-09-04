### 7_4 - functional annotation of the proteins sequences of all the genes putatively in the pangenome
#### 7_4_1_getproteins.sh - shell submission script for the sunfunction
#### sub_7_4_1_1_getproteins.pl - for each gene (i.e. every OG0000.bed.0.txt file), prints out the protein sequence - from BATG-1.0 if present, otherwise the longest of the protein sequences from each sample. Final output protein_seqs_PG2_20_complete.fasta.
###  
### 7_4_2_uniprotdDB.sh - makes diamond database from swissprot/uniprot database
### 7_4_3_uniprot_search.sh - searches swissprot/uniprot database with the putative pangenome proteins. Output PG2_26_2_diamondUniProt.tsv
### 7_4_4_nrDB.sh - makes diamond database for ncbi nr protein set
### 7_4_5_nr_search.sh - searches nr database with putative pangenome proteins.
### 7_4_6_prep4interproscan.sh -  splits files before interproscan: outputs a list of the split files
##### sub_7_4_6_1_split.pl - splits protein fasta, removes *
### 7_4_7_interproscan.sh - runs interproscan on each of the subsets. These get concatenated into PG2_26_5_interproscan_combined.tsv in 7_34_9
### 7_4_8_eggnog.sh - seearches putative protein sequeneces against eggnog database
### 7_4_9_genes4GO.sh  - gets the annotaiton information from the above for the included/excldued genes. Also runs the below subfunction to generate lists for GO enrichment
#### sub_7_4_1_1_getproteins.pl - this gets lists of genes that are included in the pangenome (I), filtered out (NI), are included but not variable (NV) and variable (NV), as well as combinations of these for background (I_NI, V_NV, V_NI) i.e. for looking at things enriched in variable genes (V) against a background of variable+not vairable genes (V_NV)
### 7_4_10_GOenrichment.R - compares annotation levels of excluded vs. included genes. Also does GO enrichment for varying ombinations of included/exlcuded genes, produces plots
### 7_4_11_includedBUSCO.sh - using protein sequences from included genes, runs BUSCO. Requires fasta_fromlist.pl
