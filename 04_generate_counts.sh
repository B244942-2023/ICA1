#!/usr/bin/bash
mkdir 04_generate_counts_data/
cp /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed . 
##or ln -s is also ok
bedtools multicov -bams 03_align_data/*.bam -bed TriTrypDB-46_TcongolenseIL3000_2019.bed > 04_generate_counts_data/counts_data.txt
