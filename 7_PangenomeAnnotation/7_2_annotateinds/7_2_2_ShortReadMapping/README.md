#### 7_2_2 - maps short read RNA-seq data to the transformed fastas
### NC_7_2_2_1_starbuild.sh - builds star indexes for transformed fastas
### NC_7_2_2_2_starmap.sh  - maps short-read RNA-seq data to transformed fastas, for each RNA-seq sample used to annotate every transformed fasta (i.e. the same used to annotate BATG-1.0)
#### sub_7_2_2_2_1_starmap.sh - an individual array job sh script that submits one job per short-read RNA-seq sample, launched for all samples by 7_2_2_2
### NC_7_2_2_3_starmap_IndSpefRNA.sh - additional script to map the extra RNA-seq for 36 individuals to the corresponding transformed fasta
