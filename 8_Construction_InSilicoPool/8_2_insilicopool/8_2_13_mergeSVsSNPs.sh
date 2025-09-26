#!/bin.bash
#$ -cwd
#$ -t 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load bcftools/1.19-gcc-12.2.0;

#Filt
vcf1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf";
vcf2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SNPs.vcf.gz.filt.vcf.0.01.vcf";


module load htslib/1.19.1-gcc-12.2.0;

#Need to rename the SV sample names so they're the same as the SNP ones...
bcftools view -h $vcf1 | grep "#CHROM" | sed "s/.*FORMAT\t//g" | sed "s/\t/\n/g" > $vcf1.names;
bcftools view -h $vcf2 | grep "#CHROM" | sed "s/.*FORMAT\t//g" | sed "s/\t/\n/g" > $vcf2.names;
paste $vcf1.names $vcf2.names > $vcf1.names.2update;
bcftools reheader -s $vcf1.names.2update -o $vcf1.update.vcf $vcf1;
vcf1=$vcf1.update.vcf;


bcftools view -Oz -o $vcf1.gz $vcf1;
bcftools view -Oz -o $vcf2.gz $vcf2;
tabix -p vcf $vcf1.gz;
tabix -p vcf $vcf2.gz;

bcftools concat -a -Ov -o $vcf1.plusSNPs.vcf $vcf1.gz $vcf2.gz;
