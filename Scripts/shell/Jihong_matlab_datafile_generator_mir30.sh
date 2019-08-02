#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=mir30_file_generator
#SBATCH --ntasks=8 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description: This is the parallelized bash script to transfer all the mir125 Ye #Author: Jihong Tang
#Date: July 29, 2019

module load MATLAB
module load parallel
dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"

mirtest=$dir"mir30/"
cd $mirtest
foo () {	
  local subdir=$1
  dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"
  cd $dir
  file="./mir30/"$subdir"/RNAcen_res"
  matlab -nodesktop -nosplash -nodisplay -r "Jihong_folding_data_generator('$file');exit" | tail -n +11
  echo "Job "$subdir" finished!"

}
export -f foo
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | parallel "foo {}"
