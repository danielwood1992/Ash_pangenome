#### 9_2_Calls - identifying frequencies of SNPs and SVs from the gam files
##### 9_2_1_SVCall.sh - uses vg pack -Q 5 to filter for mapping/base quality from the gams, then calls SVs using vg call. This uses pre-existing snarls.
##### 9_2_2_getcounts.sh - uses the below subfunction to extract alt/ref counts from the vcf. Output file $vcf.adstas
###### sub_9_2_2_getcounts.pl - perl function that does the above
##### 9_2_3_mergeSVcounts.sh - merges the information from the allele frequencies estimated from the pools into a single file, using the below subfunction
###### sub_9_2_3_merge.pl - merges alt/ref counts across the adstats files from individual pools
##### 9_2_4_surject.sh -  surjects the gam into the reference co-ordinate space, producing a bam. This also filters the bam, removing reads with MAPQ < 20, and PCR duplicates.
#### 9_2_5_mpileup_bigcontigs.sh - from the bam files, produces a mpileup file using samtools, per chromosome. Then produces a .sync file per chromosome using Popoolation2
#### 9_2_6_mpileup_extracontigs.sh - for the remaining smaller contigs, does the same thing. Just speeds computation up. 
