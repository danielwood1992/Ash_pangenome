#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=4G
#SBATCH -a 1-10
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#subfunctions

script_dir="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/2_Annotation/2_4_BRAKER3";

sub1="$script_dir/sub_2_4_3_1_fastaoneline.sh";
sub2="$script_dir/sub_2_4_3_2_longestaa.pl";

#For SGE_TASK_ID = 1-10, gets a long read and short read directory...
dir1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_4_7.1._bam1.$SLURM_ARRAY_TASK_ID";
dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_4_8.1._bam1_lr.$SLURM_ARRAY_TASK_ID";

#Output directory
ortho_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder";

#Stem for BRAKER file name
braker_file="braker.gtf";

#For the i) short reads and ii) long reads, adds run information to the aa fastas.
#Gets one line per protein sequence, and then selects the longest protein sequence per gene

#Short reads
cp $dir1/braker.aa $dir1/$braker_file.aa.aa;
sed -i "s/>/>SR.run$SLURM_ARRAY_TASK_ID/g" $dir1/$braker_file.aa.aa 
sh $sub1 $dir1/$braker_file.aa.aa;
perl $sub2 $dir1/$braker_file.aa.aa.oneline.fasta;
cp $dir1/$braker_file.aa.aa.oneline.fasta.longest.fa $ortho_dir/run.$SLURM_ARRAY_TASK_ID.SR.fa;

#Long reads
cp $dir2/braker.aa $dir2/$braker_file.aa.aa;
sed -i "s/>/>LR.run$SLURM_ARRAY_TASK_ID/g" $dir2/$braker_file.aa.aa
sh $sub1 $dir2/$braker_file.aa.aa;
perl $sub2 $dir2/$braker_file.aa.aa.oneline.fasta;
cp $dir2/$braker_file.aa.aa.oneline.fasta.longest.fa $ortho_dir/run.$SLURM_ARRAY_TASK_ID.LR.fa;

