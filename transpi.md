# Running the TransPi workflow

[TransPi](https://github.com/PalMuc/TransPi) is a [Nextflow](https://www.nextflow.io/) pipeline for de Novo transcriptome assembly.

__add more information here about what this does__

We use this pipeline here to assemble transcriptomes for two amphibians species [Pelobates cultripes](https://en.wikipedia.org/wiki/Pelobates_cultripes) and [Scaphiopus couchii](https://en.wikipedia.org/wiki/Couch%27s_spadefoot_toad).

The pipeline was run with the following commands:


## 1. merging all fastq files

_explain here what the fastq files are. where are they from? what is _1 and _2 etc._

```{bash}
cat *_1.fastq.gz > path/to/directory/pelobates_merged_reads_R1.fastq.gz &
cat *_2.fastq.gz > path/to/directory/pelobates_merged_reads_R2.fastq.gz &

# the & symbol sends the command to the background, so that the terminal is free to be used.
```


## 2. install nextflow and transpi


```{bash}
````



## 3. run pre-check

```{bash}
```

## 4. run transpi on pelobates and scaphiopus simultaneously


```{bash}
```