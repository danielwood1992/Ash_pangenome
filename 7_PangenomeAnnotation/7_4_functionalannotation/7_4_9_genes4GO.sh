#!/bin.bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=1:0:0
#$ -l h_vmem=6G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Lists of genes excluded/included in the pangenome
filtered_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_20_9_results.txt.F1.filtered";
excluded_list="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_20_9_results.txt.excluded";
pangenome_fasta="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta";


sub="/data/home/mpx545/scripts/PG2_RealData/PG2_GitHub/7_PangenomeAnnotation/7_4_functionalannotation/sub_7_4_9_1_geneclasses.pl";
perl $sub $filtered_list $pangenome_fasta $excluded_list; 

eggnog="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_26_4_eggnog.emapper.annotations";

cut -f1,10 $eggnog | grep -v '#' > $eggnog.list.all;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.I $eggnog | cut -f1,10 > $eggnog.list.I;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NI $eggnog | cut -f1,10 > $eggnog.list.NI;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V $eggnog | cut -f1,10 > $eggnog.list.V;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NV $eggnog | cut -f1,10 > $eggnog.list.NV;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V_NV $eggnog | cut -f1,10 > $eggnog.list.V_NV;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.I_NI $eggnog | cut -f1,10 > $eggnog.list.I_NI;
awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V_NI $eggnog | cut -f1,10 > $eggnog.list.V_NI;

cat $eggnog.list.NI $eggnog.list.V > $eggnog.list.NI_V;

#Getting the numbers of terms for the other genes...
out_file="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_26_5_results.txt";
truncate -s 0 $out_file;
echo "File I NI V NV" >> $out_file;
#Go through each file and get the terms, then numbers...

#Let's go for
I_num=$(wc -l $pangenome_fasta.list.I | cut -f1 -d' ' );
NI_num=$(wc -l $pangenome_fasta.list.NI | cut -f1 -d' ' ) ;
V_num=$(wc -l $pangenome_fasta.list.V | cut -f1 -d' ');
NV_num=$(wc -l $pangenome_fasta.list.NV | cut -f1 -d' ');

echo "gene_num $I_num $NI_num $V_num $NV_num" >> $out_file;

I_eggnog=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.I $eggnog | cut -f1,10 | grep -v '-' | cut -f1 | sort | uniq -c | wc -l | cut -f1);
NI_eggnog=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NI $eggnog | cut -f1,10 | grep -v '-' | cut -f1 | sort | uniq -c | wc -l | cut -f1);
V_eggnog=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V $eggnog | cut -f1,10 | grep -v '-' |  cut -f1 | sort | uniq -c | wc -l | cut -f1);
NV_eggnog=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NV $eggnog | cut -f1,10 | grep -v '-' | cut -f1 | sort | uniq -c | wc -l | cut -f1);
echo "eggnog_num $I_eggnog $NI_eggnog $V_eggnog $NV_eggnog" >> $out_file;

I_eggnog_pc=$(echo "scale = 3; $I_eggnog / $I_num" | bc);
NI_eggnog_pc=$(echo  "scale = 3; $NI_eggnog / $NI_num" | bc);
V_eggnog_pc=$(echo  "scale = 3; $V_eggnog / $V_num" | bc);
NV_eggnog_pc=$(echo  "scale = 3; $NV_eggnog / $NV_num" | bc);

echo "eggnog_pc $I_eggnog_pc $NI_eggnog_pc $V_eggnog_pc $NV_eggnog_pc" >> $out_file;

nr_diamond="";
uniprot_diamond="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/PG2_26_2_diamondUniProt.tsv";

I_uniprot=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.I $uniprot_diamond | cut -f1 | sort | uniq -c | wc -l | cut -f1);
NI_uniprot=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NI $uniprot_diamond | cut -f1 | sort | uniq -c | wc -l | cut -f1) ;
V_uniprot=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V $uniprot_diamond | cut -f1 | sort | uniq -c | wc -l | cut -f1);
NV_uniprot=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NV $uniprot_diamond | cut -f1 | sort | uniq -c | wc -l | cut -f1);
echo "uniprot_num $I_uniprot $NI_uniprot $V_uniprot $NV_uniprot" >> $out_file;

I_uniprot_pc=$(echo "scale = 3;  $I_uniprot / $I_num" | bc);
NI_uniprot_pc=$(echo "scale = 3; $NI_uniprot / $NI_num" | bc);
V_uniprot_pc=$(echo "scale = 3; $V_uniprot / $V_num" | bc);
NV_uniprot_pc=$(echo "scale = 3; $NV_uniprot / $NV_num" | bc);

echo "uniprot_pc $I_uniprot_pc $NI_uniprot_pc $V_uniprot_pc $NV_uniprot_pc" >> $out_file;

out_dir="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation";

cat /data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_26_FunctionalAnnotation/protein_seqs_PG2_20_complete.fasta*dir/*tsv >> $out_dir/PG2_26_5_interproscan_combined.tsv;
interproscan="$out_dir/PG2_26_5_interproscan_combined.tsv";

I_interpro=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.I $interproscan | cut -f1 | sort | uniq -c | wc -l | cut -f1);
NI_interpro=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NI $interproscan | cut -f1 | sort | uniq -c | wc -l | cut -f1) ;
V_interpro=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.V $interproscan | cut -f1 | sort | uniq -c | wc -l | cut -f1) ;
NV_interpro=$(awk 'NR==FNR {a[$1]; next} $1 in a' $pangenome_fasta.list.NV $interproscan | cut -f1 | sort | uniq -c | wc -l | cut -f1);
echo "interpro_num $I_interpro $NI_interpro $V_interpro $NV_interpro" >> $out_file;

I_interpro_pc=$(echo "scale = 3; $I_interpro / $I_num" | bc);
NI_interpro_pc=$(echo "scale = 3; $NI_interpro / $NI_num" | bc);
V_interpro_pc=$(echo "scale = 3; $V_interpro / $V_num" | bc);
NV_interpro_pc=$(echo "scale = 3; $NV_interpro/$NV_num" | bc);

echo "interpro_pc $I_interpro_pc $NI_interpro_pc $V_interpro_pc $NV_interpro_pc" >> $out_file;



