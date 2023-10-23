#!/usr/bin/bash
#00_get_data_prepared
##if storage is limited: ln -s /localdisk/data/BPSM/ICA1/fastq .
cp /localdisk/data/BPSM/ICA1/fastq .
##there we get the directory named 'fastq'
mkdir group/ #for the sample metadata divided by groups
##use grep as the filter
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Uninduced"|grep -P "\t0"|sed 's/:/\t/g' > group/WT_Uni_0.txt
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Uninduced"|grep -P "\t24"|sed 's/:/\t/g' > group/WT_Uni_24.txt
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Uninduced"|grep -P "\t48"|sed 's/:/\t/g' > group/WT_Uni_48.txt
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Induced"|grep -P "\t0"|sed 's/:/\t/g' > group/WT_Ind_0.txt
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Induced"|grep -P "\t24"|sed 's/:/\t/g' > group/WT_Ind_24.txt
cat fastq/Tco2.fqfiles |grep -n "WT"|grep "Induced"|grep -P "\t48"|sed 's/:/\t/g' > group/WT_Ind_48.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Uninduced"|grep -P "\t0"|sed 's/:/\t/g' > group/C1_Uni_0.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Uninduced"|grep -P "\t24"|sed 's/:/\t/g' > group/C1_Uni_24.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Uninduced"|grep -P "\t48"|sed 's/:/\t/g' > group/C1_Uni_48.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Induced"|grep -P "\t0"|sed 's/:/\t/g' > group/C1_Ind_0.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Induced"|grep -P "\t24"|sed 's/:/\t/g' > group/C1_Ind_24.txt
cat fastq/Tco2.fqfiles |grep -n "Clone1"|grep "Induced"|grep -P "\t48"|sed 's/:/\t/g' > group/C1_Ind_48.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Uninduced"|grep -P "\t0"|sed 's/:/\t/g' > group/C2_Uni_0.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Uninduced"|grep -P "\t24"|sed 's/:/\t/g' > group/C2_Uni_24.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Uninduced"|grep -P "\t48"|sed 's/:/\t/g' > group/C2_Uni_48.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Induced"|grep -P "\t0"|sed 's/:/\t/g' > group/C2_Ind_0.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Induced"|grep -P "\t24"|sed 's/:/\t/g' > group/C2_Ind_24.txt
cat fastq/Tco2.fqfiles |grep -n "Clone2"|grep "Induced"|grep -P "\t48"|sed 's/:/\t/g' > group/C2_Ind_48.txt
##with grep -n and sed, the first column of the file is the row number of the sample in the original Tco2.fqfile
##when filtering by time, use tab to exclude the influence of the end of sample name, the "*_Ind_0.txt" should all be empty files
