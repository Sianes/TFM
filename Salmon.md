# Transcripts quantification

Once we have assembled the transcriptome, it is interesting to quantify how abundant each transcript is in our samples. For making the transcripts quantification we used [Salmon](https://combine-lab.github.io/salmon/) in [quantifying mapping-based mode](https://salmon.readthedocs.io/en/latest/salmon.html#quantifying-in-mapping-based-mode).

1. First we had to installed it (in the TFM environment).

```{bash}
conda install -c bioconda salmon
```


2. Build an Index
(salmon folder)

```{bash}
 salmon index -t ../transcriptomes_transpi/results/evigene/pelobates_merged_reads.combined.okay.fa -i pelobates_index
 salmon index -t ../transcriptomes_transpi/results/evigene/scaphiopus_merged_reads.combined.okay.fa -i scaphiopus_index
```


3. Make and Script

For running Salmon in all our samples we made this little script, and we made another one for *S. couchii* with its corresponding folders and index:

```{bash}
#!/bin/bash

SAMPLE=$1
THREADS=18


salmon quant \
--libType A \
--index pelobates_index \
--mates1 /home/igmestre/TFM_Paula/pelobates/raw_reads/$SAMPLE"_1.fastq.gz" \
--mates2 /home/igmestre/TFM_Paula/pelobates/raw_reads/$SAMPLE"_2.fastq.gz" \
--output $SAMPLE".salmon.quant" \
--threads $THREADS \
--seqBias \
--gcBias \
--useVBOpt \
--validateMappings \
--writeMappings=$SAMPLE".salmon.sam" \
&> $SAMPLE".salmon.log.txt"


pigz -p $THREADS -5 $SAMPLE".salmon.sam"

```

Before launching the script we installed pigz:

```{bash}
conda install -c conda-forge pigz
```

Also we had to upload a .txt with the name of the samples: "sample_name_pelobates.txt" and "sample_name_scaphiopus.txt".


4. Launch the script

We use the while loop to execute the script in each of the samples:

```{bash}
while read sample_name_pelobates; do bash 01_salmon_pelob_paula.sh $sample_name_pelobates; done < sample_names_pelobates.txt
while read sample_name_scaphiopus; do bash salmon_scaph_paula.sh $sample_name_scaphiopus; done < sample_names_scaphiopus.txt
```


5. Export files

To export the files with the transcripts abundance we used the [tximport package from R](https://bioconductor.org/packages/release/bioc/vignettes/tximport/inst/doc/tximport.html), so first we had to install R in our environment.

```{bash}
conda install -c r r=4
```
Then we open R in the server with the comand "R".

```{r}

library("DESeq2")
setwd("~/differential_expression/")
getwd()
BiocManager::install("tximport")
library("tximport")
install.packages("jsonlite")
library(jsonlite)

samples<- read.table("sample_names.txt", header = F)


files <- file.path(paste0(samples$V1, ".salmon.quant"), "quant.sf")
names(files) <-samples$V1

all(file.exists(files))


txi <- tximport(files, type = "salmon", txOut = T)

head(txi$counts)

saveRDS(txi, "salmon_counts.rds")

```
We repeated the R script for both species.
Once we have the rds files we downloaded and charged in RStudio of our own computer to make the rest of the analysis.

