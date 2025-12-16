###JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.AND.vcfs";
head -n 25 $names | tail -n 2 > $names.test2;
names=$names.test2;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

file_list=$1;

vcf=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
#So we should try and output 16 insertions, 16 deletions, 10 inversions and 10 tandem duplications...
#8 from cuteSV+Sniffles, 8 from svim-asm, 5 and 5 respectively...
echo "grep -v '#' $vcf | awk '$3 ~ /svim_asm\.INS/' | shuf -n 8 > $vcf.svim_asm.INS.NC_4_4_5;"

truncate -s 0 $vcf.SUBSET.NC_4_4_5;

grep -v '#' $vcf | awk '$3 ~ /svim_asm\.INS/' | shuf -n 8 > $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /svim_asm\.DEL/' | shuf -n 8 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /svim_asm\.INV/' | shuf -n 5 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /svim_asm\.DUP_INT/' | shuf -n 5 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /svim_asm\.DUP_TANDEM/' | shuf -n 5 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /cuteSV\.DEL/' | shuf -n 8 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /cuteSV\.INS/' | shuf -n 8 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /cuteSV\.INV/' | shuf -n 5 >> $vcf.SUBSET.NC_4_4_5;
grep -v '#' $vcf | awk '$3 ~ /cuteSV\.DUP/' | shuf -n 5 >> $vcf.SUBSET.NC_4_4_5;

#So I guess for each of these insertions we will then need to extract nearby reads, do local hifiasm assemblies, and then...do that dotplot stuff? Or maybe Dario's stuff. 


