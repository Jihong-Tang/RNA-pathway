[TOC levels=1-3]: #

# Table of Contents
- [Name](#name)
- [Purpose](#purpose)
- [Data downloading](#data-downloading)
    - [Sequencing data](##sequencing-data)
    - [Reference genome data](##reference-genome-data)
- [Reference](#reference)
- [Author](#author)

# Name
miRNA pathway procedure - Quantitative modeling of licensing codes for RNAs to enter the microRNA processing pathway

# Purpose
* **Updating**
* **Updating**

# Data downloading
* Sequencing data sources:
    - [Molecular Cell paper](https://linkinghub.elsevier.com/retrieve/pii/S1097276515006619) with GEO accession number [GSE67937](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE67937)
    - [Cell paper](https://linkinghub.elsevier.com/retrieve/pii/S0092867413000834) with accession number SRA051323
* All data are downloaded via FTP address by a lightweight downloading tool [aria2](https://aria2.github.io/)
* Detailed information about data downloading ==> [Blog](https://www.jianshu.com/u/3fcc93cd84c1)

## Sequencing data
Open browser, vist [EBI-ENA search page](https://www.ebi.ac.uk/ena) and search for the GEO accession number. On the [result page](https://www.ebi.ac.uk/ena/data/view/PRJNA281255), we could get the expected FTP address.

Open another window, vist [EBI-ENA search page](https://www.ebi.ac.uk/ena) and search for the SRA accession number. On the [result page](https://www.ebi.ac.uk/ena/data/view/PRJNA281255), we could get the expected FTP address.

```bash
mkdir -p $HOME/RNA-pathway/data/seq_data/de_novo_design/
mkdir -p $HOME/RNA-pathway/data/seq_data/beyond_2nd/
cd $HOME/RNA-pathway/data/seq_data/

sh $HOME/Scripts/shell/download_de_novo_design.sh ./de_novo_design/
sh $HOME/Scripts/shell/download_beyond_2nd.sh ./beyond_2nd/
```
## Reference genome data 
**Updating** 
* may be not used 

# Author 
Jihong Tang &lt;njutangjihong@gmail.com&gt; Instructed by Jun Lu and Dingyao Zhang