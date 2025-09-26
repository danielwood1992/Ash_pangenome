##JOB_NUM##
#KPG0_2

#For this file structure, see qarray.sh README.txt

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";

#Fake Pool sample
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt";

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##

#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=96:0:0
#$ -l h_vmem=6G
#$ -t ?
#$ -l rocky
#$ -tc 100
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.t4t

#So this script generates .gam files from mapping the read pairs to the pangenome


#Here $1 is the $names file above. Each job within the array uses a different line in the input file,
#specified by SGE_TASK_ID. So unless a different value of this enters the script, I don't see how
#you could get the different pools being swapped around
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1); #Get pool name
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2); #R1 file
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);  #R2 file


#Nonused variable for the date
dat=$(date +%Y_%m_%d);

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";
#rm -r $outdir/$name.temp;
mkdir $outdir/$name.PATCH.refonly.temp;
outdir=$outdir/$name.PATCH.refonly.temp;

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

#This specifies that this is the referecne only pangenome
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/reference_only";
cd $outdir;
cp $reference $outdir/reference.fa
cp $vcf.bgzip.vcf.gz $outdir/vcf.vcf.gz;
cp $vcf.PATCH.vg.min $outdir/autoindex.min;
cp $vcf.PATCH.vg.dist $outdir/autoindex.dist;
cp $vcf.PATCH.vg.gbz $outdir/autoindex.giraffe.gbz;


#Maps individual files (and fakepool files) to  ref only pangenome; produces stats
$vg giraffe --output-format gam --gbz-name autoindex.giraffe.gbz --minimizer-name autoindex.min --dist-name autoindex.dist -f $R1 -f $R2 -t ${NSLOTS} reference.fa  > $outdir/$name.PATCH.refonly.gam;
$vg stats -a $outdir/$name.PATCH.refonly.gam > $outdir/$name.PATCH.refonly.gam.stats;
