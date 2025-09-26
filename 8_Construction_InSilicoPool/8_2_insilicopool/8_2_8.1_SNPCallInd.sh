##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
#Excluding the in silico pool
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt.rest";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -t ?
#$ -l rocky
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt


file_list=$1;

name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/$name.PATCH.temp";
cd $outdir;

bam_name=$outdir/$name.PATCH.surject.bam

#module load bcftools/1.19-gcc-12.2.0
#module load miniforge;
#mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_28_4.2

ls $bam_name;

bcftools mpileup --gvcf 20 -Ou -f $genome $bam_name | bcftools call -Ou -m --gvcf 20 | bcftools norm -m +any --fasta-ref $genome | bcftools +fill-tags -- -t all | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<5 || FMT/DP>50" | bcftools view - -Ob -o $bam_name.tomerge2.bcf && echo $bam_name Complete >> $file_list.PG0_3.Progress;
bcftools view -Oz -o $bam_name.tomerge2.vcf.gz $bam_name.tomerge2.bcf;
bcftools index $bam_name.tomerge2.vcf.gz;
bcftools view -Ov -o $bam_name.tomerge2.vcf $bam_name.tomerge2.vcf.gz;

module load miniforge;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/PG2_25_6.2
bcftools view $bam_name.tomerge2.vcf | vcfrandomsample -r 0.01 > $bam_name.tomerge2.0.01.vcf;

