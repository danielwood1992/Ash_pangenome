#### 7_1_reftransform - for each individual sample, transforming the BATG-1.0 seuqence taking into account the SVs called in that individual
### 7_1_1_getIndVcf.sh - from the joint vcf, get one vcf out per individual, preserving the consensus sequence for the alleles that individual contains
### 7_1_2_mutateref.sh
#### sub_7_1_2_1_getnooverlaps.pl - subfunction, keeps SVs that don't overlap. Prioritises by i) if it's an insertion, then ii) by SV length. Removes tandem duplicates as these do not get transferred to the graph-based pangenome
#### sub_7_1_2_2_getseqs.pl - fetches the sequences of the retained SVs from the vcf
#### sub_7_1_2_3_updatefasta.pl - uses these sequences to transform the reference fasta with the SVs. 
