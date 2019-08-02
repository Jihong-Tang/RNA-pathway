# Date: July 22, 2019 ---
# Set up the environment ---
# library(tidyverse)

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
write.table(output, dir_path, row.names = F, col.names = F)





