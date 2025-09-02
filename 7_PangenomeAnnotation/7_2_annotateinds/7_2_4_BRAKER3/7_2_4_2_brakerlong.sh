##JOB_NUM##

names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Testing BRAKER3 installation..

file_list=$1;

name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";
fasta="${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta";

#This gets the long read bams for that individual
long_reads=$fasta.minimap2dir;
string2=$(echo $(ls $long_reads/*.rna_seq.bam) | sed 's/ /,/g');

#This can stay the same
orthodb="/data/home/mpx545/Viridiplantae.fa";

path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_6.lr";

haplotype="hap1";
dirbase="$outdir/PG2_20_4_1.$name.PG2_4_3.3";
genome_dir=$dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
#Gets the individual softmaasked fasta file
softmask_genome=$genome_dir/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.masked;


rm -r $path;
mkdir $path;
#Long filename potentially causes GeneMark-ETP error
cp $softmask_genome $path/soft.fa;
softmask_genome=$path/soft.fa

dat=$(date +%Y_%m_%d);

num=$(date +'%Y%m%d%H%M%S')
num="$num.$name";
echo $num;
apptainer exec /data/SBCS-BuggsLab-Ash/DanielWood/docker_things/braker3_lr.sif braker.pl --species=$num --bam=$string2 --prot_seq=$orthodb --workingdir=$path --genome=$softmask_genome --threads=${NSLOTS};

