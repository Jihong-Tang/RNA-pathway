#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=mir125_generator
#SBATCH --ntasks=8 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description: This is the parallelized bash script to transfer all the mir125 Ye Ding folding result file to the RNAFold format, using the written R script "Jihong_read_and_transfer_YDformat_to_RNAFoldformat.R".
#Author: Jihong Tang
#Date: July 29, 2019

module load MATLAB

dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"
cd $dir

THREAD_NUM=8
mkfifo tmptmpmotif
exec 9<>tmptmpmotif
        
for ((i=0;i<$THREAD_NUM;i++))
  do
     echo -ne "\n" 1>&9
  done
       
for (( i = 1; i <= 9; i++ ))
  do
  {
            
     read -u 9           
     {
       find ./mir125/ -type f -name '*.txt' -exec cat {} + >./combined_data_result/mir125_combined_RNAcen_res.txt
       echo -ne "\n" 1>&9
     }&
  }
  done
  wait
rm tmptmpmotif

