##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=24:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

#Load modules

#For each of the individual gam files, surjects to a bam - then filters this for mapping quality

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_28_6

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

gamdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/$name.PATCH.temp";
outdir=$gamdir;

gam=$gamdir/$name.PATCH.gam;

vg_xg="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.xg";

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

$vg surject -t ${NSLOTS} -x $vg_xg -b $gam | samtools sort -o $outdir/$name.PATCH.surject.bam;

cd $outdir;
samtools sort -n $outdir/$name.PATCH.surject.bam | samtools fixmate -m - - | samtools sort - | samtools markdup -r - - | samtools view -bSq 20 -o $outdir/$name.PATCH.surject.q20.bam;
samtools index $outdir/$name.PATCH.surject.q20.bam;

