### Scripts for QCing the phased reference genomes (and other reference genomes)
###### NC_1_1_Quast.sh - runs Quast v5.2 on assemblies
###### NC_1_2_BUSCO.sh - runs BUSCO 
###### NC_1_3.1_setup_blobtools.sh - sets up a blobtools directory using blobtools 4.0.7
###### cantata_assemblies.txt - names of the cantata assemblies
###### NC_1_3.2_blast4blobtools.sh - blasts assemblies against nt database (downloaded 21/02/23) using blast+ v2.11.0
###### NC_1_3.3_PBmap4blobtools.sh - maps PacBio data used to construct assemblies against assemblies using minimap2 v2.5
###### NC_1_3.4_addblast.sh - adds blast results to blobtools object
###### NC_1_3.5_addcoverage.sh - adds PacBio coverage information to blobtools object
###### NC_1_3.6_blobtoolsview.txt - instructions on how to view the blobtools output (GUI)
###### NC_1_4_pc_in_23.sh - for the cantata assemblies, calculates the % of sequence in the 23 largest scaffolds
###### NC_1_5.1_BATG0.5_map.sh - mapping short reads from BATG-0.5 to BATG-1.0
###### NC_1_5.2_callSNPs.sh - calling SNPs from BATG-1.0 vs. BATG-0.5
###### NC_1_5_SRcheck.sh - mapping 5 random individuals from Stocks et al. 2019 as well
