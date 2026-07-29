# NC_4_5 - fixes a few miscellaneous issues with the combined SV call vcf, required before it can be converted to pangenome formats
#### NC_4_5_1_fixvcf.sh - fixes vcf issues. Uses the subfunctions below, see script for full details.
##### sub_4_5_1_1_rename.pl - gives SVs unique names
##### sub_4_5_1_2_rmbadoverlaps.sh - from the SV locations in the vcf, gets the sequences for the reference alleles
##### sub_4_5_1_2.1_noN.pl - removes alleles that overlap wth Ns
##### sub_4_5_1_3_fixsites.pl - replaces the sequences in the vcf with the actual sequences implied by the positions given
##### sub_4_5_1_4_RmAmbIns.pl - removes ambiguous insertions
#### NC_4_5_2.0_seqs4blobtools.sh - retrieves SV sequences for checking with blobtools, blasts against nt database
#### NC_4_5_2.1_createblobtools.sh - creates blobtools directory
#### NC_4_5_2.2_addblast.sh - adds blast results to blobtools directory. This is then viewed and contaminant sequences identified.
#### 041023_contams.csv - contaminanS SV sequences as identified in blobtools GUI using standard settings
#### NC_4_5_2.3_rmcontam.pl - removes contaminant SV sequences from the combined vcf
