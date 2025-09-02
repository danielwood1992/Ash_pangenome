# 4_3 - Calling SVs using denovo assemblies
#### assembly_list.txt - list of assemblies for SV calling from individual samples
#### 4_3_1_minimap2.sh - maps de novo assemblies to BATG-1.0 using minimap2 
#### 4_3_2_svim-asm.sh - calls SVs using svim-asm, filtering for MAPQ = 20 and min_size = 50
#### 4_3_3_filt.sh - removes SVTYPE=BND and incomplete inversions
