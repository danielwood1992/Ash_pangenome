##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";
#head -n 1 $names > $names.tstPG2_17_11;
#names="$names.tstPG2_17_11";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load miniconda;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/clair3 


#REAL
file_list=$1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
cd $outdir;
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";
suffix="hap1.rmdpq20.bam.sorted.bam";


name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
bam_name=$dir/$name.$suffix;
outdir=$bam_name.clair;

rm -r $outdir;
mkdir $outdir;
cd  $outdir;
MODEL_NAME="r941_prom_sup_g5014"
run_clair3.sh --include_all_ctgs --bam_fn=$bam_name --ref_fn=$genome --threads=${NSLOTS} --platform="ont" --model_path="/data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/clair3/bin/models/${MODEL_NAME}" --output=$outdir --gvcf;


