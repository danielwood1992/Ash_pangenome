##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#Note: only a subset of samples had de novo assemblies for Flye produced, including the ONT reads from the BATG-1.0 individual
names="/data/home/mpx545/scripts/PG2_RealData/PG2_9_denovoassembly/filtered_reads_denovoassemblytest_flye2.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 10
#$ -l highmem
#$ -l h_rt=240:0:0
#$ -l h_vmem=40G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#REAL
file_list=$1;

#genome="/data/SBCS-BuggsLab/DanielWood/PG2_PanGenome/raw_Genome_ROY3706_Fexcelsior_assemblies/purged.fa";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";

reads=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

name=$(echo $reads | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
echo $reads;

module load miniconda;
conda activate /data/home/mpx545/conda_environments/flye
flye --help;

cp $reads $outdir/$name.reads.tmp.fq.gz;
flye --out-dir $outdir/flye.$name -t 10 --nano-raw $outdir/$name.reads.tmp.fq.gz ;
