bed_file=$1;

sub1="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_4_1_1_splitbed.pl";

perl $sub1 $bed_file;

script2="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_4_1_1_SVoverlaps.pl";

#For each of the genes within the bed file, runs $script2
for file in $bed_file.*txt;
	do ls $file;
	perl $sub2 $file; 
done;





