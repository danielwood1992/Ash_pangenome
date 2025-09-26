##JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";

#This is just the same file but with the first one removed: i.e. so that the artificial pool isn't included in these stats
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt.rest";
truncate -s 0 $names.PATCH.PG2_8_6.2_statsummaryResults.txt; #Produces a stats summary file

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
#$ -e /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG0_ShortReadStuff/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#file_list=$names;
#SGE_TASK_ID=2;

file_list=$1;
name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
R1=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f2);
R2=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f3);


outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

#Set progress tracking

reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt.PG2_25_1.txt.rest";

#outdir="/data/scratch/mpx545/PG2_AshPanGenome";

#So instead of vg and bwa, let's compare vg_all and vg_ref

vg_all_results=$outdir/$name.PATCH.temp/$name.PATCH.gam.stats;
vg_ref_results=$outdir/$name.PATCH.refonly.temp/$name.PATCH.refonly.gam.stats;

ls $vg_all_results;
ls $vg_ref_results;

vg_all_aligned=$(grep "Total alignments" $vg_all_results | sed 's/.* //g');
vg_all_paired=$(grep "Total paired" $vg_all_results | sed 's/.* //g');
vg_all_proper_pairs=$(grep "Total properly paired" $vg_all_results | sed 's/.* //g')
vg_all_softclipped=$(grep "Softclips" $vg_all_results | cut -f2 -d' ');
vg_all_perfect=$(grep "perfect" $vg_all_results | sed 's/.* //g');
vg_all_alscore=$(grep "Alignment score" $vg_all_results | cut -f4 -d' '| sed 's/,//g');
vg_all_mapq=$(grep "Mapping quality" $vg_all_results | cut -f4 -d' '| sed 's/,//g');
vg_all_subs=$(grep "Substitutions" $vg_all_results | cut -f2 -d' ');

echo "$name vg_all proper_pair $vg_all_proper_pairs" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all paired $vg_all_paired" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all aligned $vg_all_aligned" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all softclips $vg_all_softclipped" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all perfect $vg_all_perfect" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all alscore $vg_all_alscore" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all mapq $vg_all_mapq" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_all subs $vg_all_subs" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;

vg_ref_aligned=$(grep "Total alignments" $vg_ref_results | sed 's/.* //g');
vg_ref_paired=$(grep "Total paired" $vg_ref_results | sed 's/.* //g');
vg_ref_proper_pairs=$(grep "Total properly paired" $vg_ref_results | sed 's/.* //g')
vg_ref_softclipped=$(grep "Softclips" $vg_ref_results | cut -f2 -d' ');
vg_ref_perfect=$(grep "perfect" $vg_ref_results | sed 's/.* //g');
vg_ref_alscore=$(grep "Alignment score" $vg_ref_results | cut -f4 -d' '| sed 's/,//g');
vg_ref_mapq=$(grep "Mapping quality" $vg_ref_results | cut -f4 -d' '| sed 's/,//g');
vg_ref_subs=$(grep "Substitutions" $vg_ref_results | cut -f2 -d' ');

echo "$name vg_ref proper_pair $vg_ref_proper_pairs" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref paired $vg_ref_paired" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref aligned $vg_ref_aligned" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref softclips $vg_ref_softclipped" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref perfect $vg_ref_perfect" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref alscore $vg_ref_alscore" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref mapq $vg_ref_mapq" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
echo "$name vg_ref subs $vg_ref_subs" >> $names.PATCH.PG2_8_6.2_statsummaryResults.txt;
