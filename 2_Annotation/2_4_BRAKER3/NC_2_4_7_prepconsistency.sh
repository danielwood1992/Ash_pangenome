#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=5G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#module load bedtools2/;

module load bedtools2/2.31.1-python-3.11.7-gcc-12.2.0

#Want to update this file:
results="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.txt";

#Bed file to get the patterns:
trimmed_bed="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.trimmed";

dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2";

#truncate -s 0 $trimmed_bed.gene

#cd $dir;
#while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9;
#	do pattern="${f7}"$'\t'"${f8}"$'\t';
#	files=( ${f9}*overall*txt )
	
#	n_match=$(grep -F "$pattern" "${files[@]}" | wc -l)

#	if (( n_match == 1 )); then
 #       	match_file=$(grep -H -F "$pattern" "${files[@]}" | cut -f1 -d:)
#	        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
#        	    "$f1" "$f2" "$f3" "$f4" "$f5" "$f6" "$f7" "$f8" "$f9" "$match_file" >> $trimmed_bed.gene
  #  	else
   #     	echo "ERROR: Pattern '$pattern' matched $n_match times (expected exactly 1)" >> $trimmed_bed.gene
    #    	exit 1
    #	fi
#done < $trimmed_bed;
#So then we can use this file...
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_4_BRAKER3/sub_NC_2_4_7_filter_results.pl";

perl $sub $trimmed_bed.gene $results;



