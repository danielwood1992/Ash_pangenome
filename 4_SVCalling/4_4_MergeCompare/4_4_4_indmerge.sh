#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
SURVIVOR="/data/home/mpx545/SURVIVOR/Debug/SURVIVOR";

results="complete_merged_PG2_12_2.all_types";

truncate -s 0 $outdir/$results;

#List of names to merge (in 3_ONT_TrimMapSNP)
name_list="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica";

cat $name_list | sed 's/^.*\///g' | sed 's/\..*//g' | sed 's/$/.PG2_12_1_results.txt.1_AND_2_OR_4.all_types.vcf/g' | sed 's/^/\/data\/scratch\/mpx545\/PG2_AshPanGenome\//g' > $name_list.AND.vcfs;

echo "mapfile -t my_types < <(cat $name_list.AND.vcfs | xargs grep -v '#' --no-filename | cut -f8 | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sort | uniq);";
mapfile -t my_types < <( cat $name_list.AND.vcfs | xargs grep -v '#' --no-filename | cut -f8 | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sort | uniq );

#For each type...
for type in ${my_types[@]};
	do echo $type;
#	#So for each of the vcfs...
#	#Need to get a new list of vcfs, each with the appropriate type	
	truncate -s 0 $outdir/$results.$type.vcf_list;
#
	while read vcf;
		do $echo $file;
		grep "#\|SVTYPE=$type" $vcf > $vcf.$type && echo $vcf.$type >> $outdir/$results.$type.vcf_list;
	done < $name_list.AND.vcfs;
#
	truncate -s 0 $outdir/$results.$type.vcf;
	$SURVIVOR merge $outdir/$results.$type.vcf_list 200 1 1 1 1 50 $outdir/$results.$type.vcf;
#
done;

truncate -s 0 $outdir/$results.all_types.vcf;
truncate -s 0 $outdir/$results.all_types.vcf.temp;

#Get header for combined file
grep '#' $outdir/$results.${my_types[0]}.vcf > $outdir/$results.all_types.vcf;

#For each type, add the combined files together
for type in ${my_types[@]};
	do grep -v '#' $outdir/$results.$type.vcf >>  $outdir/$results.all_types.vcf.temp
done;

#Sort by chrom then coordinate, then add to final vcf file
sort -k1,1 -k2,2n $outdir/$results.all_types.vcf.temp >> $outdir/$results.all_types.vcf;

module load bcftools; #Version of bcftools not specified
bcftools +fill-tags $outdir/$results.all_types.vcf -Ov -o $outdir/$results.all_types.tags.vcf -- -t all;

#rm $outdir/$results.all_types.vcf.tmo

