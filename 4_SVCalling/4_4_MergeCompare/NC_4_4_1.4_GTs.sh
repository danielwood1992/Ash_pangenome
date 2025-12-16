#!/bin.bash
#$ -cwd
#$ -pe smp 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Purpose:
#Get SVs that are called by the chosen method (cuteSV + Sniffles2) AND/OR (shasta-svim-asm), but not called by hap2+svim-asm

module load bcftools/1.19-gcc-12.2.0
joint="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames";

#Overall for SAMPLE_12
for i in {12..14}; do
	echo "woof";
#	bcftools query -s SAMPLE_${i} -f '%ID\t[%ID]\n' $joint | awk '$2 != "NaN"' - | cut -f1 > $joint.SAMPLE_${i}.all;
#	bcftools view -i "ID=@${joint}.SAMPLE_${i}.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf;

#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf.NS;

	#Get GTs
#	bcftools query -s SAMPLE_${i} -f '[%GT]\n' $joint | awk '$1 != "./."' - | cut -f1 > $joint.SAMPLE_12.GTs;

#	bcftools query -s SAMPLE_${i} -f '%ID\t[%ID\t%GT]\n' $joint | awk '$2 != "NaN" && $3 == "0/1"' - | cut -f1 > $joint.SAMPLE_${i}.01.all;
#	bcftools view -i "ID=@${joint}.SAMPLE_${i}.01.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf;
#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf.NS;

#	bcftools query -s SAMPLE_${i} -f '%ID\t[%ID\t%GT]\n' $joint | awk '$2 != "NaN" && $3 == "1/1"' - | cut -f1 > $joint.SAMPLE_${i}.11.all;
#	bcftools view -i "ID=@${joint}.SAMPLE_${i}.11.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf;
#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf.NS;
	

#	bcftools query -s SAMPLE_${i} -f '[%ID\t%GT]\n' $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf | sed 's/\..*\t/\t/g' | sort | uniq -c > $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf.ID_GT;

done

bcftools query -s SAMPLE_12,SAMPLE_13 -f '[%GT]t' $joint | awk '$1 != "./." && $2 != "./."' - | sort | uniq -c > $joint.SAMPLE_12_13.GTs;
bcftools query -s SAMPLE_13,SAMPLE_19 -f '[%GT]\t' $joint | awk '$1 != "./." && $2 != "./."' - | sort | uniq -c > $joint.SAMPLE_13_19.GTs;



#/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/PG2_22_2.combined.PG2_22_2.noref.filt1.vcf
