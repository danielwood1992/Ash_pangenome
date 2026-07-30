##JOB_NUM##
#KPG0_2

pangenome_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";

list="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica";
cat $list | rev | sed 's/\/.*//g' | rev | sed 's/\..*//g' > $list.names;
module load bcftools;
bcftools reheader --samples $list.names -o $pangenome_vcf.renamed $pangenome_vcf;

names=$list.names;
#ls $names;
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
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
echo $name;
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";

pangenome_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";
pangenome_vcf=$pangenome_vcf.renamed;
module load bcftools/1.16;
bcftools view -Ov -s "$name" "$pangenome_vcf" | grep -v '\.\/\.' > $outdir/$name.PG2_20_2.vcf;


