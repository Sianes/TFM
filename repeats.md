# Finding Repetitive Elements in Transcriptomes

For the purpose of characterizing repetitive elements in the transcriptomes we will use [RepeatMasker](https://www.repeatmasker.org/) and [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/).


1. Install software

In the envTFM conda environment, we install both software with conda:

```{bash}
conda activate envTFM
conda install -c bioconda repeatmasker
conda install -c bioconda repeatmodeler
```

This handles the installation of all dependencies, such as Perl5.

2. Prepare transcriptome assemblies

We will use the evigene .okay.fa assemblies. These have very long sequence names which are not compatible with some programs like RepeatMasker (max 50 characters allowed). For this reason, we have to shorten the names/ fasta headers.

```{bash}
cd $HOME/igmestre/TFM_Paula/
mkdir repeatmasker
cd repeatmasker

# trim using sed, to keap fasta hearders only up to first space.

sed 's/\s.*$//' ../transcriptomes_transpi/results/evigene/pelobates_merged_reads.combined.okay.fa  > pelobates_tmp.fa
sed 's/\s.*$//' ../transcriptomes_transpi/results/evigene/scaphiopus_merged_reads.combined.okay.fa > scaphiopus_tmp.fa

# some names are still too long so we can also remove "_length_271_cov_2.839130"-type information:

sed 's/_length_[[:digit:]]\+_cov_[[:digit:]]\+\.[[:digit:]]\+//'  pelobates_tmp.fa  > pelobates_transpi.fa
sed 's/_length_[[:digit:]]\+_cov_[[:digit:]]\+\.[[:digit:]]\+//'  scaphiopus_tmp.fa  > scaphiopus_transpi.fa
rm pelobates_tmp.fa scaphiopus_tmp.fa

```

3. Run RepeatMasker

For now, we are running RepeatMasker with default settings, only restricting the database to vertebrates and setting parallel to use 10 threads. See full documentation [here](http://www.repeatmasker.org/tmp/0f9b6fbc72a97d73bb3c3729ddbdbbdd.html).

```{bash}
RepeatMasker pelobates_transpi.fa --species vertebrates -par 10
RepeatMasker scaphiopus_transpi.fa --species vertebrates -par 10
```
