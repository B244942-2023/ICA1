#!/usr/bin/bash
mkdir 06_fold_change/
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
