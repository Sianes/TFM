# Pipeline 1st day

1. Coneccting to the EBD server:

``` {bash}
ssh igmestre@genomics-a.ebd.csic.es
```


2. Create my folder and make a symbolic link to raw_reads.

```{bash}
mkdir TFM_Paula
cd TFM_Paula
ln -s $HOME/ecoevodevo/raw_reads/RNA/pelobates_vs_scaphiopus/TADPOLES_01/20160518/FASTQ/C8FLCACXX_1_25_1.fastq.gz .
```

3. Create one folder for Scaphiopus and another for pelobates and copy the respective raw_reads in each folder.

  Before doing that we downloaded the excel with the information of the samples to know wich sample correspond to each specie. We used filezille for downloading.
  The samples from hybrids were excluded from our folders.
  We made this simple script using atom.

  ```{bash}
  mkdir pelobates scaphiopus
  mv C8HPDACXX_5_6* ../pelobates/raw_reads
  mv C8NHKACXX_7_6* ../pelobates/raw_reads
  mv C8NBNACXX_2_9* ../pelobates/raw_reads
  # the same with the rest of samples
  ```
  We used * to copy the forward and reverse strings (R1 and R2)

4. Download and install conda, and create and activates and environment.

```{bash}
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
bash Miniconda3-py39_4.10.3-Linux-x86_64.sh -u
conda create --name envTFM
conda activate envTFM
```

5. Set up a screen to keep the next installation loading while we were disconnected.

```{bash}
screen -S installation #here we put any name
#ctrl+a ctrl+d to go out of the screen
screen -list #to see all the screens
screen -r installation #to enter again
```

6. Install TransPi.
We installed in my folder in the new environment and the screen created in the last step.

We followed the manual we found on this hyperlink:
https://palmuc.github.io/TransPi/

  a. Clone the repository
```{bash}
git clone https://github.com/palmuc/TransPi.git
```
  b. Move to the TransPi directory
```{bash}
cd TransPi
```
  c. configuration

```{bash}
  bash precheck_TransPi.sh  /home/igmestre/TFM_Paula/TransPi
```
  While installing we were asked for some parameters and we choose the following ones:

BUSCO V4 database: vertebrata_odb10
UNIPROT database: uniprot_metazoa_33208
NEXTFLOW installation: yes

The final message when the installation finished was this:

```
-- If no "ERROR" was found and all the neccesary databases are installed proceed to run TransPi --


        -- INFO to use in TransPi --

        Installation PATH:      /home/igmestre/TFM_Paula/TransPi
        BUSCO V4 database:      /home/igmestre/TFM_Paula/TransPi/DBs/busco_db/vertebrata_odb10
        UNIPROT database:       /home/igmestre/TFM_Paula/TransPi/DBs/uniprot_db/uniprot_metazoa_33208.fasta
        UNIPROT last update:    Mon Jan 24 21:50:08 UTC 2022
        PFAM files:             /home/igmestre/TFM_Paula/TransPi/DBs/hmmerdb/Pfam-A.hmm
        PFAM last update:       Wed Jan 26 08:18:14 UTC 2022
        SQL DB last update:     Wed Jan 26 08:17:57 UTC 2022
        NEXTFLOW:               /home/igmestre/TFM_Paula/TransPi/nextflow
```
