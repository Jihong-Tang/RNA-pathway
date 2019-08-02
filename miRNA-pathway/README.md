[TOC levels=1-3]: #

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Name](#name)
- [Purpose](#purpose)
- [Step 0 - Data downloading](#step-0---data-downloading)
  - [Sequencing data](#sequencing-data)
  - [Data downloading in Yale](#data-downloading-in-yale)
  - [Quality control of data](#quality-control-of-data)
- [Step - 1:Folding sequence preparation](#step---1folding-sequence-preparation)
  - [Step introduction](#step-introduction)
  - [Code](#code)
    - [Environment setup and functions creation](#environment-setup-and-functions-creation)
    - [Reference files creation](#reference-files-creation)
    - [Sequence selection](#sequence-selection)
    - [Data visulization check](#data-visulization-check)
- [Step - 2: Ye Ding format data importing and transformation](#step---2-ye-ding-format-data-importing-and-transformation)
  - [Step introduction](#step-introduction-1)
  - [Code](#code-1)
    - [Data processing](#data-processing)
    - [Job batching](#job-batching)
- [Step -3: Matlab-based data preparation](#step--3-matlab-based-data-preparation)
  - [Step introduction](#step-introduction-2)
  - [Code](#code-2)
    - [Matlab reading script](#matlab-reading-script)
    - [Job batching script](#job-batching-script)
- [Author](#author)

# Name
miRNA pathway procedure - Quantitative modeling of licensing codes for RNAs to enter the microRNA processing pathway

# Purpose
* **Updating**
* **Updating**

# Step 0 - Data downloading
* Sequencing data sources:
    - [Molecular Cell paper](https://linkinghub.elsevier.com/retrieve/pii/S1097276515006619) with GEO accession number [GSE67937](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE67937)
    - [Cell paper](https://linkinghub.elsevier.com/retrieve/pii/S0092867413000834) with accession number [SRA051323](https://www.ebi.ac.uk/ena/data/view/PRJNA281255)
* All data are downloaded via FTP address by a lightweight downloading tool [aria2](https://aria2.github.io/)
* Detailed information about data downloading ==> [Blog](https://www.jianshu.com/u/3fcc93cd84c1)

## Sequencing data
Open browser, vist [EBI-ENA search page](https://www.ebi.ac.uk/ena) and search for the GEO accession number. On the [result page](https://www.ebi.ac.uk/ena/data/view/PRJNA281255), we could get the expected FTP address.

Open another window, vist [EBI-ENA search page](https://www.ebi.ac.uk/ena) and search for the SRA accession number. On the [result page](https://www.ebi.ac.uk/ena/data/view/PRJNA281255), we could get the expected FTP address.

```bash
# initilize the directories
mkdir -p $HOME/RNA-pathway/data/seq_data/de_novo_design/
mkdir -p $HOME/RNA-pathway/data/seq_data/beyond_2nd/
cd $HOME/RNA-pathway/data/seq_data/

# download the data via scripts 
sh $HOME/Scripts/shell/download_de_novo_design.sh ./de_novo_design/
sh $HOME/Scripts/shell/download_beyond_2nd.sh ./beyond_2nd/
```
## Data downloading in Yale
Using the ftp address gotten from the previous part and the powerful High Performance Computing(HPC) resources in Yale, we could download the data by schedule the job using slurm as following.

In addition, the detailed usage of the powerful cluster farnam could be found [here](./cluster-usage.md).

```bash
sbatch $HOME/Scripts/shell/data_downloading.sh
```

## Quality control of data
After downloading the data, we could have the first look to our data by doing some quality control work based on software [`FastQc`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

```bash
# basic command line method
cd $HOME/RNA_pathway/data/seq_data/beyond_2nd/

for dir in SRX131966_data SRX132060_data SRX132063_data SRX137000_data SRX137001_data SRX137002_data SRX137003_data
do
    cd ${dir}
    mkdir -p ./fastqc_result
    fastqc -o ./fastqc_result/ ./*.fastq.gz
done

# bash script method
sh $HOME/Scripts/shell/beyond_2nd_fastqc.sh $HOME/RNA_pathway/data/seq_data/beyond_2nd/ 
```

```bash
find /path/to/source -type f -name '*.txt' -exec cat {} + >mergedfile
```

# Step - 1:Folding sequence preparation 
## Step introduction
Begin with the [Bartel 2015 paper](https://linkinghub.elsevier.com/retrieve/pii/S1097276515006619), we could use the sequence variants they created to prepare the sequence we would like to fold and extract the hairpin information. The sequence preparation work could be divided into following several steps:
- original data inputting and calculating the efficiency score based on the given equation and parameters
- appending the same prefix and suffix sequence contents to generate the sequence to be folded 
- labelling the different sequences and generating the .fasta file
- making selection of the sequences to facilitate the downstream folding analysis(saving the folding time and computational resources)
- selection strategy: randomly choosing & other type?

About the selection strategy, to conserve the distribution characristics of the original data, we finally choose to start with randomly selection.

## Code 
The R-based code as following:

### Environment setup and functions creation
```R
# date: July 16, 2019
library(seqinr)
library(tidyverse)

# create the function get_name to deal with the small problems transfering numbers to the strings in the name of sequence
get_name <- function(num){
  numstr <- strsplit(toString(num), "")[[1]] # get the char vector
  index <- 6-length(numstr) # calculate the number of 0s needed to be added before the real row num
  res <-""
  for(i in 1:index){
    res <- paste("0", res, sep = "")
  }
  for(i in 1:length(numstr)){
    res <- paste(res, numstr[i], sep = "")
  }
  return(res) # return the string
}

# create the function create_fasta to transfer the data structure and output the fasta file
create_dic <- function(file_path, pre_seq, suff_seq, pre_name,numA,numB){
  raw_data <- read.table(file_path, header = T, stringsAsFactors = F)
  temp_dic <- raw_data %>% 
    mutate(efficiency_score = log2(((selection_count+1)/(input_count+1))/(numA/numB))) %>% 
    mutate(sequence = paste(pre_seq, variant, suff_seq, sep="")) %>% 
    mutate(row_num = 1:as.numeric(length(raw_data$variant))) %>% 
    mutate(names = lapply(row_num, get_name), names = paste(pre_name, names, sep = "")) %>% 
    select(names, sequence, efficiency_score)
  return(temp_dic)
}

# creare a small function to facilitate the fasta file output
fasta_output <- function(df, name){
  write.fasta(as.list(df$sequence), names = df$names, file.out = name, open = "w", nbchar = 80, as.string = F)
}
```

### Reference files creation
```R
# based on the created functions, generate the dictionary file for the three pri-miRNAs
mir125_path <- "~/R_projects/miRNA_model/raw_data/GSE67937_125_variant_counts.txt"
mir125_prefix <- "AGGGTCTACCGGGCCACCGCACACCATGTT"
mir125_suffix <- "CCAACCACACACCTGGGGAATTGC"
mir125_ref <- create_dic(mir125_path, mir125_prefix, mir125_suffix, "mir125Seq", 6240, 1433)

mir16_path <- "~/R_projects/miRNA_model/raw_data/GSE67937_16_variant_counts.txt"
mir16_prefix <- "ATTTCTTTTTATTCATAGCTCTTATGATAGCAAT"
mir16_suffix <- "CATACTCTACAGTTGTGTTTTAATGT"
mir16_ref <- create_dic(mir16_path, mir16_prefix, mir16_suffix, "mir16Seq", 4448, 3480)

mir30_path <- "~/R_projects/miRNA_model/raw_data/GSE67937_30_variant_counts.txt"
mir30_prefix <- "CCCAACAGAAGGCTAAAGAAGGTATATTGCTGTT"
mir30_suffix <- "TCGGACTTCAAGGGGCTACTTTAGG"
mir30_ref <- create_dic(mir30_path, mir30_prefix, mir30_suffix, "mir30Seq", 10602, 4093)

# export the dictionary file in .txt format
write_delim(mir125_ref, "./result_files/mir125_ref.txt", col_names = T)
write_delim(mir16_ref, "./result_files/mir16_ref.txt", col_names = T)
write_delim(mir30_ref, "./result_files/mir30_ref.txt", col_names = T)

fasta_output(mir125_ref, "./result_files/mir125_ref.fasta")
fasta_output(mir16_ref, "./result_files/mir16_ref.fasta")
fasta_output(mir30_ref, "./result_files/mir30_ref.fasta")
```

### Sequence selection

```R
mir125_10per_random <- mir125_ref %>% 
  filter(names %in% sample(names, length(mir125_ref$names)/10))
fasta_output(mir125_10per_random, "./result_files/mir125_10per_random.fasta")
mir16_10per_random <- mir16_ref %>% 
  filter(names %in% sample(names, length(mir16_ref$names)/10))
fasta_output(mir16_10per_random, "./result_files/mir16_10per_random.fasta")
mir30_10per_random <- mir30_ref %>% 
  filter(names %in% sample(names, length(mir30_ref$names)/10))
fasta_output(mir30_10per_random, "./result_files/mir30_10per_random.fasta")

mir125_above <- mir125_ref %>% 
  filter(efficiency_score >=0) %>% 
  filter(names %in% sample(names, length(mir125_ref$names)/20))
mir125_down <- mir125_ref %>% 
  filter(efficiency_score <0) %>% 
  filter(names %in% sample(names, length(mir125_ref$names)/20))
mir125_10per_updown <- rbind(mir125_above, mir125_down)
fasta_output(mir125_10per_updown, "./result_files/mir125_10per_updown.fasta")

normal_select <- function(df, interval){
  
}

length <- length(mir125_ref$efficiency_score)
qnum <- seq(qnorm(0.001), qnorm(0.999), length.out = 20) # quantile number for each interval 
pnum <- sample(c(0), 20, replace = T) # probability number for each interval
pnum[1] <- pnorm(qnum[1]) - 0
for (i in 2:19){
  pnum[i] <- pnorm(qnum[i]) - pnorm(qnum[i-1])
}
pnum[20] <- 1- pnorm(qnum[19])
rnum <- sample(c(0), 20, replace = T) # reads number for each interval
for (i in 1:20){
  rnum[i] <- ceiling(length*pnum[i]/10)
}

inum <- seq(min(mir125_ref$efficiency_score), max(mir125_ref$efficiency_score), length.out = 21)

mir125_10per_normal <- mir125_ref %>% 
  filter(efficiency_score < inum[2]) %>% 
  filter(names %in% sample(names, rnum[1]))

for(i in 2:20){
  temp <- mir125_ref %>% filter(efficiency_score>= inum[i], efficiency_score<inum[i+1]) %>% 
    filter(names %in% sample(names, rnum[i]))
  mir125_10per_normal <- rbind(mir125_10per_normal, temp)
}

fasta_output(mir125_10per_normal, "./result_files/mir125_10per_normal.fasta")

```
### Data visulization check
```R
mir125_ref %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir125_ref")

mir16_ref %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir16_ref")

mir30_ref %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir30_ref")

mir125_10per_random %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir125_10per_random")

mir125_10per_updown %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir125_10per_updown")

mir125_10per_normal %>% 
  ggplot(aes(efficiency_score))+
  geom_density()+
  labs(title="mir125_10per_normal")
```

# Step - 2: Ye Ding format data importing and transformation
## Step introduction
After request Ye Ding lab to help fold the sequence data we created in the last step, we could get the folding result files for all the sequences. The folding result files are arranged to thouands of subfolders which named by the sequence names we provided and there is one `sample_1000.out` file in each subfolder. The `sample_1000.put` file stores the 1000 possible folding structure information for the given sequence and the Ye Ding format to annotate the pairing information could be shown as below. For each struture chunk, the first line stores the name, minimum free energy(MEF) and probability information.
```
(i j k): helix formed by base pairs i-j, (i+1)-(j-1),...,(i+k-1)-(j-k+1)


Structure        1     -47.40       0.10017E-03
    2    17     1
    3    15     4
   19   138     3
   24   132     2
   27   117     2
   31   114     5
   37   108     1
   39   106     6
   46    99     2
   50    95     3
   54    91     5
   61    84     4
   68    75     2
  119   130     2
Structure        2     -51.30       0.49191E-02
    3    15     4
   19   138     3
   24   132     2
   31   114     5
   37   108     1
   39   106     5
   46    99     7
   54    91     5
   63    84     5
   68    75     2
  119   130     3
```

To facilitate the downstream analysis, we should read in the the `sample_1000.out` file and store the information for each structure. The work needed to be done could be divided into several parts:
- Get the fasta sequence and the sequence name from the parameter 
- Extract the information from the sample_1000 out file 
- Store the structure name, MFE num and probobility num 
- Transfer the Ye Ding's structure to the RNAFold structure 

The coding logic is based on the cluster usage. To fasten the processing, we could use the paralleling methods to batch our job. The data processing codes and job batching script could be checked in the next part.

The output file contains only the sequence content, RNAFold format folding information, MFE and seuqnece name, which facilitates the preparation of Matlab data reading to use the [HairpIndex program](https://genome.cshlp.org/content/27/3/374).

## Code

### Data processing
Regular Expression and basic string manipulation are useful in dealing with different data format, so as this one.

```R
# Date: July 22, 2019 ---
# Set up the environment ---
#library(tidyverse)

# Stage 1: read in the the sample_1000.out file format from Ye Ding's sfold 
# transfer certain part to the RNAFold format and store them in list-based structure

# 1-Get the fasta sequence and the sequence name from the parameter ---
# 2-Extract the information from the sample_1000 out file ---
# 3-Store the structure name, MFE num and probobility num ---
# 4-Transfer the Ye Ding's structure to the RNAFold structure ---

# 1- Get info from the parametets
Args <- commandArgs(T)
file_path <- Args[1]
seq_name <- Args[2]
dic_path <- Args[3]
dir_path <- Args[4]

df <- read.delim2(dic_path, sep = " " ,stringsAsFactors = F)
seq_fasta <- df[df$names == seq_name, 2]

# 2- Read in the file and extract information
#file_path <- "./test_data/sample_1000.out"
con <- file(file_path, "r")

counter <- 0
startblock <- 0
name <- c()
energy <- c()
prob <- c()
RNAFoldformat <- c()
YeDingformat <- list()

pattern <- " +([[:digit:]]+) +([[:digit:]]+) +([[:digit:]]+)"
proto <- data.frame(left = integer(), right = integer(), continue = integer())

while(T){
  line = readLines(con, n = 1)
  if(length(line) == 0) break
  if(grepl("Structure", line)){
    startblock <- 1
    counter <- counter + 1
    temp <- unlist(strsplit(line, "     ", fixed = T))
    name[counter] <- as.numeric(temp[2])
    name[counter] <- paste0(seq_name, "Structure", name[counter])
    energy[counter] <- as.numeric(temp[3])
    prob[counter] <- as.numeric(temp[4])
    YeDingformat[[counter]] <- data.frame()
  }
  else if(startblock == 1){
    tempdf <- strcapture(pattern, line, proto)
    YeDingformat[[counter]] <- rbind(YeDingformat[[counter]], tempdf)
  }
}
close(con)

#seq_fasta <- "AGGGTCTACCGGGCCACCGCACACCATGTTGCCAGTCTCTAGGTCCCTGAGACCCTTTATTTTGTGAGGACATCCAGGGTCACATAAGAGGTTCTTGGGAGCCTGGCGTCTGGCCCAACCACACACCTGGGGAATTGC"
seq_length <- as.numeric(nchar(seq_fasta))
format_transfer <- function(df){
  res <- rep(".", seq_length)
  leftindex <- c()
  rightindex <- c()
  for(i in 1:length(df$left)){
    leftindex <- c(leftindex, seq(df$left[i], df$left[i] + df$continue[i] - 1))
    rightindex <- c(rightindex, seq(df$right[i] - df$continue[i] + 1,  df$right[i]))
  }
  for(i in leftindex) {res[i] <- "("}
  for(i in rightindex) {res[i] <- ")"}
  return(paste(res, collapse = ""))
}

for (i in 1:length(name)){
  RNAFoldformat[i] <- format_transfer(YeDingformat[[i]])
}

sequence <- rep(seq_fasta, length(name))
HairpInfo <- list(name, sequence, energy, prob, RNAFoldformat, YeDingformat)

output <- data.frame(name, sequence, RNAFoldformat, as.character(energy), stringsAsFactors = F)

#dirpath <- "./test_data/RNAcen_res.txt"
write.table(output, dir_path, row_names = F, col_names = F)

```

### Job batching
Using the GNU software `parallel`, we could easily batch our job in paralleling methods.

```bash
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
```

The following command is to find all subfolders' name in a certain folder in the `Linux` system, and is very useful in this job batching step.
```bash
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 
```
# Step -3: Matlab-based data preparation

## Step introduction
The `[HairpIndex pipeline](https://genome.cshlp.org/content/27/3/374)` is used to extract the hairpin information from the folding structures. In order to use this Matlab-based program, we need to transfer the data file into `.mat` data file which could be loaded into the program. The simple Matlab script as shown following is edited based on the given script in the `HairpIndex pipeline`, and the job batching scripts share the similar logic to the above one.

## Code

### Matlab reading script
```Matlab
function Jihong_folding_data_generator(FileNameRoot)
%function Jihong_folding_data_generator(FileNameRoot)
%No change is necessary below

fid=fopen([FileNameRoot '.txt']);
a = textscan(fid, '%s','delimiter', '\n');
fclose(fid);
a=a{1,:};

% % make a while loop to load them into their own variables
i=1;
count=1;
while i<=size(a,1)
    c=a{i};
    c2=strcat(c(1:end));
    c2_temp=strsplit(c2,' ');
    RNAname{count,1}=c2_temp{1};
    RNAfasta{count,1}=c2_temp{2};
    RNAcen{count,1}=c2_temp{3};
    RNAcenVAL{count,1}=c2_temp{4};
    count=count+1;
    i=i+1;
end

disp('finished reading');

save ([FileNameRoot '.mat'], 'RNAfasta', 'RNAcen', 'RNAname', 'RNAcenVAL');

```
### Job batching script
```bash
#!/bin/bash
#SBATCH --partition=general
#SBATCH --job-name=test_file_generator
#SBATCH --ntasks=8 --nodes=1
#SBATCH --mem-per-cpu=6000
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=njutangjihong@gmail.com

#Script description: This is the parallelized bash script to read and transfer the data file in .txt format to .mat format
#Author: Jihong Tang
#Date: July 30, 2019

module load MATLAB
module load parallel
dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"

mirtest=$dir"test/"
cd $mirtest
foo () {	
  local subdir=$1
  dir="$HOME/project/miRNA_model/Sfold_info/Sfold_result/"
  cd $dir
  file="./test/"$subdir"/RNAcen_res"
  matlab -nodesktop -nosplash -nodisplay -r "Jihong_folding_data_generator('$file');exit" | tail -n +11
  echo "Job "$subdir" finished!"

}
export -f foo
find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | parallel "foo {}"

```

The command below is the method to call Matlab functions from command line in the Linux system.
```bash
matlab -nodesktop -nosplash -nodisplay -r "Jihong_folding_data_generator('$file');exit" | tail -n +11
```
In addition, the method to run Matlab scripts from command line in the Linux system could be shown as following:
```bash
matlab -nodisplay -nosplash -nodesktop -r "run('path/to/your/script.m');exit;" | tail -n +11
```



# Author 
Jihong Tang &lt;njutangjihong@gmail.com&gt; Instructed by Jun Lu and Dingyao Zhang
