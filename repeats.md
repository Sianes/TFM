# Finding Repetitive Elements in Transcriptomes

For the purpose of characterizing repetitive elements in the genome and transcriptomes we will use [RepeatMasker](https://www.repeatmasker.org/) and [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/).


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


4. Results

The stats results give us a total of 2.86% bases masked in the transcriptome of S. couchii and 3.97% bases masked in the transcriptome of P. cultriples. The proportion of TEs obtained is less than we expected. We repeated the analyses using the genome instead of the transcriptome of P. cultriples because perhaps these elements were not being transcribed. We obtained a total of 9.97% of bases masked, still to few. 


5. Run RepeatModeler

As we didn't obtained much percentage of TEs we had to repeat these analysis with a new database obtained using RepeatModeler. We used the genome from pelobates and the transcriptome from scaphiopus (short names version) to build the database. The commands were:

```{bash}
mkdir Repeat_modeler
cd Repeat_modeler

screen -S rmodeler_genome
BuildDatabase -name pelobates ../Pcu23_genome/Pcu23_ss_only.fa
# it creates a bunch of binaries archives with info for being used by RepeatModeler
nohup RepeatModeler -database pelobates -pa 15

screen -S rmodeler_scaph
BuildDatabase -name scaphiopus ../repeatmasker/scaphiopus_transpi.fa
nohup RepeatModeler -database scaphiopus -pa 15
```
*The nohup is used on our machines when running long ( > 3-4 hour ) jobs. The log output is saved to a file and the process is backgrounded.
-pa indicates parallel jobs.
The temporary jobs were RM_64020.WedJun11233132022 and RM_63645.WedJun11231312022.

A week and a half later the running stopped. The log file informs us there were a problem: 
*Can't locate File/Which.pm in @INC (you may need to install the File::Which module)”.*
This file was a pearl module with which there were incompatibilities.


6. Fix the error
 
  * Updated repeatmodeler to v2.0.3. This was incompatible with the python version installed (v10). We downgraded it to v9.13 then:
  
  `conda install -c bioconda repeatmodeler=2.0.3`

  * Install the missing perl module
  
  `conda install -c bioconda perl-file-which`

  * Build the database for a smaller example (just ss1 of Pcu23):
 
  `BuildDatabase -name rm_db_ss1 ss1.fa`

  * Run RepeatModeler
  
  `nohup RepeatModeler -database rm_db_ss1 -pa 20 -LTRStruct >& run.out &`
  
  As it worked we try with the databases obtained before the update:
 
  ```{bash}
  nohup RepeatModeler -database pelobates -pa 10 -LTRStruct >& run.out &
  nohup RepeatModeler -database scaphiopus -pa 10 -LTRStruct >& run_scaphiopus.out &
  ```

  There was a warning because the N50 for the scaphiopus assembly is low, which might not be ideal for repeatmodeler. So we downloaded the scaphiopus genome (from     https://www.ncbi.nlm.nih.gov/genome/?term=scaphiopus+couchii) and built a new database with it in the repeat_modeler folder. Then we ran the repeatmodeler with this database:

  ```{bash}
  mkdir Sco_genome
  cd Sco_genome
  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/009/364/435/GCA_009364435.1_usc_Scouchii_0.1/GCA_009364435.1_usc_Scouchii_0.1_genomic.fna.gz
  
  cd ../repeat_modeler
  BuildDatabase -name scaphiopus_gn ../Sco_genome/GCA_009364435.1_usc_Scouchii_0.1_genomic.fna.gz
  nohup RepeatModeler -database scouchii_gn -pa 10 -LTRStruct >& run_scouchii_gn.out &
  ```
  

7. Run RepeatMasker in genomes with the RepeatModeler databases

We ran RepeatMasker with the -families.fa file generated using repeatmodeler:

```{bash}
mkdir repeatmasker_pc23
cd repeatmasker_pc23
RepeatMasker ../Pcu23_genome/Pcu23_ss_only.fa -pa 15 -s -lib ../repeat_modeler/pelobates-families.fa -dir ./
cd ../

mkdir repeatmasker_scouchii_gn
cd ../repeatmasker_scouchii_gn
RepeatMasker ../Sco_genome/GCA_009364435.1_usc_Scouchii_0.1_genomic.fa -pa 15 -s -lib ../repeat_modeler/scaphiopus-families.fa -dir ./
```


8. Final Results

We obtained about 58% repeats in P. cultriples genome and around 27% repeats in S. couchii genome. These values are more consistent in relation to their genome size, if we compare with the results of other amphibians.

9. Run RepeatMasker in transcriptomes

We also launched the commands to obtain the abundance of transposable elements in the transcriptome, i.e. their transcriptional activity at development time, but is still running...
