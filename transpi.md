# Running the TransPi workflow

[TransPi](https://github.com/PalMuc/TransPi) is a [Nextflow](https://www.nextflow.io/) pipeline for de Novo transcriptome assembly.

__add more information here about what this does__

We use this pipeline here to assemble transcriptomes for two amphibians species [Pelobates cultripes](https://en.wikipedia.org/wiki/Pelobates_cultripes) and [Scaphiopus couchii](https://en.wikipedia.org/wiki/Couch%27s_spadefoot_toad).

The pipeline was run with the following commands:


## 1. merging all fastq files

FASTQ format is a text-based format for storing both a biological sequence (usually nucleotide sequence) and its corresponding quality scores. Both the sequence letter and quality score are each encoded with a single ASCII character for brevity.

It was originally developed at the Wellcome Trust Sanger Institute to bundle a FASTA formatted sequence and its quality data, but has recently become the de facto standard for storing the output of high-throughput sequencing instruments such as the Illumina Genome Analyzer.

A FASTQ file normally uses four lines per sequence.

* Line 1 begins with a '@' character and is followed by a sequence identifier and an optional description (like a FASTA title line).
* Line 2 is the raw sequence letters.
* Line 3 begins with a '+' character and is optionally followed by the same sequence identifier (and any description) again.
* Line 4 encodes the quality values for the sequence in Line 2, and must contain the same number of symbols as letters in the sequence. 

A FASTQ file containing a single sequence might look like this:

```
@SEQ_ID
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65
```

Usually fastq files are coding with _1 or _2 in their names. It makes reference to sequencing direction in paired-end sequences. Paired-end sequencing allows users to sequence both ends of a fragment and generate high-quality, alignable sequence data. It also facilitates detection of genomic rearrangements and repetitive sequence elements, as well as gene fusions and novel transcripts. All Illumina next-generation sequencing (NGS) systems are capable of pairwise sequencing.

As TransPi do the transcriptome ensemble for each sample and we want it to did in all the samples together we has to merge all the samples manually with this command:

```{bash}
cat *_1.fastq.gz > path/to/directory/pelobates_merged_reads_R1.fastq.gz &
cat *_2.fastq.gz > path/to/directory/pelobates_merged_reads_R2.fastq.gz &

cat *_1.fastq.gz > path/to/directory/scaphiopus_merged_reads_R1.fastq.gz &
cat *_2.fastq.gz > path/to/directory/scaphiopus_merged_reads_R2.fastq.gz &

# the & symbol sends the command to the background, so that the terminal is free to be used.
```


## 2. install nextflow and transpi

Points to include:
-what is nextflow and because is usefull (above)
-what is transpi, how it works (above)
-installation code

* (write correctly) We followed the manual we found on this hyperlink:
https://palmuc.github.io/TransPi/

Firs we have to clone the repository and move to the directory:

```{bash}
git clone  https://github.com/palmuc/TransPi.git
cd TransPi
```


## 3. Run pre-check

TransPi requires various databases to run. The precheck script will installed the databases and software, if necessary, to run the tool. The precheck run needs a PATH as an argument for installing (locally) all the databases the pipeline needs.

```{bash}
bash precheck_TransPi.sh /YOUR/PATH/HERE/
````
Once the precheck run is done it will create a file named nextflow.config that contains the various PATH for the databases. If selected, it will also have the local conda environment PATH.

The nextflow.config file has also other important parameters for pipeline execution that will be discussed further in the following sections.


## 4. run transpi on pelobates and scaphiopus simultaneously


```{bash}
```
