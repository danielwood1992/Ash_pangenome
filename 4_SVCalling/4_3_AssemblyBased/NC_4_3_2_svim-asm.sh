#JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_10_alignfastas/assembly_list.txt";
ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

names=$1;
assembly=$(sed -n "${SGE_TASK_ID}p" $names | cut -f1);
ls $assembly;
bam=$(dirname $assembly);
bam=$bam/minimap2.bam;
ls $bam;
name=$(echo $bam | rev | cut -f2 -d'/' | rev)
echo $name;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
rm -r $outdir/$name.svim_asm;
mkdir $outdir/$name.svim_asm;

module load miniconda;
conda activate /data/home/mpx545/conda_environments/svim-asm
svim-asm haploid --min_mapq 20 --min_sv_size 50 $outdir/$name.svim_asm $bam $genome;
