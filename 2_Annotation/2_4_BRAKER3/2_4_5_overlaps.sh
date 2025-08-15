#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt
module load bedtools;

#Run name
name="LR_SR";
#Output directory
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_May21/Orthogroups/PG2_4_4_10.2";
#The list of orthogroups from the output of OrthoFinder
orthogroups="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_May21/Orthogroups/Orthogroups.txt";


#Specify list of GTFs
#list of gtfs from each run of BRAKER3
gtf_list="/data/home/mpx545/scripts/PG2_RealData/PG2_4_Annotation/PG2_4_4_BRAKER3/SR_LR_gtf_list.txt";
#I must have put this together manually? the format is
#SR\t10\t/path/to/braker.gtf
#SR\t9\t/path/to/braker.gtf
#...
#LR\t10\t/path/to/braker.gtf
#LR\t9\t/path/to/braker.gtf
#...
#For each of the 10 runs of the long read and short read BRAKER

#Unccomment to make work
#rm -r $dir;
#mkdir $dir;

#Subfunction 1
sub="sub_2_4_5_1_findbeds.pl";
#So this subfunction
#i) Goes through the orthogroups, assigning each individual+gene to an orthgroup
#ii) Goes through the .gtf files for each orthogroup, gets the genomic position
#iii) prints these to a shared .bed file for every member of that Orthogroup: one file per Orthogroup
perl $sub1 $orthogroups $dir $gtf_list;
#The output of this will be a directory $dir full of bed files, named OG000001.bed etc., one per Orthogroup

#Subfunction 2
sub2="sub_2_4_5_2_splitfile.pl";

for file in $dir/OG*bed;
	do cat $file | bedtools sort -i | bedtools merge | bedtools intersect -a stdin -b $file -wa -wb | bedtools sort | sort -k1,1 -k2,2n -k3,3n > $file.overall;
	#So what this will do is take the bed file, and sort by start position: 
	#bedtools merge will then merge these, giving overlapping intervals. So groups of overlapping genes will be identified.
	#Bedtools intersect will then take these merged regions, and identify which input regions correspond to those. This is then sorted by name, start position and end position to get an overlal file.
	
	perl $sub2 $file.overall;
	#This subfunction goes through the .overall file, and for each non-overlapping segments outputs a file (.1.txt, .2.txt etc.) with the longest gene for that file.  
done;

#Creates a new summary file
truncate -s 0 $dir/$name.PG2_4_4_10.2.results.txt;
echo "file SR LR Total" >> $dir/$name.PG2_4_4_10.2.results.txt;

#For each of the "genes" (non-overlapping exemplar sequences within each ortholog), this section summarises how many have 
#representative sequences for i) the BRAKER LR script and ii) the BRAKER SR script, and the totla
for file in $dir/OG*bed*txt;
	do SR=$(grep -P "\tSR\." $file  | wc -l ); 
	LR=$(grep -P "\tLR\." $file | wc -l );
	total=$((SR+LR));
	echo "$file $SR $LR $total" >> $dir/$name.PG2_4_4_10.2.results.txt;
done;	

#I don't think the below line is used: it was uncommented - it does not seem to be represented in the output file. Keeping for completeness.
#for file in $dir/*txt; do wc -l $file >> $dir/$name.PG2_4_4_10.2.results.txt; done;

#So then what we will need to do now is...
#Get an annonation file: for each "gene", identify the longest transcript
sub3="sub_2_4_5_3_longestbed.sh";

truncate -s 0 $dir/$name.PG2_4_4_10.2.results.longest.bed;
for file in $dir/*txt;
	do sh $sub3 $file >> $dir/$name.PG2_4_4_10.2.results.longest.bed;
	#This is just an awk command that gets the longest bed entry for each nonoverlapping ortholog group, outputs this to a file.
done;

#So then from this, we need to retrieve the full entries from each of the gtf lists...
sub4="sub_2_4_5_4_getfinalgtf.pl";
perl $sub4 $dir/$name.PG2_4_4_10.2.results.longest.bed $gtf_list;
#So this subfucntion, it reads through the bed file and notes which gtf each representative gene sequence comes from: retrieves all entries for this gene
#from the relevant gt, outsputs as final.gtf

braker_file=$dir/$name.PG2_4_4_10.2.results.longest.bed.final.gtf;
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

aa_location="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder";
#The aas from each braker run were copied to this location, and annotated with the run type/number in each fasta heading, by 2_4_3_LRSRaas.sh
ls $aa_location/run*fa > $aa_location/run_list.txt; 

sub5="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_4_BRAKER3/sub_2_4_5_5_getfinalaas.pl";
perl $sub5 $aa_location/run_list.txt $dir/$name.PG2_4_4_10.2.results.longest.bed;
#This takes the locations of the amino acid files, the final bed file, and retrieves the relevant amino acid for each representative gene

#Copies these to a new orthofinder folder for subsequent validation
cp $dir/$name.PG2_4_4_10.2.results.longest.bed.aa.fasta /data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder

