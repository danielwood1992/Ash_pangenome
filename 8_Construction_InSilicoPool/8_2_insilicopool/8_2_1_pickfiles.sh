#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=7G
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.t4t

#The average number of individuals from Stocks et al. per pool is 42.
#Therefore we will make our own artificial pool - from 21 sick and 21 healthy individuals.
#Keeping the number of reads roughly constant by picking 21 files from each that have the same size (4.7G)
#Creating a new input file.

names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/test_set_individuals.txt";
cut -f2 $names > $names.R1;
truncate -s 0 $names.R1.sizes;
while read file; do du -sh $file >> $names.R1.sizes; done < $names.R1;
cat $names.R1.sizes | sed "s/\/.*\///g" | sed "s/_.*//g" | awk '{print $2,$1}' | sed "s/ /\t/g" | sort -k1,1 >  $names.R1.sizes.tmp1;

names_phenotypes="/data/home/mpx545/scripts/PG2_RealData/PG2_25_artificial_pool/Supp7e_IndividualPhenotypes.txt";
sort -k1,1 $names_phenotypes > $names_phenotypes.sorted;
join $names_phenotypes.sorted $names.R1.sizes.tmp1 | sed "s/ /\t/g" | sort -k3,3 > $names.R1.sizes.phenotypes;
grep "4.7G" $names.R1.sizes.phenotypes | grep -P "\t1\t" | head -n 21 > $names.R1.sizes.phenotypes.1.top21;
grep "4.7G" $names.R1.sizes.phenotypes | grep -P "\t2\t" | head -n 21 > $names.R1.sizes.phenotypes.2.top21;
cat $names.R1.sizes.phenotypes.1.top21 $names.R1.sizes.phenotypes.2.top21 | cut -f1 | sed "s/$/_R1/g" | grep -f - $names > $names.PG2_25_1.txt;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_25_fakepool";

#Gets the R1 names for the files
cut -f2 $names.PG2_25_1.txt > $names.PG2_25_1.txt.R1;
#Gets the R2 names for the files
cut -f3 $names.PG2_25_1.txt > $names.PG2_25_1.txt.R2;

#Concatenates these together into a single R1 and R2 file
xargs cat < $names.PG2_25_1.txt.R1 > $outdir/fake_R1.fastq.gz 
xargs cat < $names.PG2_25_1.txt.R2 > $outdir/fake_R2.fastq.gz 

module load miniconda;
mamba activate /data/SBCS-BuggsLab-Ash/DanielWood/conda_environments/seqkit
#Use seqkit to get an equivalent level of coverage compared to the real pools used in Stocks et al. 2019
#-p = proportion of reads sampled. -s is just a random seed you have to give. 
seqkit sample -p 0.1 -s 1992 $outdir/fake_R1.fastq.gz | gzip > $outdir/fake_R1.p0.1.fastq.gz 
seqkit sample -p 0.1 -s 1992 $outdir/fake_R2.fastq.gz | gzip > $outdir/fake_R2.p0.1.fastq.gz 

