##JOB_NUM##

#KPG0_2

reusable_pipeline="/data/home/mpx545/scripts/reusable_slurm_pipeline/";
names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/10mb_chunks.txt";
#names="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/10mb_chunks.txt.missing";
#head -n 1 $names > $names.1;
#names=$names.1;

#head -n 2 $names | tail -n 1 > $names.2;
#names=$names.2;

#mkdir /gpfs/scratch/mpx545/PG2_AshPanGenome/glnexus.results;

ARRAY_NUM=$(cat $names | wc -l);
ARRAY_NUM="$ARRAY_NUM $names";
echo $ARRAY_NUM;

##ARRAY_BIT##
#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:0:0
#SBATCH --array=?
#SBATCH --mem-per-cpu=6G
#SBATCH -e /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.err.txt
#SBATCH -o /gpfs/scratch/mpx545/PG2_AshPanGenome/joblog/%x.%A.%a.out.txt

#module load bcftools/1.19-gcc-12.2.0; #bcftools version not specified - paper specified this as v1.16

#Needs about 6 for one hour


file_list=$1;

#SLURM_ARRAY_TASK_ID=1;
#file_list=$names;

config="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/3_ONT_TrimMapSNP/3_3_SNPs2PCA/mergeClair3.yml";


chunk=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $file_list | cut -f1);
chunk_name="${chunk##*/}";
echo $chunk;
echo $chunk_name;

list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_6_Mapping/${chunk_name}_list.txt";
ls $list;

dir="/gpfs/scratch/mpx545/PG2_AshPanGenome/glnexus.$chunk_name.working_directory";

#rm -r $dir
#mkdir $dir;

dir2="/gpfs/scratch/mpx545/PG2_AshPanGenome/glnexus.results/$chunk_name.results";
#rm -r $dir2;
#mkdir $dir2;

module unload python/3.11.7-gcc-12.2.0;

#module load miniforge;
#mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/glnexus;
#glnexus_cli --dir $dir --config $config --list $list -t ${SLURM_NTASKS} -m 30 > $dir2/$chunk_name.vcf.gz;

module load bcftools/1.19-gcc-12.2.0
vcf=$dir2/$chunk_name.vcf.gz;
bcftools view $vcf | bcftools plugin setGT - -- -t q -n . -i "FMT/DP<8 | FMT/DP > 60" | bcftools +fill-tags - -- -t all | bcftools view -m2 -M2 -v snps -i 'F_MISSING < 0.1' | bcftools view -i 'MAF > 0.05' -Ob -o $vcf.filt.bcf;
