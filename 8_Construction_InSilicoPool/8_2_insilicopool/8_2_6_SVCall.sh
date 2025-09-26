##JOB_NUM##
#KPG0_2

#See qarray.sh README for how this works. 

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt";

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
#$ -l rocky
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

#So this script generates a vcf from the gam file
#Requires quite a lot of memory but can do in an hour

#Load modules
#file_list=$names;
#SGE_TASK_ID=1;

#So $1 here is just $names. Each job within the array deals with one line of this file, as specified by
#the $SGE_TASK_ID variable
#So unless another line of the input file is specified, I can't see how provenances could have been swtiched
file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);

#outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#For long-read gamsd...


#vcf="/data/scratch/mpx545/PG2_AshPanGenome/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";
gamdir=$outdir/$name.PATCH.temp;
gam=$gamdir/$name.PATCH.gam;

#Requires xg and gbz
vg_gbz="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.gbz";
vg_xg="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.PATCH.vg.xg";
ls $vg_gbz;
ls $vg_xg;

#Patched version of vg used
vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";


cd $gamdir;
$vg pack -t ${NSLOTS} -x $vg_xg -g $gamdir/$name.PATCH.gam -Q 5 -o $gamdir/$name.PATCH.gam.pack && echo "2 done";

$vg call $vg_xg -t ${NSLOTS} -k $gamdir/$name.PATCH.gam.pack -r $vg_xg.snarls -v $vcf> $outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf && echo "3 done";

