#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=4G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Ok so what do we need...

vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1";
module load bcftools;
bcftools query -f '[\t%GT]\n' $vcf | sed 's/^\t//g' > $vcf.PG2_13_5.3.txt;

a=$(wc -l $vcf.PG2_13_5.3.txt | cut -f1 -d' '); #Total number of variants
truncate -s 0 $vcf.PG2_13_5.3.txt.out;

#So this should...remove any lines that are completely missing data. total lines minus this should be the number of SVs called, right?

#string1=$(shuf -i 1-50 | tr '\n' '$' | sed 's/\$/,\$/g' | sed 's/^/\$/g' | sed 's/,\$$//g');
#string2="awk '{print $string1}'  $vcf.PG2_13_5.3.txt.out | head > woof";

echo $string2;
eval $string2;

for j in {1..20};
	#Generates a command, string 1: takes a random number between 1 and 50, 
	#I think this is getting a random order of genotypes, then generating this from the input GT file
	do string1=$(shuf -i 1-50 | tr '\n' '$' | sed 's/\$/,\$/g' | sed 's/^/\$/g' | sed 's/,\$$//g');
	string2="awk '{print $string1}' $vcf.PG2_13_5.3.txt | sed 's/ /\t/g' > $vcf.PG2_13_5.3.txt.$j";
	eval $string2;
	#Then for each of these randomly shuffled files...
	for i in {50..1};
		#So for i, this is doing cut -f 50-, cut -f 49- etc. which should take just 50, 50+49 etc.
		do b=$(cut -f "$((i))-" $vcf.PG2_13_5.3.txt.$j | grep -v '0\|1' | wc -l); #This is removing heterozygous calls for some reason...? Why? These aren't excluded later, are they? Or removing...any line with a seemingly phased heterozygous call?
			#But why? Why are these in there?
		num=$(echo "$a - $b" | bc);
		k=$(echo "51 - $i" | bc);
		echo $j $k $num >> $vcf.PG2_13_5.3.txt.out;
	done;
done;

