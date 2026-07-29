#!/bin.bash
#$ -cwd
#$ -pe smp 4
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

module load miniconda;
mamba activate /data/home/mpx545/conda_environments/busco
export CONDA_ENVS_PATH=/data/home/mpx545/conda_environments/busco/envs
export CONDA_PKGS_PATH=/data/home/mpx545/conda_environments/busco/pkgs

hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";
hap2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap2-mb-hirise-c1e0t__01-11-2023__hic_output.fasta";
batg="/data/home/mpx545/BATG-0.5-CLCbioSSPACE.fa";
poland="/data/home/mpx545/GCA_019097785.1_FRAX_001_PL_genomic.fna";
dtol_hap1="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_965226085.1_daFraExce3.hap1.1_genomic.fna";
dtol_hap2="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_965226315.1_daFraExce3.hap2.1_genomic.fna";
update="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_2_GenomeQuality/PG2_2_5_BUSCO_hap1/GCA_048541515.1_Fexc_ONT_UoY_genomic.fna";
f35="/data/home/mpx545/GWHFDPS00000000.1.genome.fasta";

database="/data/home/mpx545/eudicots_odb10";
outdir="/data/scratch/mpx545/PG2_AshPanGenome/PG2_2_5_BUSCO";

cd $outdir;

busco -f -i $hap1 -l $database -o PG2_2_5_BUSCO_hap1 -m genome --cpu ${NSLOTS};
busco -f -i $hap2 -l $database -o PG2_2_5_BUSCO_hap2 -m genome --cpu ${NSLOTS};
busco -f -i $batg -l $database -o batg -m genome --cpu ${NSLOTS};
busco -f -i $poland -l $database -o poland -m genome --cpu ${NSLOTS};
busco -f -i $f35 -l $database -o f35 -m genome --cpu ${NSLOTS};
busco -f -i $dtol_hap1 -l $database -o dtol_hap1 -m genome --cpu ${NSLOTS};
busco -f -i $dtol_hap2 -l $database -o dtol_hap2 -m genome --cpu ${NSLOTS};
busco -f -i $update -l $database -o update -m genome --cpu ${NSLOTS};

