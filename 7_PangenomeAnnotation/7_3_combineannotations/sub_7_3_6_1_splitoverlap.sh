input_file=$1;

#This splits the file into OG0000.bed.0.txt, OG0000.bed.1.txt etc - i.e. genes.
script="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_6_1_1_splitbeds.pl";
perl $script $input_file; #Note: this was commented out before, should it have been? Surely not

#This script identifies which SVs overlap with genes, outputs OG0000.bed.1.txt.SVs
script2="/data/home/mpx545/scripts/PG2_RealData/PG2_20_PangenomeAnnotation/sub_PG2_20_8.1_getvcf_v2.pl";

#For each of these files...?
for file in $input_file.*txt;
	do ls $file;
	perl $script2 $file; 
done;




