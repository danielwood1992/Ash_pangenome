#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=24:0:0
#$ -l h_vmem=7G
#$ -l centos
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

#Load modules

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_28_1

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_17_surject";

bam_names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech.PATCH.bamlist.q20";

scaff_names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.fai";

sort -k2,2nr $scaff_names | cut -f1,2 > $scaff_names.sizeorder.txt2;

tail -n +30 $scaff_names.sizeorder.txt2 > $scaff_names.sizeorder.txt2.tmp;
awk '{print $1, 0, $2-1}' $scaff_names.sizeorder.txt2.tmp | sed "s/ /\t/g" > $scaff_names.sizeorder.txt2.rest;

names=$scaff_names.sizeorder.txt2.rest;
file_list=$names;

string=$( cat $bam_names | sed "s/\n/ /g");
echo $string;


reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";


#bam=$outdir/$name.surject.bam;

#1 Pileup
name="smaller_scaffolds.PATCH";
echo "samtools mpileup -l $names -B $string -d 8000 --fasta-ref $reference > $outdir/$name.allpop_surject.mpileup && echo 1 done"; 

samtools mpileup -l $names -B $string -d 8000 --fasta-ref $reference -A  > $outdir/$name.allpop_surject.q20.mpileup && echo "1 done"; 

#2 - to sync format...
java -ea -Xmx25g -jar /data/home/mpx545/popoolation2_1201/mpileup2sync.jar --input $outdir/$name.allpop_surject.q20.mpileup --output $outdir/$name.allpop_surject.q20.sync --min-qual 20 --threads ${NSLOTS} && echo "2 done";

