### 2_3 - Cleaning and mapping long-read RNA-seq data to BATG-1.0 genome for annotation.
#### 2_3_1_concatfastqs.sh - concatenates individual ONT files into single files, based on sample name
#### 2_3_2_nanoplot.sh - analyses raw/trimmed data using NanoPlot v1.4.10
#### 2_3_3_trimming.sh - trims ONT using i) Trimmomatic v0.39 with LEADING:7 TRAILING:7, followed by Nanofilt v2.8.10 with minimum average read quality 7 and minimum length 100.
