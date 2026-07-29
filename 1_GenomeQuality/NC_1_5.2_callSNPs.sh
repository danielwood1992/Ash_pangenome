##JOB_NUM##

#names="/data/home/mpx545/scripts/PG2_RealData/PG2_29_IDBATG/bam_list";
#names="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/1_GenomeQuality/bam_names.txt";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.5";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##
#!/bin/bash
#SBATCH -n 4
#SBATCH -t 240:0:0
#SBATCH --array=?
#SBATCH --mem-per-cpu=5G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
bam_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f1);

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta";

#module load samtools/1.19.2-python-3.12.1-gcc-12.2.0
#samtools stats $bam > $bam.PG2_29.stats;

module load bcftools/1.19-gcc-12.2.0
bcftools mpileup --gvcf 20000 -Ou -f $genome $bam_name | bcftools call -Ou -m --gvcf 2000 | bcftools norm -m +any --fasta-ref $genome | bcftools +fill-tags -- -t all | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<5" | bcftools view - -Ob -o $bam_name.SNPs.bcf;
bcftools index $bam_name.SNPs.bcf;
bcftools query -f '[%GT]' $bam_name.SNPs.bcf | sort | uniq -c > $bam_name.SNPs.gts;


