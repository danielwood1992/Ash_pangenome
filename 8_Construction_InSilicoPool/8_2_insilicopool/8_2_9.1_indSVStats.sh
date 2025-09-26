##JOB_NUM##
#KPG0_2

#For how this submission script works, see qarray.sh README.txt

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt";

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
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

vcf=$outdir/$name.PATCH.gam.snarls.PG2_15_2.vcf;
script_dir="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap";

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/8_Construction_InSilicoPool/8_2_insilicopool/sub_8_2_9.1_getinfo.pl";
perl $sub $vcf;
