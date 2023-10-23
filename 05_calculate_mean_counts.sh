#!/usr/bin/bash
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

