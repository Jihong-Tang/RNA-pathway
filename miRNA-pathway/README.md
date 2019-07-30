[TOC levels=1-3]: #

# Table of Contents
- [Table of Contents](#Table-of-Contents)
- [Name](#Name)
- [Purpose](#Purpose)
- [Data downloading](#Data-downloading)
  - [Sequencing data](#Sequencing-data)
- [Data downloading in Yale](#Data-downloading-in-Yale)
- [Quality control of data](#Quality-control-of-data)
- [Author](#Author)

# Name
miRNA pathway procedure - Quantitative modeling of licensing codes for RNAs to enter the microRNA processing pathway

# Purpose
* **Updating**
* **Updating**

# Data downloading
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
# Data downloading in Yale
Using the ftp address gotten from the previous part and the powerful High Performance Computing(HPC) resources in Yale, we could download the data by schedule the job using slurm as following.

In addition, the detailed usage of the powerful cluster farnam could be found [here](./cluster-usage.md).

```bash
sbatch $HOME/Scripts/shell/data_downloading.sh
```

# Quality control of data
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

# Author 
Jihong Tang &lt;njutangjihong@gmail.com&gt; Instructed by Jun Lu and Dingyao Zhang
