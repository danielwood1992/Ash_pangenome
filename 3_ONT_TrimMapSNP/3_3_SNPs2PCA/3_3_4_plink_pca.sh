#!/bin.bash
#$ -cwd
#$ -t 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load plink; #Unspecified version - worked out as Plink2 v2.00a3.3LM

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/PG2_22_2.combined.PG2_22_2.noref.filt2.vcf";

#Use plink to identify unlinked SNPs, run a PCA
plink2 --vcf $vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --indep-pairwise 50 10 0.1 --bad-ld --out $vcf.LD
plink2 --vcf $vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --extract $vcf.LD.prune.in --make-bed --freq --out $vcf.LD;
plink2 --vcf $vcf --read-freq $vcf.LD.afreq --double-id --allow-extra-chr --set-missing-var-ids @:# --extract $vcf.LD.prune.in --make-bed --pca 49 biallelic-var-wts --out $vcf.LD;

