#!/bin.bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=1:0:0
#$ -l h_vmem=5G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

dir="/data/scratch/mpx545/PG2_AshPanGenome";
prog="/data/scratch/mpx545/PG2_AshPanGenome/PG2_2_4_Progress.txt";
dat=$(date +%Y_%m_%d);

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/ltr_retreiver;

#new_hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/haplotype_resolved_genome/new_hap2/jordan-roy3706-mb-hirise-dcyje__04-22-2023__hic_output.fasta";
#quast --eukaryote -t 1 -o $dir/quast_results_new_hap1 $new_hap1;

#new_hap2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/haplotype_resolved_genome/new_hap1/jordan-roy3706-mb-hirise-2rtuk__04-22-2023__hic_output.fasta";
#quast --eukaryote -t 1 -o $dir/quast_results_new_hap2 $new_hap2;

#From https://www.ncbi.nlm.nih.gov/assembly/GCA_912172775.1
#green="/data/home/mpx545/ncbi-genomes-2023-02-06/GCA_912172775.1_Fraxinus_pennsylvanica_genome_version_1.4_genomic.fna";
#mkdir $dir/quast_results_green;
#quast --eukaryote -t 4 -o $dir/quast_results_green $green;

#poland="/data/home/mpx545/GCA_019097785.1_FRAX_001_PL_genomic.fna";
#mkdir $dir/quast_results_poland;
#quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_poland $poland;

#no_contam="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta.oneline.fasta.nocontam.fa";
#mkdir $dir/quast_results_no_contam;
#quast --eukaryote -t 12 -o $dir/quast_results_no_contam $no_contam;

#batg="/data/home/mpx545/BATG-0.5-CLCbioSSPACE.fa";
#mkdir $dir/quast_results_batg0.5
#quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_batg0.5 $batg

#F35="/data/home/mpx545/GWHFDPS00000000.1.genome.fasta";
#mkdir $dir/quast_results_F35;
#quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_F35 $F35

dtol_hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_965226085.1_daFraExce3.hap1.1_genomic.fna";
mkdir $dir/quast_results_dtolhap1;
#quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_dtolhap1 $dtol_hap1;


dtol_hap2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_965226315.1_daFraExce3.hap2.1_genomic.fna";
mkdir $dir/quast_results_dtolhap2;
#quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_dtolhap2 $dtol_hap2;

update="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_048541515.1_Fexc_ONT_UoY_genomic.fna";
mkdir $dir/quast_results_update;

quast --eukaryote -t ${NSLOTS} -o $dir/quast_results_update $update;

#busco -f -i $andrea -l $database -o PG2_2_5_BUSCO_andrea -m genome --cpu 8;

