#!/bin.bash
#$ -cwd
#$ -pe smp 16
#$ -l h_rt=1:0:0
#$ -l rocky
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);


#vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/sniffles.vcf";
reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";

module load samtools/1.9;
bgzip -c $vcf > $vcf.bgzip.vcf.gz;
tabix -f $vcf.bgzip.vcf.gz;

#Note  - this uses a patch of vg that solved some (but not all) SV genotyping issues
#see https://github.com/vgteam/vg/issues/4443

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

$vg construct -S -a -r $reference -v $vcf.bgzip.vcf.gz > $vcf.PATCH.vg && echo "1 done";
$vg index --dist-name $vcf.vg.PATCH.dist $vcf.PATCH.vg && echo "2 done";
$vg index -L -x $vcf.PATCH.vg.xg $vcf.PATCH.vg && echo "3 done";
$vg gbwt --path-cover --xg-name $vcf.PATCH.vg.xg --output $vcf.PATCH.vg.gbwt && echo "4 done";
$vg gbwt --xg-name $vcf.PATCH.vg.xg --graph-name $vcf.PATCH.vg.gbz --gbz-format $vcf.PATCH.vg.gbwt && echo "5 done";

$vg minimizer --distance-index $vcf.vg.PATCH.dist --output-name $vcf.PATCH.vg.min $vcf.PATCH.vg.gbz && echo "6 done";
$vg snarls $vcf.PATCH.vg.xg > $vcf.PATCH.vg.xg.snarls;

