#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=7G
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt

#This script merges the counts together to get an output file to perform the PCA/downsttream analysis

names="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap/PoolFileList.txt_notech.PATCH"; #Remove the technical replicate..
outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_15_giraffe";

#Not sure why this is here  -p probably because this was originalyl copied from the previous script

script_dir="/data/home/mpx545/scripts/PG2_RealData/PG2_15_vgmap";
#Number of files being combined

num=$(wc -l $names);
#So this takes in the $name file, the prefix and suffix of the input files to read, and the number of Pools that are being combined.
#Note that as I read this, it seems like wc -l would be producing an extra argument $number -> $filename <- but luckily the last argument is just ignored. Keeping it here for  the record.

sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/9_PoolSeq_Pangenome/9_2_Calls/sub_9_2_3_merge.pl";

perl $sub $names $outdir PATCH.gam.snarls.PG2_15_2.vcf.adstats $num;

#So this just gets the first field of the names file (the pool name) and puts it together into a string

cat $names | cut -f1 | sed -z 's/\n/ /g' >  $names.joint.out.names;

sort -k1,1 -k2,2n $names.joint > $names.joint.out;

cp $names.joint.out $outdir;
cp $names.joint.out.names $outdir;

