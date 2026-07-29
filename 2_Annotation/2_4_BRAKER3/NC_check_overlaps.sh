#Check to see whether removing stuff by exactly overlapping exons solves our problems...
gtf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_4_Annotation/PG2_4_9.4_orthofinder/OrthoFinder/Results_Feb23_1/Orthogroups/PG2_4_4_10.2/LR_SR.PG2_4_4_10.2.results.longest.bed.final.gtf";

#So...
total=$(grep -P "\tgene\t" $gtf | wc -l)
same_extent=$(grep -P "\tgene\t" $gtf | cut -f1,4,5 | sort | uniq -c | wc -l);
same_start=$(grep -P "\tgene\t" $gtf | cut -f1,4 | sort | uniq -c | wc -l);
same_end=$(grep -P "\tgene\t" $gtf | cut -f1,5 | sort | uniq -c | wc -l);

echo "total = $total";
echo "unique start/stop = $same_extent";
echo "unique starts = $same_start";
echo "unique ends = $same_end";

#So then...is each gene measured by a unique transcript 1?
unique_t1s=$(grep -P "\ttranscript\t" $gtf | grep -P "t1\t" | grep -P "\tg" | cut -f9 | wc -l);

exons=$(grep -P "\texon\t" $gtf | grep 't1";' | cut -f1,4,5 | wc -l);
same_extent_exons=$(grep -P "\texon\t" $gtf | grep 't1";' | cut -f1,4,5 | sort | uniq -c | wc -l);


echo "t1 exons = $exons";
echo "t1 exons - unique extents = $same_extent_exons";

#Yes ok so they all have a transcript 1.
#So...how many exons have the exact same start/stop? How many have the same stop but different start?
#How about...exons that have the same start site?

grep -P "\texon\t" $gtf | grep 't1";' | cut -f1,4,5 | sort | uniq -c | sed 's/^ \+/ /g' | grep -v '^ 1 ' | sed 's/.* //g' > exon_list.txt;
awk 'NR==FNR {key [$1 FS $2 FS $3]; next} ($1 FS $4 FS $5) in key' exon_list.txt $gtf | grep -P "\texon\t" | sed 's/.*gene_id //g' | sed 's/"//g' | sed 's/;//g' > overlapping_genes;
grep -P "\tgene\t" $gtf | awk 'NR==FNR {key [$1,$2]; next} ! (($9,$10) in key)' overlapping_genes - > $gtf.no_overlaps 
#So then...has this solved the problem?
echo "Genes with no perfectly overlapping exons";
total=$(grep -P "\tgene\t" $gtf.no_overlaps | wc -l)
same_extent=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,4,5 | sort | uniq -c | wc -l);
same_start=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,4 | sort | uniq -c | wc -l);
same_end=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,5 | sort | uniq -c | wc -l);

echo "total = $total";
echo "unique start/stop = $same_extent";
echo "unique starts = $same_start";
echo "unique ends = $same_end";


#Try, but they have to have a unique start site?

grep -P "\texon\t" $gtf | grep 't1";' | cut -f1,4 | sort | uniq -c | sed 's/^ \+/ /g' | grep -v '^ 1 ' | sed 's/.* //g' > exon_list.txt;
awk 'NR==FNR {key [$1 FS $2]; next} ($1 FS $4) in key' exon_list.txt $gtf | grep -P "\texon\t" | sed 's/.*gene_id //g' | sed 's/"//g' | sed 's/;//g' > overlapping_genes;
grep -P "\tgene\t" $gtf | awk 'NR==FNR {key [$1,$2]; next} ! (($9,$10) in key)' overlapping_genes - > $gtf.no_overlaps 
#So then...has this solved the problem?
echo "Genes with no exons with the same start site";
total=$(grep -P "\tgene\t" $gtf.no_overlaps | wc -l)
same_extent=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,4,5 | sort | uniq -c | wc -l);
same_start=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,4 | sort | uniq -c | wc -l);
same_end=$(grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,5 | sort | uniq -c | wc -l);

echo "total = $total";
echo "unique start/stop = $same_extent";
echo "unique starts = $same_start";
echo "unique ends = $same_end";

#So...why hasn't this solved the problem?
grep -P "\tgene\t" $gtf.no_overlaps | cut -f1,4,5 | sort | uniq -c | sed 's/^ \+/ /g' | grep -v '^ 1 ' | head

