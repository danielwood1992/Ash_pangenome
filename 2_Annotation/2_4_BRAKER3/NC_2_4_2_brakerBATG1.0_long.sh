#!/bin.bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t 1-11
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

# Runs the long-read version of BRAKER3 10 times on the reference fasta
# Note: for each of the runs specified in the -t parameter above, $SGE_TASK_ID takes the value of 1-11 across different batch jobs

#1) Generate a comma separated list of the bam files for long reads mapped to the assembly
dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation";
long_reads=$dir;
list=$(echo $(ls $long_reads/*.rna_seq2*.1.bam) | sed 's/ /,/g'); #rna_seq2*.1.bam specifies long-read bams
echo $list;
string1=$list;

#2) Specify OrthoDB file
orthodb="/data/home/mpx545/Viridiplantae.fa";

#3) Generate a unique number for each run
num=$(date +'%Y%m%d%H%M');

#4) specify fasta for the softmasked genome
softmask_genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp.repeatmask.RepeatMod_plus_Laura.noLowSoftMask/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.masked";

#5) Specify an outut directory for each run
path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_4_8.1._bam1_lr.$SGE_TASK_ID";
rm -r $path;
mkdir $path;
#Long filename potentially causes GeneMark-ETP error
cp $softmask_genome $path/soft.fa;
softmask_genome=$path/soft.fa

echo $string1;

#Run BRAKER3 - lr version, braker3_lr.sif - singularity build braker3_lr.sif docker://teambraker/braker3:devel
slots=${NSLOTS};
singularity exec /data/home/mpx545/docker_stuff/braker3_lr/braker3_lr.sif braker.pl --species=PG2_4_4_8.1._bam1.$SGE_TASK_ID.$num.species --bam=$string1 --prot_seq=$orthodb --workingdir=$path --genome=$softmask_genome --useexisting --threads=$slots ;
