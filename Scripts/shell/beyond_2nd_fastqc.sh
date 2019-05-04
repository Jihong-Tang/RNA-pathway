#!/bin/bash

# This script is used to generate the quality control report for all the seq data for the paper "Beyond Secondary Structure: Primary-Sequence Determinants License Pri-miRNA Hairpins for Processing".

# Argument: [1] The working directory used to store the downloaded data
# Author: Jihong Tang
# Date: May 4, 2019

echo "==> Moving to the directory <=="
cd $1

for dir in SRX131966_data SRX132060_data SRX132063_data SRX137000_data SRX137001_data SRX137002_data SRX137003_data
do
    cd ${dir}
    echo "==> Begin generate report for "${dir}" <=="
    mkdir -p ./fastqc_result
    fastqc -o ./fastqc_result/ ./*.fastq.gz
done