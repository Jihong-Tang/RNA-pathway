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
- [Step - 2:](#step---2)
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

# Step - 2: 

# Author 
Jihong Tang &lt;njutangjihong@gmail.com&gt; Instructed by Jun Lu and Dingyao Zhang
