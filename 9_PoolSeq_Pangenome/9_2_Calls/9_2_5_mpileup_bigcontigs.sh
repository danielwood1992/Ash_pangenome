##JOB_NUM##
#KPG0_2



reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";

dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_17_surject";


bam_names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech.PATCH";
cut -f1 $bam_names > $bam_names.bamlist.q20;
sed -i "s%^%$dir/%g" $bam_names.bamlist.q20;
sed -i "s/$/.PATCH.surject.q20.bam/g" $bam_names.bamlist.q20;
bam_names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech.PATCH.bamlist.q20";

scaff_names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.fai";
sort -k2,2nr $scaff_names | cut -f1 > $scaff_names.sizeorder.txt;

head -n 30 $scaff_names.sizeorder.txt > $scaff_names.sizeorder.txt_temp;

names=$scaff_names.sizeorder.txt_temp;
ARRAY_NUM=$(cat $names | wc -l);

#Note - this gives two sets of files to each of the array jobs: the list of pooled individuals, and the list of all the chromosomes. One array job per "chromosome" (the top 30 contigs: these get merged later)

ARRAY_NUM="$ARRAY_NUM $names $bam_names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=72:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

#NOTE: For some reason this gives a red job not completed output, but as far as I can tell the jobs have completed

file_list=$1;
bam_names=$2;

string=$( cat $bam_names | sed "s/\n/ /g");
echo $string;

name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
echo $name;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_17_surject";


reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#1 Pileup

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_28_1

#module load samtools/1.9;

samtools mpileup -r $name -B $string -d 8000 --fasta-ref $reference -A > $outdir/$name.PATCH.allpop_surject.q20.mpileup && echo "1 done"; 

#2 - using popoolation2, conver to sync format...

java -ea -Xmx30g -jar /data/home/mpx545/popoolation2_1201/mpileup2sync.jar --input $outdir/$name.PATCH.allpop_surject.q20.mpileup --output $outdir/$name.PATCH.allpop_surject.q20.sync --min-qual 20 --threads ${NSLOTS} && echo "2 done";

