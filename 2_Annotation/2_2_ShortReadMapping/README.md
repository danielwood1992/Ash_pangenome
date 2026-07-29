### Scripts for mapping short-read RNA-seq data from Sollars et al. to BATG-1.0

#### NC_2_2_1_GetData.sh - downloads short read RNA-seq data from Sollars et al.
#### NC_2_2_1.1_GetData_lesions.sh - downloads short read RNA-seq data from Chano et al. 2025
#### NC_2_2_1.2_GetData_EAB.sh - downloads short read RNA-seq data from Doonan et al. 2024

#### NC_2_2_2_starBuild.sh - builds indexes for mapping RNA-seq data to BATG-1.0 using star  2.7.10b

####NC_2_2_3_TrimNewData.sh - trims short read RNA-seq data
####NC_2_2_3.1_TrimNewData_EAB.sh - trims short read data from Doonan et al. 2024, including polyG tails
####NC_2_2_3.1_3.2_fastqc.sh - runs fastqc
####NC_2_2_3.4_multiqc.sh - runs multiqc

#### NC_2_2_3_starmap_OriginalData.sh - maps RNA-seq data to BATG-1.0 using star 2.7.10b (BATG-0.5 data only, from earlier version of annotation)
#### NC_2_2_3_starmap_NewData.sh - maps the rest of the RNA-seq data to BATG-1.0 using star 2.7.10b (indiviudal sequencing from samples in pangenome, data from other studies)

#### NC_2_2_5_how_many_reads.sh - counts trimmed reads from new dataset

#### CGR_RNA_adapters.fa - adapters used for trimming
#### CGR_RNA_adapters_pluspolyG.fa - adapters used from trimming with polyG tail
#### EAB_run_accessions.txt - Accession numbers for the data used from Doonan et al. 
#### lesion_sra.txt - Accession numbers for the data used from Chano et al.
