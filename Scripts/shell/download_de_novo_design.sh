#!/bin/bash

# This Scripts is used to download the published data for paper "The Menu of Features that Define Primary MicroRNAs and Enable De Novo Design of MicroRNA Genes" with accession nuber GSE67937. The tools used here is aria2, a fast downloading tool based on the ftp address obtained from EBI database.

# Argument: [1] The working directory to store the downloaded data
# Author: Jihong Tang
# Date: April 24, 2019

echo "==> Move to the directory <=="
cd $1

echo "==> Create folders for data from different experiments"
mkdir -p SRX997041_data SRX997042_data SRX997043_data SRX997044_data SRX997045_data
mkdir -p SRX997046_data SRX997047_data SRX997048_data SRX997049_data SRX997050_data

echo "==> Downloading data from EBI database <=="
aria2c -d ./SRX997041_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1976010/SRR1976010_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1976010/SRR1976010_2.fastq.gz
aria2c -d ./SRX997042_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/001/SRR1976011/SRR1976011_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/001/SRR1976011/SRR1976011_2.fastq.gz
aria2c -d ./SRX997043_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/002/SRR1976012/SRR1976012_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/002/SRR1976012/SRR1976012_2.fastq.gz
aria2c -d ./SRX997044_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/003/SRR1976013/SRR1976013.fastq.gz
aria2c -d ./SRX997045_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/004/SRR1976014/SRR1976014.fastq.gz
aria2c -d ./SRX997046_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/005/SRR1976015/SRR1976015.fastq.gz
aria2c -d ./SRX997047_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/006/SRR1976016/SRR1976016_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/006/SRR1976016/SRR1976016_2.fastq.gz
aria2c -d ./SRX997048_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1976017/SRR1976017_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1976017/SRR1976017_2.fastq.gz
aria2c -d ./SRX997049_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1976018/SRR1976018_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1976018/SRR1976018_2.fastq.gz
aria2c -d ./SRX997050_data/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1976019/SRR1976019_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1976019/SRR1976019_2.fastq.gz

