# Functional annotations

We search for homologous sequences of the transcripts obtained from the *de novo* transcriptomes assembled from the P. cultripes and S. couchii samples using Diamond BLASTX.

1. First we have to install the program in our environment.

```{bash}
conda activate envTFM
conda install -c bioconda diamond
conda list diamond
# packages in environment at /home/igmestre/miniconda3/envs/envTFM:
#
# Name                    Version                   Build  Channel
diamond                   2.0.14               hb97b32f_1    bioconda

```

2. Download the proteins annotations:

Go to ensembl:
https://www.ensembl.org/Xenopus_tropicalis/Info/Index

Click on Download DNA sequence (fasta), then go back in th folder (../), click on /pep and choose the pep.all file to download in the folder diamond:

```{bash}
wget http://ftp.ensembl.org/pub/release-105/fasta/xenopus_tropicalis/pep/Xenopus_tropicalis.Xenopus_tropicalis_v9.1.pep.all.fa.gz
```

3. Make references binary files and run blastx.
We put *--very-sensitive* and *--max-target-seqs* 1 for no getting more than 1 protein for each transcript

```{bash}
diamond makedb --in Xenopus_tropicalis.Xenopus_tropicalis_v9.1.pep.all.fa.gz -d xenopus_references

diamond blastx -d xenopus_references.dmnd -q ../transcriptomes_transpi/results/evigene/pelobates_merged_reads.combined.okay.fa -o pelobates_blastx_matches.tsv --very-sensitive --max-target-seqs 1

diamond blastx -d xenopus_references.dmnd -q ../transcriptomes_transpi/results/evigene/scaphiopus_merged_reads.combined.okay.fa -o scaphiopus_blastx_matches.tsv --very-sensitive --max-target-seqs 1

```

4. Download the final .tsv file and charge it on R.
