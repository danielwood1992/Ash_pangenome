#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=24:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#min_count="15"; - so this is the MAC across all the pools. 
#min_coverage="40"; - this is the per-pool minimum coverage
#max_coverage="200"; - this is the per-pool maximum coverage...

module load bcftools/1.19-gcc-12.2.0;

SV_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf";

bcftools view $SV_vcf | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<5 | FMT/DP > 50" | bcftools +fill-tags - -- -t all | bcftools view -i 'F_MISSING < 0.1 & MAF > 0.05' -Ov -o $SV_vcf.filt.vcf;

bcftools query -f "%INFO/MAF\t%INFO/HWE\n" $SV_vcf.filt.vcf > $SV_vcf.filt.vcf.stats;

SNP_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SNPs.vcf.gz";

bcftools view -m2 -M2 -v snps $SNP_vcf | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<5 | FMT/DP > 50" | bcftools +fill-tags - -- -t all | bcftools view -i 'F_MISSING < 0.1 & MAF > 0.05' -Ov -o $SNP_vcf.filt.vcf;

bcftools query -f "%INFO/MAF\t%INFO/HWE\n" $SNP_vcf.filt.vcf > $SNP_vcf.filt.vcf.stats;

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/vcflib;

bcftools view $SNP_vcf.filt.vcf | vcfrandomsample -r 0.01 > $SNP_vcf.filt.vcf.0.01.vcf;

bcftools query -f "%INFO/MAF\t%INFO/HWE\n" $SNP_vcf.filt.vcf.0.01.vcf > $SNP_vcf.filt.vcf.0.01.vcf.stats;
