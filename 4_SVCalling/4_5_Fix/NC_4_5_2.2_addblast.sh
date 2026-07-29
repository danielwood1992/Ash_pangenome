#!/bin.bash
#$ -cwd
#$ -pe smp 5
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules
module load bwa/0.7.17;
module load samtools/1.9;

#Set progress tracking
dat=$(date +%Y_%m_%d);

#Ok so this needs a nice name in position 0 (done) and the new nicename in position 3 in this new file (ok that's fine...);
#Defualt sort? 

#TEST
#file_list=$names;
#SGE_TASK_ID=1;

outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#tmp_name=$outdir/$name.tmptrimmo.fq.gz;

module load miniconda;
conda activate /data/home/mpx545/conda_environments/blobtools2;
#/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txt/data/home/mpx545/scripts/PG2_RealData/PG2_2_GenomeQuality/cantata_assemblies.txtblobtools--version;

#vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2_tags.vcf";
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1";
fasta_name=$vcf.seqs;

taxdump="/data/home/mpx545/new_taxdump";
echo $outdir/$name.blobdir;


fasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1.seqs";
blobdir=$fasta.blobdir;
blast_hits=$fasta.2023.blast.out;

blobtools add --replace --hits $blast_hits --taxrule bestsumorder --taxdump $taxdump $blobdir


