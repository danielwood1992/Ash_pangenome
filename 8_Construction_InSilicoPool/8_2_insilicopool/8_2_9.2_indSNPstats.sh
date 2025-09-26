##JOB_NUM##
#KPG0_2

#For how this submission script works, see qarray.sh README.txt

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#names="/data/home/mpx545/scripts/PG0_ShortReadStuff/Owen_Data.txt";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt";

#head -n 2 $names | tail -n 1 > $names.12;
#names=$names.12;

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

#So this script calculates the read counts (just reading out a bit of the vcf)

#Load modules

#The $1 here is the $names variable specified in the first section. Each job in the array deals with a 
#seperate line from this file, as specified by $SGE_TASK_ID.
#So unless another line is read, I don't see how you would get the Pool order miexed up
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

#outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/old";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

vcf=$outdir/$name.PATCH.temp/$name.PATCH.surject.bam.tomerge2.0.01.vcf;
script_dir="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap";

echo $vcf;

perl $script_dir/sub_PG2_15_3.2_get_more_info_SNPs.pl $vcf;

