##JOB_NUM##
#KPG0_2


reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe";

#Set progress tracking
dat=$(date +%Y_%m_%d);

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

gamdir=$outdir/$name.PATCH.temp;

#Identifies the gam from the previous mapping step
gam=$gamdir/$name.PATCH.gam;


vg_gbz="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.gbz";
vg_xg="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.xg";
ls $vg_gbz;
ls $vg_xg;


#2) Compute read support from the gam

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

#Transforms the .gam file into a .pack file. The -Q is removing reads with MAPQ < 5 and positions with base quality < 5

$vg pack -t ${NSLOTS} -x $vg_xg -g $gamdir/$name.PATCH.gam -Q 5 -o $outdir/$name.PATCH.gam.pack && echo "2 done";

#3) Generate a vcf from the read support...

$vg call $vg_xg -t ${NSLOTS} -k $outdir/$name.PATCH.gam.pack -r $vg_xg.snarls -v $vcf> $outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf && echo "3 done";

module load htslib;
#sed -i 's/ID=SAMPLE/ID=$name/g' $outdir/$name.gam.PG2_15_2.vcf;
#sed -i -e "s/ID=\$name/ID=$name/g" $outdir/$name.gam.PG2_15_2.vcf;
bgzip -c $outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf > $outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf.gz
module load bcftools;
bcftools index $outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf.gz;

