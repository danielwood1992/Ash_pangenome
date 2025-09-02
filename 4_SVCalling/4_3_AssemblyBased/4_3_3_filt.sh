##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_10_alignfastas/assembly_list.txt";
#names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_9_S26_assemblies/assembly_list.txt";
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/cantata_test_list.txt";
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
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

names=$1;
#names=$names;
#SGE_TASK_ID=1;
assembly=$(sed -n "${SGE_TASK_ID}p" $names | cut -f1);
ls $assembly;
bam=$(dirname $assembly);
bam=$bam/minimap2.bam;
ls $bam;
#name=$(echo $bam | rev | cut -f2 -d'/' | rev)
#For cantata/DW-S26 test
name=$(sed -n "${SGE_TASK_ID}p" $names | cut -f1);
echo $name;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
#outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#outdir=$outdir/DW-S26.$name.svim_asm;
#For the cantata test
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test";
variants=$outdir/$name.svim_asm/variants.vcf;
grep -vP '\tincomplete_inversion' $variants > $variants.filt2.vcf;
grep -vP 'SVTYPE=BND' $variants > $variants.filt3.vcf;

