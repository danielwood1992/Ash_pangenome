##JOB_NUM##


#PG2_20_2
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation"
head -n 1 $names > $names.head1;
names=$names.head1;
#tail -n+2 $names > $names.head2;
#names=$names.head2;


ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Testing BRAKER3 installation..
export BRAKER_SIF="/data/home/mpx545/docker_stuff/braker3.sif";
braker_dir="/data/home/mpx545/docker_stuff";
cd $braker_dir;

file_list=$1;

name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);


outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";
fasta="${outdir}/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta";

#Need to get the strings for...
#i) Short read bams
#ls $fasta;
short_reads=$fasta.dir;

list=$(echo $(ls $short_reads/*sortedByCoord.out.bam) | sed 's/ /,/g');
#echo $list;
string1=$list;

#This can stay the same
orthodb="/data/home/mpx545/Viridiplantae.fa";

#Output directory for the annotation for each individual
path="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation/PG2_4_4_2/$name.PG2_4_4_5";

haplotype="hap1";
dirbase="$outdir/PG2_20_4_1.$name.PG2_4_3.3";
genome_dir=$dirbase.repeatmask.RepeatMod_plus_Laura.noLowSoftMask.$haplotype;
softmask_genome=$genome_dir/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept.vcf_lines.bed.mod.fasta.masked;

#Sanity check - do these files exist
#ls $genome_dir;
#ls $softmask_genome;

#Running the actual BRAKER pipeline

rm -r $path;
mkdir $path;
#Long filename potentially causes GeneMark-ETP error - copy fasta to path
cp $softmask_genome $path/soft.fa;
#softmask_genome=$path/soft.fa

echo $string1;

dat=$(date +%Y_%m_%d);
echo "singularity exec /data/home/mpx545/docker_stuff/braker3.sif braker.pl --species=FraxExcelsior.$dat --bam=$string1,$string2 --prot_seq=$orthodb --threads=16 --workingdir=$path --genome=$softmask_genome";

#Using the individual bams, protein sequence database, masking info, does annotation with BRAKER3
singularity exec /data/home/mpx545/docker_stuff/braker3.sif braker.pl --species=$name.species --bam=$string1 --prot_seq=$orthodb --threads=${NSLOTS} --workingdir=$path --genome=$softmask_genome --useexisting;

