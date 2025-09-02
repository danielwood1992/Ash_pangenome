### 5_CharacteriseSVs - explores frequencies of SV types, generates/plots saturation curves 
#### 5_1_totalbp.sh - produces summary output files, for each of the minimum number of samples an SV is present in, detailing i) the total bp covered by each SV type, and ii) the total number of SVs. Note that the final vcf for use in pangenome construction is produced here: complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf with minum number of samples = 3
##### sub_5_1_lengths.pl - subfunction that calculates the total length for each SV type, for a given MAF
#### 5_2_satcurves.sh - from the final vcf, generates satuation curves: removes one individual at a time and calculates how many SVs remain
#### 5_3_SVplots.R - plots the outputs from 5_1 and 5_2
