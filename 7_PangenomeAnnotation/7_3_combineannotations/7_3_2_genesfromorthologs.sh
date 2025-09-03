##JOB_NUM##
#KPG0_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

new_output_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2";
rm -r $new_output_dir;
mkdir $new_output_dir;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names $new_output_dir"; #note this passes on $names and the new_output_dir to the array scripts
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;
new_output_dir=$2;

#Finds the locations of the relevant BRAKER gtfs for each individual, and the location of the orthogroups file
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
echo $name;
dir1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_5";
dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_6.lr";
ortho_dir=$dir1/PG2_20_4_orthodir;
orthogroups_dir=$(ls -d $ortho_dir/OrthoFinder/Results*/Orthogroups)
ls -d $orthogroups_dir*/;
dir=$orthogroups_dir/PG2_20_5 #new output directory
orthogroups=$orthogroups_dir/Orthogroups.txt;

#Sets up a file identifying where the LR/SR braker gtfs are
truncate -s 0 $ortho_dir/SR_LR_gtf_list.txt;
echo -e "SR\t$dir1/braker.gtf" >> $ortho_dir/SR_LR_gtf_list.txt;
echo -e "LR\t$dir2/braker.gtf" >> $ortho_dir/SR_LR_gtf_list.txt;

#This subfunction gets the bed location of the transcripts for each gene in each orthogroup
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_2_1_findbeds.pl"
perl $sub $orthogroups $dir $ortho_dir/SR_LR_gtf_list.txt;
#The result is a directory (dir) with bed files for each orthogroup

module load bedtools;
#This then splits each bed file into non-overlapping gene elements


for file in $dir/OG*bed;
	#Gets the full set of overlaps within each bed file
	 do cat $file | bedtools sort -i | bedtools merge | bedtools intersect -a stdin -b $file -wa -wb | bedtools sort | sort -k1,1 -k2,2n -k3,3n > $file.overall;

	#This identifies the longest gene in a group of overlapping genes, for both the LR and SR runs 
        #and prints the result out to a file $file.overall.$N.txt,
	#where there are as many Ns as there are nonoverlapping genes within an orthogroup.
	sub2="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_2_2_splitbed.pl";
	perl $sub2 $file.overall;
done;

truncate -s 0 $dir/$name.PG2_4_4_10.2.results.txt;
echo "file SR LR Total" >> $dir/$name.PG2_4_4_10.2.results.txt;

truncate -s 0 $dir/$name.PG2_4_4_10.2.results.longest.bed;

#For each of the files in these groups:
#sub3 is just a couple of lines which will output the longest result per bed file
sub3="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_2_3_longestbed.sh";
for file in $dir/OG*bed*txt;
	#This is for each gene, identifying the number of genes identified in the SR/LR annotations
	do SR=$(grep -P "\tSR\t" $file  | wc -l );
	LR=$(grep -P "\tLR\t" $file | wc -l );
	total=$((SR+LR));
	echo "$file $SR $LR $total" >> $dir/$name.PG2_4_4_10.2.results.txt;
	sh $sub3 $file >> $dir/$name.PG2_4_4_10.2.results.longest.bed;
done;	

#Retrieve the amino acids for the longest sequence for each gene
#Set up output file, find out file
truncate -s 0 $ortho_dir/$name.LR_SR_combined.aa.fasta;
ls $ortho_dir/$name.LR.aa.fasta;
ls $ortho_dir/$name.SR.aa.fasta;

du -sh $ortho_dir/$name.LR.aa.fasta;
du -sh $ortho_dir/$name.SR.aa.fasta;

sub4="/data/home/mpx545/scripts/PG2_RealData/PG2_20_PangenomeAnnotation/sub_PG2_20_5.3_getaas.pl";
awk '$8 == "LR"' $dir/$name.PG2_4_4_10.2.results.longest.bed | wc -l;
awk '$8 == "SR"' $dir/$name.PG2_4_4_10.2.results.longest.bed | wc -l;

#For the LR and SR genes in the list of longest sequences per gene, retrieves the amino acid sequences from the respective aa fasta files.
perl $sub $dir/$name.PG2_4_4_10.2.results.longest.bed $ortho_dir/$name.LR.aa.fasta LR;
perl $sub $dir/$name.PG2_4_4_10.2.results.longest.bed $ortho_dir/$name.SR.aa.fasta SR;

#Combine these together and move to new location for pangenome analyis
cat $ortho_dir/$name.LR.aa.fasta.4comb $ortho_dir/$name.SR.aa.fasta.4comb > $ortho_dir/$name.LR_SR_combined.aa.fasta
cp $ortho_dir/$name.LR_SR_combined.aa.fasta $new_output_dir/$name.LRSR.aa.fasta;


#/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_5_Validation/All_for_Orthofinder_pangenome/protein_seqs_PG2_20_complete.fasta



