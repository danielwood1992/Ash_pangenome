#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=48:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

string1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/";
string2=".PATCH.surject.bam.tomerge2.vcf.gz";
cut -f1 $names | sed -e "s@.*@$string1&.PATCH.temp/&$string2@" > $names.SNPs.vcfs;

while read file; do ls $file; done < $names.SNPs.vcfs;


genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

base=$(echo $names | rev | cut -f1 -d/ | rev);
echo $base;

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_25_6.2

bcftools merge --force-samples --gvcf $genome --file-list $names.SNPs.vcfs -Oz -o $outdir/$base.PG2_25_5.1.SNPs.vcf.gz --threads ${NSLOTS} && bcftools index $outdir/$base.PG2_25_5.1.SNPs.vcf.gz;
