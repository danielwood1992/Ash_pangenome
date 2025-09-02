##JOB_NUM##

#PG2_20_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"
truncate -s 0 $names.PG2_20_fastas;
while read name; do echo "${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta" >> $names.PG2_20_fastas; done < $names;
names=$names.PG2_20_fastas; 
head $names -n 1 > $names.2;
names=$names.2;
#tail -n+2 $names > $names.head2;
#names=$names.head2;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 5
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


#SGE_TASK
file_list=$1;
hap=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
hap_dir=$hap.minimap2dir;
mkdir $hap_dir

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_2_annotateinds/7_2_3_LongReadMapping/sub_7_2_3_1_minimap2.sh";
name=$(echo $hap | rev | cut -f1 -d/ | rev | cut -f1 -d.);
sub_name=$(echo $sub | rev | cut -f1 -d/ | rev);
cp $sub $hap_dir/$sub_name.$name.sh;

#Updates names of the input fasta and output directory into the individual submission scripts
awk -v replacement=$hap '{gsub("REPLACE_STRING_1", replacement)} 1' $sub > $hap_dir/$sub_name.$name.temp;
awk -v replacement=$hap_dir '{gsub("REPLACE_STRING_2", replacement)} 1' $hap_dir/$sub_name.$name.temp > $hap_dir/$sub_name.$name.sh;
ls $hap_dir/$sub_name.$name.sh;

#Uses qarray to submit an array job from the modofied submission scripts: one job per RNA-seq sample
qarray.sh $hap_dir/$sub_name.$name.sh;


