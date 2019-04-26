#!/bin/bash

# This script is used to download the published data for the paper "Beyond Secondary Structure: Primary-Sequence Determinants License Pri-miRNA Hairpins for Processing" with accession number SRA051323. The downloading tool used here is aria2(https://aria2.github.io), and the data source is EBI database.

# Argument: [1] The working directory used to store the downloaded data
# Author: Jihong Tang
# Date: April 25, 2019

echo "==> Moving to the directory <=="
cd $1

echo "==> Creating the folders to store downloaded data from different experiments <=="
mkdir -p SRX131966_data SRX132060_data SRX132063_data SRX137000_data SRX137001_data SRX137002_data SRX137003_data 

echo "==> Downloading data from EBI database <=="
aria2c -d ./SRX131966_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449428/SRR449428_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449428/SRR449428_2.fastq.gz
aria2c -d ./SRX132060_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449541/SRR449541.fastq.gz
aria2c -d ./SRX132063_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449548/SRR449548_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449548/SRR449548_2.fastq.gz
aria2c -d ./SRX137000_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458494/SRR458494.fastq.gz
aria2c -d ./SRX137001_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458495/SRR458495.fastq.gz
aria2c -d ./SRX137002_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458497/SRR458497.fastq.gz
aria2c -d ./SRX137003_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458496/SRR458496.fastq.gz
