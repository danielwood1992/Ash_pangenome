##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=96:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -l rocky
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_28_6

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_17_surject";

gamdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe";

gam=$gamdir/$name.PATCH.temp/$name.PATCH.gam;

vg_xg="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.xg";

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

cd $outdir;
06/10/25
ls $gam;
$vg surject -t ${NSLOTS} -x $vg_xg -b $gam | samtools sort -o $outdir/$name.PATCH.surject.bam;

samtools sort -n $outdir/$name.PATCH.surject.bam | samtools fixmate -m - - | samtools sort - | samtools markdup -r - - | samtools view -bSq 20 -o $outdir/$name.PATCH.surject.q20.bam;
samtools index $outdir/$name.PATCH.surject.q20.bam;
