#!/bin/bash
#SBATCH -a 2
#SBATCH -t 240:0:0
#SBATCH --mem-per-cpu=7G
#SBATCH -e /gpfs/scratch/mpx545/PG0_ShortReadStuff/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG0_ShortReadStuff/joblog/%x.%A.%a.out.txt

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/NC_clair3_combined.noref.bcf";
module load plink/2.00a6LM;

#Use plink to identify unlinked SNPs, run a PCA
plink2 --bcf $vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --indep-pairwise 50 10 0.1 --bad-ld --out $vcf.LD --vcf-half-call 'm'
plink2 --bcf $vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --extract $vcf.LD.prune.in --make-bed --freq --out $vcf.LD --vcf-half-call 'm';
plink2 --bcf $vcf --read-freq $vcf.LD.afreq --double-id --allow-extra-chr --set-missing-var-ids @:# --extract $vcf.LD.prune.in --make-bed --pca 49 biallelic-var-wts --out $vcf.LD --vcf-half-call 'm';



