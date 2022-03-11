# Finding Repetitive Elements in Transcriptomes

For the purpose of characterizing repetitive elements in the transcriptomes we will use [RepeatMasker](https://www.repeatmasker.org/) and [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/).


1. Install software

in the envTFM conda environment, we install both software with conda:

```{bash}
conda install -c bioconda repeatmasker
conda install -c bioconda repeatmodeler
```

This handles the installation of all dependencies, such as Perl5.
