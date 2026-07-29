# 4_4 - Merge SVS between approaches/individuals, compare the different approaches

#### NC_4_4_1_compareSVcallers.sh - gets the overlap of SVs called using different methods from BATG-1.0 individual: svim-asm for hap2 mapped to BATG-1.0, ONT reads mapped to BATG-1.0 and called using Sniffles2+cuteSV, and assemblies of the ONT reads (using Flye, shasta or nextdenovo) mapped and called using svim-asm
#### NC_4_4_1.1_compareSVcallers_gettype.sh - extracts each type of SV to a separate file 
#### NC_4_4_1.2_compareSVcallers_bytype.sh - repeats NC_4_4_1 but for each type

#### NC_4_4_3_callermerge.sh - merge SVs within one inividual, using SURVIVOR. Requires SV to be called either in i) Sniffles2 and cuteSV and/or ii) svim-asm. Merges SVs by type, then concatenates and sorts. 

#### NC_4_4_3.1_callermerge_sensitivity.sh - identifies the sensitivity of difference merge distances to the number of SVs called 

#### NC_4_4_4_indmerge.sh - using the per-individual SVs produced in the last step, merges across individuals

#### NC_4_4_4.4_indmerge_sensitivity.sh - tests sensitivity of this proccess to different merge distances

#### NC_4_4_5_calcF1plot.R - using the above results, calculates precision, recall, F1 scores for SV callign methods using the ONT data from the BATG-1.0 individual, assuming hap2 mapped to BATG-1.0 with calls from svim-asm represents the truth set
#### NC_4_4_5.1_FigS5arrange.R - arrange data for precision/recall/F1 per SV type into Figure S5 panels

#### NC_4_4_6_SVstats.R - plots numbers of SVs per caller (Figure S6)
