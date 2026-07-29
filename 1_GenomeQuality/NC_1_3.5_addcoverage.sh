##JOB_NUM##

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/dovetail_fastas.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
#ARRAY_NUM="1 $names"; #temp, for hap1
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=5G
#$ -t ? 
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

#cantata
name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
blobname=$name.$SGE_TASK_ID;
bamname=$name.hap${SGE_TASK_ID}.$SGE_TASK_ID.pacbio.bam;
outdir="/data/scratch/mpx545/PG2_AshPanGenome";

ls $outdir/$bamname;
ls $outdir/$blobname.blobdir;
echo $sample_name;

module load miniconda;

blobtools add --cov $outdir/$bamname $outdir/$blobname.blobdir;
