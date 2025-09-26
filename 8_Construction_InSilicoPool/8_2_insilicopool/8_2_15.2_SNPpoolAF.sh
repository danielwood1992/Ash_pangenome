#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt


module load bcftools/1.19-gcc-12.2.0;

fakepool_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/fake_pool_p0.1.PATCH.temp/fake_pool_p0.1.PATCH.surject.bam.tomerge2.vcf";

bcftools query -f "%CHROM\t%POS\t[%DP4]\n" $fakepool_vcf > $fakepool_vcf.DP4; 

joint_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SNPs.vcf.gz.filt.vcf.0.01.vcf";

bcftools query -f "%CHROM\t%POS\t%INFO/AF\n" $joint_vcf > $joint_vcf.AF;
#Note - there seems to be a bit commented out of this subfunction, with no corresponding bit of the script to give the AD. At the moment the commented out bit is not giving the alternate allele. I'm not sure why this is? 
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/8_Construction_InSilicoPool/8_2_insilicopool/sub_8_2_15.2_joinSNPs.pl";

perl $sub $fakepool_vcf.DP4 $joint_vcf.AF;

