##JOB_NUM##
#KPG0_2

#This generates 100 lists of Orthogroups, each of which then has an array job run on it
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroups/Orthogroups.txt";
cut -f1 -d":" $names > $names.list;
N=100;
num_lines=$(wc -l $names.list | cut -f1 -d' ');
#echo $num_lines;
lines_per_file=$(( (num_lines + N - 1)/N ));
split -l $lines_per_file -d -a 3 "$names.list" $names.prefix;
#So the output of this will be Orthogroups.txt.prefix001, Orthogroups.txt.prefix002 etc. etc.
ls $names.prefix* > $names.file_list;
names=$names.file_list;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;

file=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

#See subfunction descriptions in file below
sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_6_1_splitoverlap.sh";
sub2="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_6_2_summariseSVoverlap.pl";

#Gets the prefix and suffix for each Orthogroup file
prefix="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/PG2_20_5_toOrthofind_2/OrthoFinder/Results_Jun24/Orthogroups/PG2_20_5";
suffix="bed";

while read line;
	do echo $line;
	#This script runs a couple of subfunctions: splitting the ortholog into genes, then identifying
	#which genes overlap with SVs
	sh $sub1 $prefix/$line.$suffix;
	#This then runs for all the *SVs files generated: i.e. for each gene, the SVs that overlap
	for file in $prefix/$line.$suffix*SVs;
		do perl $sub2 $file;
	done;
done < $file;

