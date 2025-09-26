#!/bin.bash
#$ -cwd
#$ -pe smp 6
#$ -l h_rt=1:0:0
#$ -l h_vmem=8G
#$ -e /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.err.txt
#$ -o /data/scratch/mpx545/PG2_AshPanGenome/joblog/$JOB_NAME.$JOB_ID.$TASK_ID.out.txt

#Load modules

#Set progress tracking
dat=$(date +%Y_%m_%d);


#vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_7_SVCalling/sniffles.vcf";
reference="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/working_copies/jordan-zhang-dtg-roy3706-hap1-mb-hirise-mjd6z__01-11-2023__hic_output.fasta";

#module load miniconda;
#mamba activate /data/home/mpx545/conda_environments/graphviz2;

#module load samtools/1.9;
#bgzip -c $vcf > $vcf.bgzip.vcf.gz;
#tabix -f $vcf.bgzip.vcf.gz;
vcf="/data/SBCS-BuggsLab-Ash/DanielWood/PG2_PanGenome/PG2_8_vg/reference_only";

vg="/data/home/mpx545/test_dir/vg.2c61112bb461e3a8e6b976baefe464798ef3f359";

$vg construct -S -a -r $reference > $vcf.PATCH.vg && echo "1 done";
$vg index --dist-name $vcf.PATCH.vg.dist $vcf.PATCH.vg && echo "2 done";
$vg index -L -x $vcf.PATCH.vg.xg $vcf.PATCH.vg && echo "3 done";
$vg gbwt --path-cover --xg-name $vcf.PATCH.vg.xg --output $vcf.PATCH.vg.gbwt && echo "4 done";
$vg gbwt --xg-name $vcf.PATCH.vg.xg --graph-name $vcf.PATCH.vg.gbz --gbz-format $vcf.PATCH.vg.gbwt && echo "5 done";
$vg minimizer --distance-index $vcf.PATCH.vg.dist --output-name $vcf.PATCH.vg.min $vcf.PATCH.vg.gbz && echo "6 done";

#vg construct --help;

#vg view $vcf.vg > $vcf.vg.gf
#vg view --help;

#So at least this bit is working...
#vg index -x $vcf.vg.xg $vcf.vg
#Note - for variant calling it suggests we might need to do this?
#vg snarls $vcf.vg.alt.xg > $vcf.vg.alt.xg.snarls;

##name="1_2400_2600";
#vg find -x $vcf.vg.xg -p Scf9YQZ_100_HRSCAF_120:2848000-2851500 -c 3 | vg view -dp - | dot -Tsvg -o subgraph.svg 
# find -x $vcf.vg.xg -p Scf9YQZ_1_HRSCAF_1:718200-718280 -c 3 | vg view -dpn - | dot -Tsvg -o $vcf.subgraph.$name.inv.svg 

#outdir="/data/scratch/mpx545/PG2_AshPanGenome";
#vg autoindex -p $vcf.autoindex -w giraffe -r $reference -v $vcf -t 4 -T $outdir;
#So I guess that snarls won't be right. Maybe just try with the vcf.




