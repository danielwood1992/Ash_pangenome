#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -t ?
#$ -tc 100
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#file_list=$names;
#SGE_TASK_ID=1;

outdir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_20_pangenome_annotation";

list="/data/home/mpx545/scripts/PG2_RealData/PG2_5_ONTQC/filtered_reads_PG2_5_2.txt_nomandshurica.names";

truncate -s 0 $outdir/kept_all.txt
truncate -s 0 $outdir/removed_all.txt

while read name;
	do echo $name;
	ls $outdir/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept
	cat $outdir/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.kept >> $outdir/kept_all.txt;
	cat $outdir/$name.PG2_20_2.vcf.PG2_20_2.temp1.txt.PG2_20_2.removed >> $outdir/removed_all.txt
done < $list;

kept_all=$outdir/kept_all.txt;
removed_all=$outdir/removed_all.txt;

sort -u $kept_all > $kept_all.unique;
cut -f1-5 $removed_all | sort -u > $removed_all.unique;
comm -13 $kept_all.unique $removed_all.unique > $removed_all.always_removed; 



