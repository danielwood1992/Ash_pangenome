#!/bin.bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t 1-11
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

# Runs BRAKER3 10 times on the reference fasta
# Note: for each of the runs specified in the -t parameter above, $SGE_TASK_ID takes the value of 1-11 across different batch jobs.

#1 - Load BRAKER3, test installation.
export BRAKER_SIF="/data/home/mpx545/docker_stuff/braker3.sif";
braker_dir="/data/home/mpx545/docker_stuff";
cd $braker_dir;
#bash test1.sh;
#bash test2.sh;
#bash test3.sh;

#2 Generate a comma separated list of the bam files for short reads mapped to the assembly

short_reads="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation";
list=$(echo $(ls $short_reads/*.1.star2*bam) | sed 's/ /,/g'); #.1.star2*bam specifies short-read bams
echo $list;
string1=$list;

#3) Specify OrthoDB file
orthodb="/data/home/mpx545/Viridiplantae.fa";

#4) Generates a unique number for each run
num=$(date +'%Y%m%d%H%M')

#5) specify fasta file for the softmaksed genome
softmask_genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.masked";

#6) Specify an output directory for each run
path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_4_7.1._bam1.$SGE_TASK_ID";
rm -r $path;
mkdir $path;

#7) Copy files to directory - long filenames potentially causes GeneMark-ETP error
cp $softmask_genome $path/soft.fa;
softmask_genome=$path/soft.fa

echo $string1;

#8) Run BRAKER3
singularity exec /data/home/mpx545/docker_stuff/braker3.sif braker.pl --species=PG2_4_4_7.1._bam1.$SGE_TASK_ID.$num.species --bam=$string1 --prot_seq=$orthodb --threads=${NSLOTS} --workingdir=$path --genome=$softmask_genome --useexisting;

