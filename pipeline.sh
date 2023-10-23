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

#01_quality_check
mkdir 01_quality_check/ #for the output files
fastqc --extract -t 8 -o ${PWD}/01_quality_check ${PWD}/fastq/*.gz #I guess using 8 threads is not too much ;)
##my preference: nohup bash 01_quality_check.sh > 01_quality_check.log &
##because I don't like to mix up the steps and want to keep my screen clean^^ but it's okay to have a overall pipeline :)
##check the log with: grep -i 'ERROR' 01_quality_check.log

#02_assess_data
##actually I have only tried using multiqc and take a look at the html file before...
##tried: multiqc 01_quality_check/*.zip, but our server didn't install it ><
mkdir 02_assess_data/
##the number of sequences
ls 01_quality_check/*.zip|wc -l
##classify the information and count
grep 'fail' 01_quality_check/*fastqc/fastqc_data.txt > 02_assess_data/fail_information.txt
wc -l 02_assess_data/fail_information.txt
grep 'warn' 01_quality_check/*fastqc/fastqc_data.txt > 02_assess_data/warn_information.txt
wc -l 02_assess_data/warn_information.txt
grep 'pass' 01_quality_check/*fastqc/fastqc_data.txt > 02_assess_data/pass_information.txt
wc -l 02_assess_data/pass_information.txt
##the meaning of 'fail' and 'warn' will be in the pdf file :)

#03_align_data
mkdir 03_align_data
cp /localdisk/data/BPSM/ICA1/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz .
gunzip TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz #we need fasta file to build hisat index
hisat2-build TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta 03_align_data/Tcongo.genome
##generate script of hisat2 and samtools sort & index, or just: bash 03_align_data_0.sh > 03_align_data.sh
grep -v 'SampleName' fastq/Tco2.fqfiles|
        while read S_name S_type Rep Time Trt End1 End2
        do
                echo "hisat2 -p 8 -x 03_align_data/Tcongo.genome -1 fastq/"${End1}" -2 fastq/"${End2}" -S 03_align_data/"${S_name}".sam"
                echo "samtools sort -@ 8 -o 03_align_data/"${S_name}".bam 03_align_data/"${S_name}".sam"
                echo "samtools index 03_align_data/"${S_name}".bam 03_align_data/"${S_name}".bam.bai"
        done> 03_align_data.sh
##we can use samtools view to transform sam to bam, but the bedtools need the index of bam files, and sorted bam files are needed
bash 03_align_data.sh > 03_align_data/03_align_data.log #I have to say, 03_align_data.sh is really long...

#04_generate_counts_data
mkdir 04_generate_counts_data
cp /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed .
bedtools multicov -bams 03_align_data/*.bam -bed TriTrypDB-46_TcongolenseIL3000_2019.bed >04_generate_counts_data/counts_data.txt

#05_calculate_mean_counts
mkdir 05_calculate_mean_counts/
##WT_Uni_0
awk '{print $1+5}' group/WT_Uni_0.txt > temp #because $1~$5 is from the bed file
##put the column number into separated variable 
##this is so hard TuT...I tried hard but finally failed to simplify it as a batch programme for different replicates, sorry :(  
a=$(<temp) 
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/WT_Uni_0.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print $1,$2,sum/3; sum = 0}}' 05_calculate_mean_counts/WT_Uni_0.txt > 05_calculate_mean_counts/mean_01_WT_Uni_0.txt #use number to easily know the group after merge
##WT_Uni_24 
##for ease of merge, from this group the output file doesn't need to have the gene id and discription 
awk '{print $1+5}' group/WT_Uni_24.txt > temp 
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/WT_Uni_24.txt #but I kept the id and description in the counts file of group
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/WT_Uni_24.txt > 05_calculate_mean_counts/mean_02_WT_Uni_24.txt
##WT_Uni_48
awk '{print $1+5}' group/WT_Uni_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/WT_Uni_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/WT_Uni_48.txt > 05_calculate_mean_counts/mean_03_WT_Uni_48.txt
##skip the empty WT_Ind_0
##WT_Ind_24 #this group has 4 replicates
awk '{print $1+5}' group/WT_Ind_24.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s;var4=%s",$1,$2,$3,$4)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'",$"'${var4}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/WT_Ind_24.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/4; sum = 0}}' 05_calculate_mean_counts/WT_Ind_24.txt > 05_calculate_mean_counts/mean_04_WT_Ind_24.txt
##WT_Ind_48
awk '{print $1+5}' group/WT_Ind_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/WT_Ind_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/WT_Ind_48.txt > 05_calculate_mean_counts/mean_05_WT_Ind_48.txt
##C1_Uni_0
awk '{print $1+5}' group/C1_Uni_0.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C1_Uni_0.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C1_Uni_0.txt > 05_calculate_mean_counts/mean_06_C1_Uni_0.txt
##C1_Uni_24
awk '{print $1+5}' group/C1_Uni_24.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C1_Uni_24.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C1_Uni_24.txt > 05_calculate_mean_counts/mean_07_C1_Uni_24.txt
##C1_Uni_48
awk '{print $1+5}' group/C1_Uni_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C1_Uni_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C1_Uni_48.txt > 05_calculate_mean_counts/mean_08_C1_Uni_48.txt
##skip the empty C1_Ind_0
##C1_Ind_24
awk '{print $1+5}' group/C1_Ind_24.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C1_Ind_24.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C1_Ind_24.txt > 05_calculate_mean_counts/mean_09_C1_Ind_24.txt
##C1_Ind_48 #this group has 4 reps
awk '{print $1+5}' group/C1_Ind_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s;var4=%s",$1,$2,$3,$4)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'",$"'${var4}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C1_Ind_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/4; sum = 0}}' 05_calculate_mean_counts/C1_Ind_48.txt > 05_calculate_mean_counts/mean_10_C1_Ind_48.txt
##C2_Uni_0
awk '{print $1+5}' group/C2_Uni_0.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C2_Uni_0.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C2_Uni_0.txt > 05_calculate_mean_counts/mean_11_C2_Uni_0.txt
##C2_Uni_24 #this group has 4 reps
awk '{print $1+5}' group/C2_Uni_24.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s;var4=%s",$1,$2,$3,$4)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'",$"'${var4}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C2_Uni_24.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/4; sum = 0}}' 05_calculate_mean_counts/C2_Uni_24.txt > 05_calculate_mean_counts/mean_12_C2_Uni_24.txt
##C2_Uni_48
awk '{print $1+5}' group/C2_Uni_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C2_Uni_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C2_Uni_48.txt > 05_calculate_mean_counts/mean_13_C2_Uni_48.txt
##skip the empty C2_Ind_0
##C2_Ind_24
awk '{print $1+5}' group/C2_Ind_24.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C2_Ind_24.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C2_Ind_24.txt > 05_calculate_mean_counts/mean_14_C2_Ind_24.txt
##C2_Ind_48
awk '{print $1+5}' group/C2_Ind_48.txt > temp
a=$(<temp)
eval $(echo $a | awk '{printf("var1=%s;var2=%s;var3=%s",$1,$2,$3)}')
awk '{print $4,$5,$"'${var1}'",$"'${var2}'",$"'${var3}'"}' 04_generate_counts_data/counts_data.txt > 05_calculate_mean_counts/C2_Ind_48.txt
awk 'BEGIN{sum = 0}{for(i = 3; i <= NF; i++) {sum += $i} {print sum/3; sum = 0}}' 05_calculate_mean_counts/C2_Ind_48.txt > 05_calculate_mean_counts/mean_15_C2_Ind_48.txt
##phew...now we finished all the group!(with stupid codes haha)
##then we can merge these mean files together
paste 05_calculate_mean_counts/mean* > 05_calculate_mean_counts/all_mean_by_group.txt

#06_fold_change
mkdir 06_fold_change
##actually we can choose many different group for the comparison...so I would just take time influence in WT_Uni_* groups as a example
ls 05_calculate_mean_counts/mean* #check the correspondence of each group and column, and remember $1 is gene id and $2 is description!
awk '{print $1,$2,$3,$4,$4/($3+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_24vs0.txt #some means of genes in WT_Uni_0 may be 0, so we add 0.01(or even less is ok, but if the same gene expression in WT_Uni_24 is not 0,the fold change can be a really large number >< ), but there is also a disadvantage: if the expression in WT_Uni_24 is 0 and in WT_Uni_0 is not 0, this code cannot find that gene, so I strongly recommend do a reverse calculation:
awk '{print $1,$2,$3,$4,$3/($4+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_0vs24.txt
##and for 48&0, 48&24, we can just do the same
awk '{print $1,$2,$3,$5,$5/($3+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_48vs0.txt 
awk '{print $1,$2,$3,$5,$3/($5+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_0vs48.txt
awk '{print $1,$2,$3,$5,$5/($4+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_48vs24.txt
awk '{print $1,$2,$3,$5,$4/($5+0.01)}' 05_calculate_mean_counts/all_mean_by_group.txt|sort -k5,5nr > 06_fold_change/WT_Uni_24vs48.txt
##the results of different group's comparisons could be really different, and I guess in the real analysis, now we may have to use R for help...or use paste before sort :)
##thank you for r-x this code^^
