##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica";
#head -n 1 $names > $names.1;
#names=$names.1;
dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";

chunk_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/10mb_chunks.txt";
while read chunk;
	do chunk_name=$(basename "$chunk");
	truncate -s 0 "$dir2/${chunk_name}_list.txt";
done < $chunk_list;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##
#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --mem-per-cpu=4G
#SBATCH --array=?
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#module load miniforge;
#mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/clair3_1.2 


#file_list=$names;
#SGE_TASK_ID=2;

#REAL
file_list=$1;

genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

sample_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f1);
dir="/data/SBCS-BuggsLab-Ash/Pangenome_Data/50_sample_ONT_Data/bams_vcf/bams";
suffix="hap1.rmdpq20.bam.sorted.bam";


name=$(echo $sample_name | rev | cut -f1 -d\/ | rev | cut -f1 -d\.)
echo $name;
bam_name=$dir/$name.$suffix;

dir2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping";

outdir=$dir2/$name.$suffix.clair;

gvcf=$outdir/merge_output.gvcf.gz;

module load bcftools/1.19-gcc-12.2.0
genome="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.fai";

header="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/S48_PG52_fastq.hap1.rmdpq20.bam.sorted.bam.clair/merged_sorted_header.txt";

#bcftools reheader -f $genome $gvcf -o $gvcf.$name.rhdr.gvcf.gz
#bcftools reheader -f "$genome" "$gvcf" \
#  | bcftools sort -Oz -o "$gvcf.$name.rhdr.sorted.gvcf.gz"
#bcftools index "$gvcf.$name.rhdr.sorted.gvcf.gz"
#echo $name > $gvcf.$name.name;
#bcftools reheader -h $header -s $gvcf.$name.name -o $gvcf.$name.rhdr2.sorted.gvcf $gvcf.$name.rhdr.sorted.gvcf.gz;
#bcftools index $gvcf.$name.rhdr2.sorted.gvcf;

chunk_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/10mb_chunks.txt";
#head -n 1 $chunk_list > $chunk_list.1;
#chunk_list=$chunk_list.1;

while read chunk;
	do chunk_name=$(basename "$chunk");
	bcftools view -R $chunk -Oz -o $gvcf.$name.rhdr2.sorted.gvcf.$chunk_name.vcf.gz $gvcf.$name.rhdr2.sorted.gvcf;
	echo "$gvcf.$name.rhdr2.sorted.gvcf.$chunk_name.vcf.gz" >>  "$dir2/${chunk_name}_list.txt";
done < $chunk_list;
	



