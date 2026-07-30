##JOB_NUM##

#Gets the list of transformed fastas from the read names

#PG2_20_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"
truncate -s 0 $names.PG2_20_fastas;
while read name; do echo "${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta" >> $names.PG2_20_fastas; done < $names;
names=$names.PG2_20_fastas; 

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

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

#module load repeatmasker/4.0.7
#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#SGE_TASK
file_list=$1;
sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
ls $sample_name;

#For PG2_20_2
name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d.)
echo $name;
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_20_4_1";
haplotype="hap1";
dirbase=$outdir.$name.PG2_4_3.3;
hap_fasta=$sample_name;

laura_lib="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/Laura_RepeatLibrary/Combined_ash_repeat_library_premasked_BATG0.5.fasta";
repeatmod_lib="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/RM_Stuff/RM_200791.MonFeb61712262023/consensi.fa.classified";
#cat $laura_lib $repeatmod_lib > $repeatmod_lib.PlusLaura;


#RepeatModeler --help;
#BuildDatabase -name $hap1.db $hap1; #Runs very quickly...

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/repeatmodeler
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/repeatmodeler/pkgs

mkdir $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
cd $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
RepeatMasker -lib $repeatmod_lib.PlusLaura --xsmall -nolow -pa 15 $hap_fasta -engine wublast -e ncbi -dir $dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;


