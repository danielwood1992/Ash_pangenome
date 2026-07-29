##JOB_NUM##

#HAP1
file="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
echo $file > $file.filename;
names=$file.filename;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 15
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


#SGE_TASK
file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
ls $sample_name;

dirbase="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified.tmp";
haplotype="hap1";
hap_fasta=$sample_name;

laura_lib="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/Laura_RepeatLibrary/Combined_ash_repeat_library_premasked_BATG0.5.fasta";
repeatmod_lib="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified";

cat $laura_lib $repeatmod_lib > $repeatmod_lib.PlusLaura;


module load miniconda;
mamba activate /data/home/mpx545/conda_environments/repeatmodeler
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/pkgs

mkdir $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
cd $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
RepeatMasker -lib $repeatmod_lib.PlusLaura --xsmall -nolow -pa 15 $hap_fasta -engine wublast -e ncbi -dir $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;

