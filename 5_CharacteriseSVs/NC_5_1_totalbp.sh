###JOB_NUM##
#KPG0_2

#This script is taking the potential "maf" (although really it's the minimum number of samples an SV is called in) as listed in num_array.txt, and then producing i) a vcf of these, and then also PG2_13_1_results.txt and PG2_13_1_results.txt.nums 

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_13_characteriseSVvcf/num_array.txt";
#This is just a list of numberi 1-50
ARRAY_NUM=$(cat $names | wc -l);
outdir="/data/scratch/mpx545/PG2_AshPanGenome";

truncate -s 0 $outdir/PG2_13_1_results.txt;
truncate -s 0 $outdir/PG2_13_1_results.txt.nums;

#echo "Name Type Number" >> $outdir/PG2_13_1_results_200plus.txt;
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

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);

outdir="/data/scratch/mpx545/PG2_AshPanGenome";

file=$1;

maf=$(sed -n "${SGE_TASK_ID}p" $file | cut -f1); 

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.filt1";

echo $string;
module load bcftools/1.16;
#for each value of N_sampls, produces a vcf with that number of samples in it for characterisation
bcftools view -i "NS > $maf" -o $outdir/complete_merged_PG2_12_2.all_types.all_types.tags.$maf.vcf $vcf;

#This subfunction
#Takes vcf, MAF, max length: #I don't really know why it has an arbirtarily long maximum length
#Outputs the MAF\tSVType\tTotalLength, adds this to summary file
sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/5_CharacteriseSVs/sub_5_1_lengths.pl";
perl $sub $outdir/complete_merged_PG2_12_2.all_types.all_types.tags.$maf.vcf $maf 10000000000000000 >> $outdir/PG2_13_1_results.txt;

#This just gets, for each SV type, the total number of variants for that MAF and adds it to a summary file`
grep -v '#' $outdir/complete_merged_PG2_12_2.all_types.all_types.tags.$maf.vcf | sed 's/^.*SVTYPE=//' | sed 's/;.*//g' | sort | uniq -c | perl -p -i -e 's/^ +//g' | awk -v var=$maf -v OFS=' ' '{print $2,$1,var}' >> $outdir/PG2_13_1_results.txt.nums;
