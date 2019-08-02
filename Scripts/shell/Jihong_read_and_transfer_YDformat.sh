#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=my_job
#SBATCH --ntasks=8 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description:
#Author: Jihong Tang
#Date:

module load R
dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"

mirtest=$dir"test/"
cd $mirtest
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' >> folder_name.txt

for subdir in $(cat folder_name.txt);do
  (	
  file_path=$mirtest$subdir"/sample_1000.out"
  dic_path=$dir"mir125_ref.txt"
  dir_path=$mirtest$subdir"/RNAcen_res.txt"
  Rscript $HOME/scripts/R/Jihong_read_and_transfer_YDformat_to_RNAFoldformat.R $file_path $subdir $dic_path $dir_path
  )&
done
wait
