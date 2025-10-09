##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";

#FOR POOLS
#The list of pool short read files, excluding the technical replicate
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=6G
#$ -t ?
#$ -l rocky
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.t4t

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1); #Get pool name
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2); #R1 file
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);  #R2 file

#Nonused variable for the date
dat=$(date +%Y_%m_%d);

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#This should be commented out: I don't think makes it into final script
module load miniforge;
mamba activate /data/home/mpx545/conda_environments/graphviz2;

#vcf, which alongside some other previously generated files is used to map the pangenome
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf";

#FOR POOLS
#outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#
#For test set
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe";

mkdir $outdir/$name.PATCH.temp;

#Copies these files needed for giraffe to a file specified by the Pool name
cp $reference $outdir/$name.PATCH.temp/reference.fa
cp $vcf.bgzip.vcf.gz $outdir/$name.PATCH.temp/vcf.vcf.gz;
cp $vcf.PATCH.vg.min $outdir/$name.PATCH.temp/autoindex.min;
cp $vcf.vg.PATCH.dist $outdir/$name.PATCH.temp/autoindex.dist;
cp $vcf.PATCH.vg.gbz $outdir/$name.PATCH.temp/autoindex.giraffe.gbz;
cd $outdir/$name.PATCH.temp;

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";
#So the important thing here is that the output goes to $name.gam, e.g. Pool25.PATCH.gam
$vg giraffe --output-format gam --gbz-name autoindex.giraffe.gbz --minimizer-name autoindex.min --dist-name autoindex.dist -f $R1 -f $R2 -t ${NSLOTS} reference.fa vcf.vcf.gz > $outdir/$name.PATCH.temp/$name.PATCH.gam;

