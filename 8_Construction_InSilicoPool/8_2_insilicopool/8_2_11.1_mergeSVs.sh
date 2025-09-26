#!/bin.bash
#$ -cwd
#$ -pe smp 16
#$ -l h_rt=1:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt.rest";
cp $names $names.PATCH;
names=$names.PATCH;
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

string1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool/";
string2=".PATCH.gam.snarls.PG2_15_2.vcf.gz";

cut -f1 $names | sed -e "s@.*@$string1&$string2@" > $names.SVs.vcfs;

module load bcftools/1.19-gcc-12.2.0

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

base=$(echo $names | rev | cut -f1 -d/ | rev);
echo $base;

bcftools merge --force-samples --gvcf $genome --file-list $names.SVs.vcfs -Oz -o $outdir/$base.PG2_25_5.1.SVs.vcf.gz --threads ${NSLOTS} && bcftools index $outdir/$base.PG2_25_5.1.SVs.vcf.gz;
bcftools view -Ov -o $outdir/$base.PG2_25_5.1.SVs.vcf $outdir/$base.PG2_25_5.1.SVs.vcf.gz;
bcftools view $outdir/$base.PG2_25_5.1.SVs.vcf | bcftools +fill-tags - -- -t all | bcftools view -Ov -o $outdir/$base.PG2_25_5.1.SVs.tags.vcf -;

bcftools query -f '%INFO/MAF\t%INFO/HWE\n' $outdir/$base.PG2_25_5.1.SVs.tags.vcf > $outdir/$base.PG2_25_5.1.SVs.tags.vcf.stats;
