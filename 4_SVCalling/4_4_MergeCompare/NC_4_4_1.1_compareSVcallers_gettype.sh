#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

module load bcftools/1.19-gcc-12.2.0;

#Set progress tracking

#file_list=$1;
#outdir="/data/scratch/mpx545/PG2_AshPanGenome";
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_cantata_test/NC_4_4_1.1_results";

results="NC_4_4_1.1_ST_results.txt";

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

#DEL
for file in $svim_cantata $svim_ont_flye $svim_ont_nextdenovo $svim_ont_shasta $sniffles $cutesv;
	do bcftools view -i 'INFO/SVTYPE == "DEL"' $file > $file.DEL;
done;

#INS
for file in $svim_cantata $svim_ont_flye $svim_ont_nextdenovo $svim_ont_shasta $sniffles $cutesv;
	do bcftools view -i 'INFO/SVTYPE == "INS"' $file > $file.INS;
done;	

#INV
for file in $svim_cantata $svim_ont_flye $svim_ont_nextdenovo $svim_ont_shasta $sniffles $cutesv;
	do bcftools view -i 'INFO/SVTYPE == "INV"' $file > $file.INV;
done;	






