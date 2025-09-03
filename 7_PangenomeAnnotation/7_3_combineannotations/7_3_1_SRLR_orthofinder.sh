##JOB_NUM##
#KPG0_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;

name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
echo $name;
dir1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_5";
dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_6.lr";
ortho_dir=$dir1/PG2_20_4_orthodir;
rm -r $ortho_dir;
mkdir $ortho_dir;

ls $dir1;
ls $dir2;
ls $ortho_dir;

#For annotation using short reads
#Update fasta names with the name of that specific run
cp $dir1/braker.aa $dir1/braker.aa.aa;
sed -i "s/>/>SR.$name./g" $dir1/braker.aa.aa
#Converts fasta to be non-interleaved
sh /data/home/mpx545/scripts/fasta_oneline.sh $dir1/braker.aa.aa;
#So this subfunction chooses the transcript with the longest aa (minimum length 30) per gene
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_3_combineannotations/sub_7_3_1_1_longesttranscript.pl";
perl $sub $dir1/braker.aa.aa.oneline.fasta;
cp $dir1/braker.aa.aa.oneline.fasta.longest.fa $ortho_dir/$name.SR.aa.fasta;

#For annotation using short reads
#Update fasta names with the name of that specific run
cp $dir2/braker.aa $dir2/braker.aa.aa;
sed -i "s/>/>LR.$name./g" $dir2/braker.aa.aa
#Converts fasta to be non-interleaved
sh /data/home/mpx545/scripts/fasta_oneline.sh $dir2/braker.aa.aa;
#So this subfunction chooses the transcript with the longest aa (minimum length 30) per gene
perl $sub $dir2/braker.aa.aa.oneline.fasta;
cp $dir2/braker.aa.aa.oneline.fasta.longest.fa $ortho_dir/$name.LR.aa.fasta;

module load miniconda
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder;
export CONDA_ENVS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/envs";
export CONDA_PKGS_PATH="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/orthofinder/pkgs";

orthofinder -f $ortho_dir -t ${NSLOTS};
#Orthofinder is run for the SR vs. LR genes
