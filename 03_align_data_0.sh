#!/usr/bin/bash
mkdir 03_align_data/
grep -v 'SampleName' fastq/Tco2.fqfiles|
	while read S_name S_type Rep Time Trt End1 End2
	do
		echo "hisat2 -p 8 -x 03_align_data/Tcongo.genome -1 fastq/"${End1}" -2 fastq/"${End2}" -S 03_align_data/"${S_name}".sam"
		echo "samtools sort -@ 8 -o 03_align_data/"${S_name}".bam 03_align_data/"${S_name}".sam"
		echo "samtools index 03_align_data/"${S_name}".bam 03_align_data/"${S_name}".bam.bai"
	done	
