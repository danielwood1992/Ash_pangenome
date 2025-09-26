#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load bcftools/1.19-gcc-12.2.0;

fakepool_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/fake_pool_p0.1.PATCH.gam.snarls.PG2_15_2.filt.vcf";
bcftools query -f "%CHROM\t%POS\t%ID\t[%AD]\n" $fakepool_vcf > $fakepool_vcf.AD; 

joint_vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/test_set_individuals.txt.PG2_25_1.txt.rest.PATCH.PG2_25_5.1.SVs.tags.vcf.filt.vcf";

bcftools query -f "%CHROM\t%POS\t%ID\t%AF\n" $joint_vcf > $joint_vcf.AF;

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/8_Construction_InSilicoPool/8_2_insilicopool/sub_8_2_15_join.pl";

perl $sub $fakepool_vcf.AD $joint_vcf.AF;

out=$fakepool_vcf.AD.PG2_25_10.out;

#Getting the outlier SNPS from the GWAS - seeing how often these overlap
SV_P_e13="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe/PoolFileList.txt_notech.PATCH.joint.out.Supp7e.rmh.e13";
cut -f1-3 $SV_P_e13 | sed 's/A$//g' | awk -v FS='\t' 'NR == FNR {arr[$1 FS $2 FS $3] = 1; next} ($1 FS $2 FS $3) in arr' - $out > $out.e13
cut -f1-3 $SV_P_e13 | sed 's/A$//g' | awk -v FS='\t' 'NR == FNR {arr[$1 FS $2 FS $3] = 1; next} ($1 FS $2 FS $3) in arr' - $joint_vcf > $joint_vcf.e13




