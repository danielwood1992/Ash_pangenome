#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
module load bwa/0.7.17;
module load samtools/1.9;

#Set progress tracking
dat=$(date _%Y_%m_%d);

#Ok so this needs a nice name in position 0 (done) and the new nicename in position 3 in this new file (ok that's fine...);
#Defualt sort? 

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

#file_list=$1;
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#results=$outdir/PG2_12_3_results.txt;

results="PG2_12_3_ST_results.txt";

truncate -s 0 $outdir/$results;
echo "Name Type Number" > $outdir/$results;

base_name="cantata_PG2_12_1.1";

#Results from svim-asm called by mapping hap2 to BATG-1.0
svim_cantata="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/DW-S26.hap2.svim_asm/variants.vcf.filt3.vcf";

#Results from the individual SV calling methods
svim_ont_flye="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/DW-S26.flye.svim_asm/variants.vcf.filt3.vcf";
svim_ont_nextdenovo="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/DW-S26.nextdenovo.svim_asm/variants.vcf.filt3.vcf";
svim_ont_shasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/DW-S26.shasta.svim_asm/variants.vcf.filt3.vcf";

sniffles="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/PG2_7_2_sniffles/DW-S26_PGA5.hap1.rmdpq20.bam.hap1.sniffles.filt2.vcf";
cutesv="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/PG2_7_5_cuteSV/DW-S26_PGA5.hap1.rmdpq20.bam.cuteSV.filt2.vcf";


#Get number of SVs 
svim_cantata_nums=$(grep -v '#' $svim_cantata | wc -l);

cutesv_nums=$(grep -v '#' $cutesv | wc -l);
sniffles_nums=$(grep -v '#' $sniffles | wc -l);

svim_ont_shasta_nums=$(grep -v '#' $svim_ont_shasta | wc -l);
svim_ont_flye_nums=$(grep -v '#' $svim_ont_flye | wc -l);
svim_ont_nextdenovo_nums=$(grep -v '#' $svim_ont_nextdenovo | wc -l);

echo "$base_name 3S_svim_cantata $svim_cantata_nums" >> $outdir/${results};
echo "$base_name 4S_svim_ont_shasta $svim_ont_shasta_nums" >> $outdir/${results};
echo "$base_name 5S_svim_ont_flye $svim_ont_flye_nums" >> $outdir/${results};
echo "$base_name 6S_svim_ont_nextdenovo $svim_ont_nextdenovo_nums" >> $outdir/${results};

SURVIVOR="/data/home/mpx545/SURVIVOR/Debug/SURVIVOR";

echo "try this";
export outdir=$outdir;
export basename=$basename;
export SURVIVOR=$SURVIVOR;
export results=$results;
comparison_function(){

	vcf1=$1;
	vcf2=$2;
	name=$3
	
	truncate -s 0 $outdir/$base_name.${results}.$name.tmp;
	echo $vcf1 >>  $outdir/$base_name.${results}.$name.tmp;
	echo $vcf2 >>  $outdir/$base_name.${results}.$name.tmp;
#	Type doesn't matter
#	$SURVIVOR merge $outdir/$base_name.${results}.$name.tmp 200 2 0 1 1 1 $outdir/$base_name.${results}.$name.vcf;
#	Type does mater
	$SURVIVOR merge $outdir/$base_name.${results}.$name.tmp 200 2 1 1 1 50 $outdir/$base_name.${results}.$name.vcf;

	set_nums=$(grep -v '#' $outdir/$base_name.${results}.$name.vcf | wc -l);
	grep -v '#' $outdir/$base_name.${results}.$name.vcf | grep SVLEN | sed 's/.*SVLEN=//g' | sed 's/;.*//g' | sed 's/-//g' >> $outdir/${results}.$name.catlengths;
	grep -v '#' $outdir/$base_name.${results}.$name.vcf | grep SVTYPE | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sed 's/-//g' >> $outdir/${results}.$name.cattypes;
	echo "$base_name $name $set_nums" >> $outdir/${results};
	return;

}
export -f comparison_function;


comparison_function_OR(){

	vcf1=$1;
	vcf2=$2;
	name=$3
	
	truncate -s 0 $outdir/$base_name.${results}.$name.tmp;
	echo $vcf1 >>  $outdir/$base_name.${results}.$name.tmp;
	echo $vcf2 >>  $outdir/$base_name.${results}.$name.tmp;
#	Type doesn't matter
#	$SURVIVOR merge $outdir/$base_name.${results}.$name.tmp 200 1 0 1 1 1 $outdir/$base_name.${results}.$name.vcf;
#	Type does matter
	$SURVIVOR merge $outdir/$base_name.${results}.$name.tmp 200 1 1 1 1 50 $outdir/$base_name.${results}.$name.vcf;

	set_nums=$(grep -v '#' $outdir/$base_name.${results}.$name.vcf | wc -l);
	grep -v '#' $outdir/$base_name.${results}.$name.vcf | grep SVLEN | sed 's/.*SVLEN=//g' | sed 's/;.*//g' | sed 's/-//g' >> $outdir/${results}.$name.catlengths;
	grep -v '#' $outdir/$base_name.${results}.$name.vcf | grep SVTYPE | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sed 's/-//g' >> $outdir/${results}.$name.cattypes;
	echo "$base_name $name $set_nums" >> $outdir/${results};
	return;

}
export -f comparison_function_OR;




#1_2 - cutesv sniffles
comparison_function $sniffles $cutesv "ST_1_AND_2_bothreadmapping";
#1_2_3
comparison_function $svim_cantata $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf "ST_1_AND_2_AND_3S";
#1_2_4
comparison_function $svim_ont_shasta $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf "ST_1_AND_2_AND_4S";
#1_2_5
comparison_function $svim_ont_flye $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf "ST_1_AND_2_AND_5S";
#1_2_6
comparison_function $svim_ont_nextdenovo $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf "ST_1_AND_2_AND_6S";
#3_4 - cantata vs shasta
comparison_function $svim_cantata $svim_ont_shasta "ST_3S_AND_4S";
#3_5 - cantata vs flye
comparison_function $svim_cantata $svim_ont_flye "ST_3S_AND_5S";
#3_6 - cantata vs nextdenovo
comparison_function $svim_cantata $svim_ont_nextdenovo "ST_3S_AND_6S";

#Combined set...
comparison_function_OR $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf $svim_ont_shasta "ST_1_AND_2_OR_4S";
comparison_function_OR $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf $svim_ont_flye "ST_1_AND_2_OR_5S";  
comparison_function_OR $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf $svim_ont_nextdenovo "ST_1_AND_2_OR_6S";  

#comparison_function $outdir/$base_name.${results}.ST_1_AND_2_bothreadmapping.vcf $svim_ont_shasta "ST_1_AND_2_AND_4S";  

comparison_function $outdir/$base_name.${results}.ST_1_AND_2_OR_4S.vcf $svim_cantata "ST_B_1_AND_2_OR_4S_B_AND_3S";
comparison_function $outdir/$base_name.${results}.ST_1_AND_2_OR_5S.vcf $svim_cantata "ST_B_1_AND_2_OR_5S_B_AND_3S";
comparison_function $outdir/$base_name.${results}.ST_1_AND_2_OR_6S.vcf $svim_cantata "ST_B_1_AND_2_OR_6S_B_AND_3S";
