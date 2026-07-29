#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

hap2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap2-mb-hirise-c1e0t__01-11-2023__hic_output.fasta";

module load samtools;
samtools faidx $hap1;
samtools faidx $hap2;

hap1_23=$(cut -f2 $hap1.fai | sort -rn | head -n 23 | paste -sd+ | bc);
hap1_all=$(cut -f2 $hap1.fai | sort -rn | paste -sd+ | bc);
echo "$hap1_23 $hap1_all";
echo "scale=4; $hap1_23 / $hap1_all" | bc

hap1_23rd=$(cut -f2 $hap1.fai | sort -rn | head -n 23 | tail -n 1);
hap1_24th=$(cut -f2 $hap1.fai | sort -rn | head -n 24 | tail -n 1);

echo "scale=4; $hap1_24th / $hap1_23rd" | bc

hap2_23=$(cut -f2 $hap2.fai | sort -rn | head -n 23 | paste -sd+ | bc);
hap2_all=$(cut -f2 $hap2.fai | sort -rn | paste -sd+ | bc);
echo "$hap2_23 $hap2_all";
echo "scale=4; $hap2_23 / $hap2_all" | bc

hap2_23rd=$(cut -f2 $hap2.fai | sort -rn | head -n 23 | tail -n 1);
hap2_24th=$(cut -f2 $hap2.fai | sort -rn | head -n 24 | tail -n 1);

echo "scale=4; $hap2_24th / $hap2_23rd" | bc

