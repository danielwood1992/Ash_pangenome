#### NC_7_1_reftransform - for each individual sample, transforming the BATG-1.0 seuqence taking into account the SVs called in that individual
### NC_7_1_1_getIndVcf.sh - from the joint vcf, get one vcf out per individual, preserving the consensus sequence for the alleles that individual contains
### NC_7_1_2_mutateref.sh
#### sub_7_1_2_1_getnooverlaps.pl - subfunction, keeps SVs that don't overlap. Prioritises by i) if it's an insertion, then ii) by SV length. Removes tandem duplicates as these do not get transferred to the graph-based pangenome
#### sub_7_1_2_2_getseqs.pl - fetches the sequences of the retained SVs from the vcf
#### sub_7_1_2_3_updatefasta.pl - uses these sequences to transform the reference fasta with the SVs. 
#### NC_7_1_2.1_excluded.sh - works out which SVs from the original vcf never get allocated to at least one of the individual transformed fastas
##### sub_7_1_2_1_getnooverlaps.pl - subfunction that actually carries out the above 
