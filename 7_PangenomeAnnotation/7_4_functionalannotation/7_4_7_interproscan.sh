##JOB_NUM##

#Note: manually concatenated the outputs of this script into one file, PG2_26_5_interproscan_combined.tsv

#lists of subsets of the putative protein sequences
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta.list";
#One job oer subset

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


#Run interproscan on the subsets

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
dir=$name.dir;
rm -r $dir;
mkdir $dir;
interproscan_sif="/data/SBCS-BuggsLab-Ash/DanielWood/docker_things/interproscan/interproscan_latest.sif";
data="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/interproscan_data/interproscan-5.69-101.0/data";
temp_dir=$dir.temp;
mkdir $temp_dir;
singularity exec -B $data:/opt/interproscan/data -B $name:/input -B $temp_dir:/temp -B $dir:/output $interproscan_sif /opt/interproscan/interproscan.sh --input $name --disable-precalc --output-dir $dir --tempdir $dir --cpu ${NSLOTS};  


