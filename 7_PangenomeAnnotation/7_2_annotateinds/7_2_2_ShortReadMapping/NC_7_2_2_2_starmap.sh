##JOB_NUM##

#PG2_20_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"
truncate -s 0 $names.PG2_20_fastas;
while read name; do echo "${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta" >> $names.PG2_20_fastas; done < $names;
names=$names.PG2_20_fastas; 

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#module load repeatmasker/4.0.7
#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#SGE_TASK
file_list=$1;
hap=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
hap_dir=$hap.starindex;

#A submission script for doing star for each indvidual tissue, for a given inptu fasta file
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_2_annotateinds/7_2_2_ShortReadMapping/sub_7_2_2_2_1_starmap.sh";
name=$(echo $hap | rev | cut -f1 -d/ | rev | cut -f1 -d.);
sub_name=$(echo $sub | rev | cut -f1 -d/ | rev);
cp $sub $hap_dir/$sub_name.$name.sh;

#Makes a fresh copy of the submission script
#hap.dir is the directory wiht the thing in it...
#hap_dir is the star index
#I think it only needs this, not actually the fasta itelf, to do the mapping
ls $hap_dir/$sub_name.$name.sh;
awk -v replacement=$hap.dir '{gsub("REPLACE_STRING_1", replacement)} 1' $sub > $hap_dir/$sub_name.$name.temp;
awk -v replacement=$hap_dir '{gsub("REPLACE_STRING_2", replacement)} 1' $hap_dir/$sub_name.$name.temp > $hap_dir/$sub_name.$name.sh;

#This then submits a qarray job for each of the RNA-seq file samples
qarray.sh $hap_dir/$sub_name.$name.sh;
