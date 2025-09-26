#!/bin.bash
#$ -cwd
#$ -t 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -tc 100
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#module load plink;

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf.update.vcf.plusSNPs.vcf";

module load plink/1.9-beta6.27-gcc-12.2.0;
plink --vcf $vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --r2 --ld-window-kb 1000 --ld-window 99999 --out $vcf.plink2.bigger --vcf-half-call missing --threads ${NSLOTS};

#For identifying SV vs. SNP, SNP vs. SNP and SV vs. SV LD differences...
tr -s ' ' '\t' < $vcf.plink2.bigger.ld > $vcf.plink2.bigger.ld.tab;
perl /data/home/mpx545/scripts/PG2_RealData/PG2_25_artificial_pool/sub_PG2_25_8.1_pairwiseLDpertype.pl $vcf.plink2.bigger.ld.tab; 
