##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/dovetail_fastas.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txt";

#head -n 2 $names > $names.12;
#names=$names.12;

tail -n 1 $names > $names.3;
names=$names.3;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#module load minimap2/2.5;
module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/minimap2.5
minimap2="/data/SBCS-BuggsLab-Ash/DanielWood/github_repos/minimap2.5/minimap2-2.5/minimap2"

file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
reads="/data/SBCS-BuggsLab-Ash/Pangenome_Data/Cantata_ReferenceGenome/PacBio_Data/concatenated_B01_C01.fastq.gz";
outdir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_9_pacbiomap";

#For dovetail completed haplotypes...
name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d'.')

echo $name;
cd $outdir2;
#  $minimap2 -ax map-pb -t 4 $sample_name $reads | samtools sort -O BAM -o $outdir2/$name.pacbio.bam -;
#ls $outdir/$name.pacbio.bam;
samtools stats $outdir2/$name.pacbio.bam -c 0,50000,1 > $outdir2/$name.pacbio.bam.stats;
#total=$(grep "raw total sequences" $outdir2/$name.pacbio.bam.stats | cut -f3)
#mapped=$(grep "reads mapped:" $outdir2/$name.pacbio.bam.stats | cut -f3)
#echo "scale=3; $mapped / $total" | bc > $outdir2/$name.pacbio.bam.stats.pc;


