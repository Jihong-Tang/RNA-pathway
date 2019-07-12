#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=data_download
#SBATCH --ntasks=1 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description: Data downloading scrits for the miRNA modelling project
#Author: Jihong Tang
#Date: July 11, 2019 EST

cd $HOME/scratch60/
mkdir -p raw_data
cd raw_data/
mkdir -p beyond_2nd de_novo_design

cd beyond_2nd
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449428/SRR449428_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449428/SRR449428_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449541/SRR449541.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449548/SRR449548_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR449/SRR449548/SRR449548_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458494/SRR458494.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458495/SRR458495.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458497/SRR458497.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR458/SRR458496/SRR458496.fastq.gz

cd de_novo_design
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1976010/SRR1976010_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1976010/SRR1976010_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/001/SRR1976011/SRR1976011_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/001/SRR1976011/SRR1976011_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/002/SRR1976012/SRR1976012_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/002/SRR1976012/SRR1976012_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/003/SRR1976013/SRR1976013.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/004/SRR1976014/SRR1976014.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/005/SRR1976015/SRR1976015.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/006/SRR1976016/SRR1976016_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/006/SRR1976016/SRR1976016_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1976017/SRR1976017_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1976017/SRR1976017_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1976018/SRR1976018_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1976018/SRR1976018_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1976019/SRR1976019_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1976019/SRR1976019_2.fastq.gz

