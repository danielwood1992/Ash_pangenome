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

joint="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/PG2_22_2.combined.PG2_22_2.bcf";
bcftools query -f "%AF" $joint > $joint.AF;

#Overall for SAMPLE_12
for i in 12 14 15; do
	bcftools query -s ${i}:SAMPLE -f '%CHROM\t%POS\t[%GT]\n' $joint | awk '$3 == "0/1" || $3 == "1/1"' - | cut -f1,2 > $joint.SAMPLE_${i}.all;
	bcftools view -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf -R $joint.SAMPLE_${i}.all $joint;
	bcftools query -f "%AF" $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf.AF;
	bcftools query -s ${i}:SAMPLE -f "[%GT]" $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf |  sort | uniq -c > $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf.GT;

#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.all.vcf.NS;

	#Get GTs
#	bcftools query -s SAMPLE_${i} -f '[%GT]\n' $joint | awk '$1 != "./."' - | cut -f1 > $joint.SAMPLE_12.GTs;

#	bcftools query -s SAMPLE_${i} -f '%ID\t[%ID\t%GT]\n' $joint | awk '$2 != "NaN" && $3 == "0/1"' - | cut -f1 > $joint.SAMPLE_${i}.01.all;
#	bcftools view -i "ID=@${joint}.SAMPLE_${i}.01.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf;
#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.01.vcf.NS;

#	bcftools query -s SAMPLE_${i} -f '%ID\t[%ID\t%GT]\n' $joint | awk '$2 != "NaN" && $3 == "1/1"' - | cut -f1 > $joint.SAMPLE_${i}.11.all;
#	bcftools view -i "ID=@${joint}.SAMPLE_${i}.11.all" $joint -Ov -o $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf;
#	bcftools query -f '%NS' $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf > $joint.NC_4_4_1.3.SAMPLE_${i}.11.vcf.NS;
	
done
