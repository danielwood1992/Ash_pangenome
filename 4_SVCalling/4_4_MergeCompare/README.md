# 4_4 - Merge SVS between approaches/individuals, compare the different approaches

#### 4_4_1_compareSVcallers.sh - gets the overlap of SVs called using different methods from BATG-1.0 individual: svim-asm for hap2 mapped to BATG-1.0, ONT reads mapped to BATG-1.0 and called using Sniffles2+cuteSV, and assemblies of the ONT reads (using Flye, shasta or nextdenovo) mapped and called using svim-asm
#### 4_4_2_calcF1plot.R - using the above results, calculates precision, recall, F1 scores for SV callign methods using the ONT data from the BATG-1.0 individual, assuming hap2 mapped to BATG-1.0 with calls from svim-asm represents the truth set
#### 4_4_3_callermerge.sh - merge SVs within one inividual, using SURVIVOR. Requires SV to be called either in i) Sniffles2 and cuteSV and/or ii) svim-asm. Merges SVs by type, then concatenates and sorts. 
#### 4_4_4_indmerge.sh - using the per-individual SVs produced in the last step, merges across individuals


