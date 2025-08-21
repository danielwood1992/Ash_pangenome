#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";
string1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/"
string2=".hap1.rmdpq20.bam.tomerge.bcf";

#cut -f1 $names | sed -e "s@.*@$string1&$string2@" > $names.PG2_22_2.vcfs;
awk -v string1=$string1 -v string2=$string2 '{print string1 $0 string2}' $names > $names.PG2_22_2.vcfs;

module load bcftools; #bcftools version not specified - paper specified this as v1.16

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
base="PG2_22_2.combined";

#Merge individual vcfs
bcftools merge --force-samples --gvcf $genome --file-list $names.PG2_22_2.vcfs -Ob -o $outdir/$base.PG2_22_2.bcf --threads ${NSLOTS} && bcftools index $outdir/$base.PG2_22_2.bcf;

vcf=$outdir/$base.PG2_22_2.bcf

#Removing the reference sample: filtering
bcftools view --samples "^13:SAMPLE" $vcf | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<8 | FMT/DP > 60" | bcftools +fill-tags - -- -t all | bcftools view -m2 -M2 -v snps -i 'F_MISSING < 0.1' -Ob -o $outdir/$base.PG2_22_2.noref.filt1.bcf;
bcftools view -i 'MAF > 0.05' $outdir/$base.PG2_22_2.noref.filt1.bcf -Ov -o $outdir/$base.PG2_22_2.noref.filt2.vcf;
