##JOB_NUM##

#HAP1
#file="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
#echo $file > $file.filename;
#names=$file.filename;

#PG2_20_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"
truncate -s 0 $names.PG2_20_fastas;
while read name; do echo "${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta" >> $names.PG2_20_fastas; done < $names;
names=$names.PG2_20_fastas; 
tail -n+2 $names > $names.head2;
names=$names.head2;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 5
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#module load repeatmasker/4.0.7
#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#SGE_TASK
file_list=$1;
hap=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

ls $hap;

#mkdir /data/home/mpx545/conda_environments/star;
module load miniconda;
#mamba create --prefix=/data/home/mpx545/conda_environments/star star;
mamba activate /data/home/mpx545/conda_environments/star;
mkdir $hap.starindex;
rm -r $hap.starindex/temp;
STAR --runMode genomeGenerate --genomeDir $hap.starindex --genomeFastaFiles $hap --genomeSAindexNbases 13 --runThreadN 5 --outTmpDir $hap.starindex/temp;

