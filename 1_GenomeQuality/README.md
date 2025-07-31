### Scripts for QCing the phased reference genomes (and other reference genomes)
###### 1_1_Quast.sh - runs Quast v5.2 on assemblies
###### 1_2_BUSCO.sh - runs BUSCO 
###### 1_3.1_setup_blobtools.sh - sets up a blobtools directory using blobtools 4.0.7
###### cantata_assemblies.txt - names of the cantata assemblies
###### 1_3.2_blast4blobtools.sh - blasts assemblies against nt database (downloaded 21/02/23) using blast+ v2.11.0
###### 1_3.3_PBmap4blobtools.sh - maps PacBio data used to construct assemblies against assemblies using minimap2 v2.5
###### 1_3.4_addblast.sh - adds blast results to blobtools object
###### 1_3.5_addcoverage.sh - adds PacBio coverage information to blobtools object
###### 1_3.6_blobtoolsview.txt - instructions on how to view the blobtools output (GUI)
