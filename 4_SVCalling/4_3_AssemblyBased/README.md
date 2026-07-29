# N_C_43 - Calling SVs using denovo assemblies
#### assembly_list.txt - list of assemblies for SV calling from individual samples
#### N_C_43_1_minimap2.sh - maps de novo assemblies to BATG-1.0 using minimap2 
#### N_C_43_2_svim-asm.sh - calls SVs using svim-asm, filtering for MAPQ = 20 and min_size = 50
#### N_C_43_3_filt.sh - removes SVTYPE=BND and incomplete inversions
