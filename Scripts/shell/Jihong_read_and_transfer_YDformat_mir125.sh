#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=mir125_transfer
#SBATCH --ntasks=8 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description: This is the parallelized bash script to transfer all the mir125 Ye Ding folding result file to the RNAFold format, using the written R script "Jihong_read_and_transfer_YDformat_to_RNAFoldformat.R".
#Author: Jihong Tang
#Date: July 29, 2019

module load R
module load parallel
dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"

mirtest=$dir"mir125/"
cd $mirtest
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' > folder_name.txt
foo () {	
  local subdir=$1
  dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"
  mirtest=$dir"mir125/"
  file_path=$mirtest$subdir"/sample_1000.out"
  dic_path=$dir"mir125_ref.txt"
  dir_path=$mirtest$subdir"/RNAcen_res.txt"
  Rscript $HOME/scripts/R/Jihong_read_and_transfer_YDformat_to_RNAFoldformat.R $file_path $subdir $dic_path $dir_path
  echo "Job "$subdir" finished!"
}
export -f foo
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | parallel "foo {}"
