##JOB_NUM##

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/dovetail_fastas.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
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

#Load modules

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
name=$name.$SGE_TASK_ID;
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#tmp_name=$outdir/$name.tmptrimmo.fq.gz;
echo $sample_name;

echo $name;

module load miniconda;
conda activate /data/home/mpx545/conda_environments/blobtools2;
#blobtools --version;
blast_hits=$sample_name.2023.blast.out;

taxdump="/data/home/mpx545/new_taxdump";
echo $outdir/$name.blobdir;
blobtools add --hits $blast_hits --taxrule bestsumorder --taxdump $taxdump $outdir/$name.blobdir;
