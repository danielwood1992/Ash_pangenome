#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Purpose:
#Get SVs that are called by the chosen method (cuteSV + Sniffles2) AND/OR (shasta-svim-asm), but not called by hap2+svim-asm

chosen="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/DW-S26_PGA5.PG2_12_1_results.txt.1_AND_2_OR_4.all_types.vcf";
hap2_calls="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/DW-S26.hap2.svim_asm/variants.vcf.filt3.vcf";

truncate -s 0 $chosen.list;
ls $chosen >> $chosen.list;
ls $hap2_calls >> $chosen.list;
name_list=$chosen.list;

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
SURVIVOR="/data/home/mpx545/SURVIVOR/Debug/SURVIVOR";

results="DW-S26_chosen.AND.Cantata";

truncate -s 0 $outdir/$results;

#List of names to merge (in 3_ONT_TrimMapSNP)

cp $name_list $name_list.AND.vcfs;

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
	$SURVIVOR merge $outdir/$results.$type.vcf_list 200 2 1 1 1 50 $outdir/$results.$type.vcf;
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

#So samples with cantata is...
cp $outdir/$results.all_types.tags.vcf /data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge

#So then we have this...
chosen_and_cantata="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/DW-S26_chosen.AND.Cantata.all_types.tags.vcf";
#And what we need I guess is to idetntify ones in this list, and ones not in this list...

module load bcftools/1.19-gcc-12.2.0
bcftools query -s SAMPLE -f '[%ID]\n' $chosen_and_cantata > $chosen_and_cantata.chosen_ids
#These should be unique...
#...they aren't unique. Why aren't they unique?
joint="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.filt1";
bcftools query -s SAMPLE_12 -f '%ID\t[%ID]\n' $joint | awk 'NR==FNR {ids[$0]; next} $2 in ids' $chosen_and_cantata.chosen_ids - | cut -f1 > $joint.2keep;
bcftools view -i "ID=@${joint}.2keep" $joint -Ov -o $joint.NC_4_4_1.3.kept.vcf;
bcftools query -f '%NS' $joint.NC_4_4_1.3.kept.vcf > $joint.NC_4_4_1.3.kept.vcf.NS;

#Getting the samples that aren't in both...
bcftools query -s SAMPLE_12 -f '%ID\t[%ID]\n' $joint | awk 'NR==FNR {ids[$0]; next} ($2 != "NaN" && !($2  in ids))' $chosen_and_cantata.chosen_ids - | cut -f1 > $joint.2exclude;
bcftools view -i "ID=@${joint}.2exclude" $joint -Ov -o $joint.NC_4_4_1.3.excluded.vcf;
bcftools query -f '%NS' $joint.NC_4_4_1.3.excluded.vcf > $joint.NC_4_4_1.3.excluded.vcf.NS;
bcftools query -f '%NS' $joint > $joint.NC_4_4_1.3.NS;

#Overall for SAMPLE_12
bcftools query -s SAMPLE_12 -f '%ID\t[%ID]\n' $joint | awk '$2 != "NaN"' - | cut -f1 > $joint.SAMPLE_12.all;
bcftools view -i "ID=@${joint}.SAMPLE_12.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_12.all.vcf;
bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_12.all.vcf > $joint.NC_4_4_1.3.SAMPLE_12.all.vcf.NS;
#Get GTs
bcftools query -s SAMPLE_12 -f '[%GT]\n' $joint | awk '$1 != "./."' - | cut -f1 > $joint.SAMPLE_12.GTs;

#Overall for SAMPLE_13
bcftools query -s SAMPLE_13 -f '%ID\t[%ID]\n' $joint | awk '$2 != "NaN"' - | cut -f1 > $joint.SAMPLE_13.all;
bcftools view -i "ID=@${joint}.SAMPLE_13.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_13.all.vcf;
bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_13.all.vcf > $joint.NC_4_4_1.3.SAMPLE_13.all.vcf.NS;
bcftools query -s SAMPLE_13 -f '[%GT]\n' $joint | awk '$1 != "./."' - | cut -f1 > $joint.SAMPLE_13.GTs;

#Overall for SAMPLE_14
bcftools query -s SAMPLE_14 -f '%ID\t[%ID]\n' $joint | awk '$2 != "NaN"' - | cut -f1 > $joint.SAMPLE_14.all;
bcftools view -i "ID=@${joint}.SAMPLE_14.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_14.all.vcf;
bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_14.all.vcf > $joint.NC_4_4_1.3.SAMPLE_14.all.vcf.NS;
bcftools query -s SAMPLE_14 -f '[%GT]\n' $joint | awk '$1 != "./."' - | cut -f1 > $joint.SAMPLE_14.GTs;
