#!/usr/bin/bash
#01_quality_check
mkdir 01_quality_check/
fastqc --extract -t 12 -o ${PWD}/01_quality_check ${PWD}/fastq/*.gz
