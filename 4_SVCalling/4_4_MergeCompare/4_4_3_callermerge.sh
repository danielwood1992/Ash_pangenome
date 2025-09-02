###JOB_NUM##
#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt";
ARRAY_NUM=$(cat $names | wc -l);
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
truncate -s 0 $outdir/PG2_12_1_results.txt;

echo "Name Type Number" >> $outdir/PG2_12_1_results.txt;
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

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

file_list=$1;

SURVIVOR="/data/home/mpx545/SURVIVOR/Debug/SURVIVOR";
outdir="/data/scratch/mpx545/PG2_AshPanGenome";
results="PG2_12_1_results.txt";

sample_name=$(sed -n "${SGE_TASK_ID}p" $file_list | cut -f1);
base_name=$(echo $sample_name | rev | cut -f1 -d'/' | rev | cut -f1 -d'.');
echo $base_name;

sniffles_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/PG2_7_2_sniffles";
cutesv_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/PG2_7_5_cuteSV";
svim_asm_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_11_AssemblySVCalling/PG2_11_7_svim-asm";


cutesv_nums=$(grep -v '#' $cutesv | wc -l);
echo "$base_name cutesv $cutesv_nums" >> $outdir/${results};
cutesv="$cutesv_dir/$base_name.hap1.rmdpq20.bam.cuteSV.filt2.vcf";
ls $cutesv;

sniffles=$sniffles_dir/$base_name.hap1.rmdpq20.bam.hap1.sniffles.filt2.vcf

sniffles_nums=$(grep -v '#' $sniffles | wc -l);
ls $sniffles;
echo "$base_name sniffles $sniffles_nums" >> $outdir/${results};

svim=$svim_asm_dir/${base_name}.shasta.svim_asm/variants.vcf.filt3.vcf;

svim_nums=$(grep -v '#' $svim | wc -l);
ls $svim;
echo "$base_name svim_nums $svim_nums" >> $outdir/${results};

#mapping_merged=

#Functions...

export outdir=$outdir;
export base_name=$base_name;
export SURVIVOR=$SURVIVOR;
export results=$results;

comparison_function_septype(){
	#The same hopefully as the comparison_function, but separates things out by the type of 
	#SV so that they're not merged into each other (e.g. DEL and INS merged together)
	vcf1=$1;
	vcf2=$2;
	name=$3;
	echo $vcf1;
	echo $vcf2;
	echo $name;

	#From both vcfs gets the types into an array, my_types
	#mapfile -t array_name < < (some_command) produces an array, array_name, of the outputs. Neat.
	mapfile -t my_types < <( grep -v '#' $vcf1 $vcf2 | cut -f8 | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sort | uniq );



	#So for each of these, we will want to...
	for type in ${my_types[@]};
			#i) Just get the things of each type.
			do echo $type;
			grep "#\|SVTYPE=$type" $vcf1 > $vcf1.$type;
			grep "#\|SVTYPE=$type" $vcf2 > $vcf2.$type;

			#ii) Merge with SURVIVOR
			truncate -s 0 $outdir/$base_name.${results}.$name.$type.tmp;
			echo $vcf1.$type >>  $outdir/$base_name.${results}.$name.$type.tmp;
			echo $vcf2.$type >>  $outdir/$base_name.${results}.$name.$type.tmp;
			$SURVIVOR merge $outdir/$base_name.${results}.$name.$type.tmp 200 2 1 1 1 50 $outdir/$base_name.${results}.$name.$type.vcf;
	
	done;
	
	#Once these are done, will want to concat all the vcfs together to the final product.
	#Get header from the first vcf
	
	#Set up the file for the combinef vcf (with all types)
	truncate -s 0 $outdir/$base_name.${results}.$name.all_types.vcf.tmp; 
	truncate -s 0 $outdir/$base_name.${results}.$name.all_types.vcf; 

	#Note - this assumes the vcfs will have the same headers.
	#Will probably break later if this is a problem
	grep '#' $outdir/$base_name.${results}.$name.${my_types[0]}.vcf > $outdir/$base_name.${results}.$name.all_types.vcf;
	for type in ${my_types[@]};
		do grep -v '#' $outdir/$base_name.${results}.$name.$type.vcf >>  $outdir/$base_name.${results}.$name.all_types.vcf.tmp;
	done;
	sort -k1,1 -k2,2n $outdir/$base_name.${results}.$name.all_types.vcf.tmp >> $outdir/$base_name.${results}.$name.all_types.vcf;
	rm $outdir/$base_name.${results}.$name.all_types.vcf.tmp; 
 
}
export -f comparison_function_septype;


#So this merges the SVs of Sniffles2 and cuteSV, with each type of SV merged individually
comparison_function_septype $sniffles $cutesv "1_AND_2_bothreadmapping";

comparison_function_septype_OR(){
	#The same hopefully as the comparison_function, but separates things out by the type of 
	#SV so that they're not merged into each other (e.g. DEL and INS merged together)
	vcf1=$1;
	vcf2=$2;
	name=$3;
	echo $vcf1;
	echo $vcf2;
	echo $name;

	#From both vcfs gets the types into an array, my_types
	#mapfile -t array_name < < (some_command) produces an array, array_name, of the outputs. Neat.
	mapfile -t my_types < <( grep -v '#' $vcf1 $vcf2 | cut -f8 | sed 's/.*SVTYPE=//g' | sed 's/;.*//g' | sort | uniq );



	#So for each of these, we will want to...
	for type in ${my_types[@]};
			#i) Just get the things of each type.
			do echo $type;
			grep "#\|SVTYPE=$type" $vcf1 > $vcf1.$type;
			grep "#\|SVTYPE=$type" $vcf2 > $vcf2.$type;

			#ii) Merge with SURVIVOR
			truncate -s 0 $outdir/$base_name.${results}.$name.$type.tmp;
			echo $vcf1.$type >>  $outdir/$base_name.${results}.$name.$type.tmp;
			echo $vcf2.$type >>  $outdir/$base_name.${results}.$name.$type.tmp;
			$SURVIVOR merge $outdir/$base_name.${results}.$name.$type.tmp 200 1 1 1 1 50 $outdir/$base_name.${results}.$name.$type.vcf;
	
	done;
	
	#Once these are done, will want to concat all the vcfs together to the final product.
	#Get header from the first vcf
	
	#Set up the file for the combinef vcf (with all types)
	truncate -s 0 $outdir/$base_name.${results}.$name.all_types.vcf.tmp; 
	truncate -s 0 $outdir/$base_name.${results}.$name.all_types.vcf; 

	#Note - this assumes the vcfs will have the same headers.
	#Will probably break later if this is a problem
	grep '#' $outdir/$base_name.${results}.$name.${my_types[0]}.vcf > $outdir/$base_name.${results}.$name.all_types.vcf;
	for type in ${my_types[@]};
		do grep -v '#' $outdir/$base_name.${results}.$name.$type.vcf >>  $outdir/$base_name.${results}.$name.all_types.vcf.tmp;
	done;
	sort -k1,1 -k2,2n $outdir/$base_name.${results}.$name.all_types.vcf.tmp >> $outdir/$base_name.${results}.$name.all_types.vcf;
	rm $outdir/$base_name.${results}.$name.all_types.vcf.tmp; 
 
}
export -f comparison_function_septype_OR;

comparison_function_septype_OR $outdir/$base_name.$results."1_AND_2_bothreadmapping".all_types.vcf $svim "1_AND_2_OR_4";
