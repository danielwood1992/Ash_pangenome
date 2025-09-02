#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules


reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
#Dummy variable vcf
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/reference_only";

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

$vg construct -S -a -r $reference > $vcf.PATCH.vg && echo "1 done";
$vg index --dist-name $vcf.PATCH.vg.dist $vcf.PATCH.vg && echo "2 done";
$vg index -L -x $vcf.PATCH.vg.xg $vcf.PATCH.vg && echo "3 done";
$vg gbwt --path-cover --xg-name $vcf.PATCH.vg.xg --output $vcf.PATCH.vg.gbwt && echo "4 done";
$vg gbwt --xg-name $vcf.PATCH.vg.xg --graph-name $vcf.PATCH.vg.gbz --gbz-format $vcf.PATCH.vg.gbwt && echo "5 done";
$vg minimizer --distance-index $vcf.PATCH.vg.dist --output-name $vcf.PATCH.vg.min $vcf.PATCH.vg.gbz && echo "6 done";

