#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Create a directory for the individual orthogroup beds to go
ortho_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2";
orthogroups_dir=$(ls -d $ortho_dir/OrthoFinder/Results*/Orthogroups)
ls -d $orthogroups_dir*/;
dir=$orthogroups_dir/PG2_20_5
rm -r $dir;
mkdir $dir;

#The orthogroups
orthogroups=$orthogroups_dir/Orthogroups.txt;

#Individual sample names
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

#List of GTF files to use for finding gene co-ordinates
truncate -s 0 $ortho_dir/SR_LR_gtf_list.txt;

#Adds the final BATG-1.0 gtf
echo -e "LR_SR\tLR_SR\t/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_May21/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed" >> $ortho_dir/SR_LR_gtf_list.txt;

#For each of the pangenome samples, add the short read and long read braker.gtf(.bed.refcoord) files to the list -
#this is the locations of the genes in the BATG-1.0 coordinate space
while read name;
	do echo $name;
	dir1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_5";
	dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_6.lr";
	echo -e "$name\tSR\t$dir1/braker.gtf.bed.refcoords" >> $ortho_dir/SR_LR_gtf_list.txt;
	echo -e "$name\tLR\t$dir2/braker.gtf.bed.refcoords" >> $ortho_dir/SR_LR_gtf_list.txt;
done < $names;


sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_5_1_genesfromorthologs.pl";
#This will output the folder with the OG00001.bed files
perl $sub $orthogroups $dir $ortho_dir/SR_LR_gtf_list.txt;



