#!/bin.bash
#$ -cwd
#$ -pe smp 16
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
#vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.reffixed2";


vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_12_merge/complete_merged_PG2_12_2.all_types.all_types.tags.vcf.uniqnames.reffixed2.1";

truncate -s 0 $vcf.seqs;
grep -v '#' $vcf | grep "SVTYPE=INS" | cut -f3,5 | sed 's/^/>/g' | sed 's/\t/\n/g' > $vcf.seqs;
grep -v '#' $vcf | grep "SVTYPE=DEL" | cut -f3,4 | sed 's/^/>/g' | sed 's/\t/\n/g' >> $vcf.seqs;

fasta_name=$vcf.seqs;

nt="/data/PublicDataSets/shared_dbs/nt/2023-02-21";
module load blast+/2.11.0;
#This is the path to the blast nucleotide database
#It hasn't finishd downloading yet, but will be in /data/SBCS-BuggsLab/sharing_folder/blastdb. Remind me next week if I've not given you the path to the file.
export BLASTDB=$nt;
blastn -db nt -query $fasta_name -outfmt "6 qseqid staxids bitscore std" -max_target_seqs 10  -max_hsps 1 -evalue 1e-25 -num_threads 16 -out $fasta_name.2023.blast.out

