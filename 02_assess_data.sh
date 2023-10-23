#!/usr/bin/bash
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
