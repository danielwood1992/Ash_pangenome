#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Script that fixes some of the problems in the merged vcf....

#The combined vcf for SVs across samples
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf";
#The reference used to generate the vcf
reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#sub1 - This gives each of the SVs in the joint file a unique name (appending their genomic position to the non-unique name they're assigned"
sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_5_Fix/sub_4_5_1_1_rename.pl";
perl $sub1 $vcf && echo "1";

#sub2 - rettrieves the N-1th to last position of each SV using bedtools; outputs this into a .bed file and a .tab file.
#Note - sites where the called SV extends beyond the end of the scaffold is excluded (2 loci), as well as SVs that overlaps with Ns in the reference genome
sub2="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_5_Fix/sub_4_5_1_2_rmbadoverlaps.sh";
sh $sub2 $vcf.uniqnames $reference && echo "2"; 

#sub3 - using the bed information, goes through the vcf and i) replaaces the reference allele with the correct sequence from the genome based on the start and end positions, ii) for deletions replaces the sequence with the first base of the reference sequence (which in the case of Ns, updates this to the correct alternate deleted base)
sub3="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_5_Fix/sub_4_5_1_3_fixsites.pl";
perl $sub3 $vcf.uniqnames.bed.tab.noN $vcf.uniqnames && echo "3";

sub4="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/4_SVCalling/4_5_Fix/sub_4_5_1_4_RmAmbIns.pl";
perl $sub4 $vcf.uniqnames.reffixed2;

#Final output - $vcf.uniqnames.reffixed2.1


