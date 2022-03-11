# 1st days

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

```

     #########################################################################################
     #                                                                                       #
     #                             TransPi precheck script                                   #
     #                                                                                       #
     #   Options available:                                                                  #
     #                                                                                       #
     #        1- Install conda (if neccesary) and DBs                                        #
     #                                                                                       #
     #               Runs of TransPi using conda                                             #
     #                                                                                       #
     #        2- Install DBs for containers use                                              #
     #                                                                                       #
     #               Runs of TransPi with containers (docker or singularity)                 #
     #                                                                                       #
     #        3- Update DBs                                                                  #
     #                                                                                       #
     #               SwissProt, PFAM, SQL DB used for annotation (requires conda)            #
     #                                                                                       #
     #        4- Exit                                                                        #
     #                                                                                       #
     #########################################################################################


          Which option you want? 1


         -- Either TransPi install the DBs for you or you provide the PATH of the DBs --

         Do you want TransPi to handle the DBs installation? (y,n,exit): y

         -- Selecting BUSCO V4 database --

1) BACTERIA
2) EUKARYOTA
3) ARCHAEA
4) EXIT

Please select one (1-5): 2

You selected EUKARYOTA. Which specific database?

1) Eukaryota_(Superkingdom)    6) Vertebrata_(Sub_phylum)
2) Arthropoda_(Phylum)         7) Metazoa_(Other)
3) Fungi_(Kingdom)             8) Mollusca_(Other)
4) Plants_(Kingdom)            9) Nematoda_(Other)
5) Protists_(Clade)           10) MAIN_MENU

    Please select database:6

1) Vertebrata_(Sub_phylum)
2) Actinopterygii_(Superclass_and_Class)
3) Aves_(Superclass_and_Class)
4) Mammalia_(Superclass_and_Class)
5) Tetrapoda_(Superclass_and_Class)
6) Carnivora_(Superorder_and_Order)
7) Cyprinodontiformes_(Superorder_and_Order)
8) Euarchontoglires_(Superorder_and_Order)
9) Laurasiatheria_(Superorder_and_Order)
10) Passeriformes_(Superorder_and_Order)
11) Primates_(Superorder_and_Order)
12) Cetartiodactyla_(Other)
13) Eutheria_(Other)
14) Glires_(Other)
15) Sauropsida_(Other)
16) MAIN_MENU


Please select database: 1

-- BUSCO V4 "Vertebrata_(Sub_phylum)" database found --


-- UNIPROT database directory found at: /home/igmestre/TFM_Paula/TransPi/DBs/uniprot_db --


-- Here is the list of UNIPROT files found at: /home/igmestre/TFM_Paula/TransPi/DBs/uniprot_db --

1) uniprot_metazoa_33208.fasta

Please select UNIPROT database to use:1



         -- Databases (PFAM,SwissProt,EggNOG,GO) last update: Wed Jan 26 08:17:57 UTC 2022 --


         -- Directory for the HMMER database is present --


         -- Pfam file is present and ready to be used --


         -- Pfam last update: Wed Jan 26 08:18:14 UTC 2022 --


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

###3rd day
11/02/2022

We changed the memory used by netxflow in netxflow.config in proceses big_mem memory='150GB'

Then we run in a new screen called pelobates the transPi for pelobates samples in pelobates folder

```{bash}
../TransPi/nextflow run ../TransPi/TransPi.nf --all --reads './raw_reads/*_[1,2].fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda
```
*We specify the path of the programs and reads and remove the R of the name, we didn't changed any other specifications.

We had an error, only were running 5 of the 12 samples, it was because of the names, we changed them and run again with the -resume order to keep the work done.

```{bash}
../TransPi/nextflow run ../TransPi/TransPi.nf --all --reads './raw_reads/*_[1,2].fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda -resume
```

It works with the following proceses:

- fastqc: for the quality of sequences
- fastp:  is a FASTQ data pre-processing tool. The algorithm has functions for quality control, trimming of adapters, filtering by quality, and read pruning.
- fastp_stats: stats of before and after the fastp
- skip_rrna_removal: (I think that it says that skips the SortMeRNA)
- normalize_reads: normalization
- trinity_assembly (Trinity): a de novo transcriptome assembler that uses kmers and de Bruijin graphs (3 modules: Inchworm, Chrysalis and Butterfly).
- soap_assembly (SOAPdenovo-Trans): a de novo transcriptome assembler designed specifically for RNA-Seq.
- velvet_oases_assembly (Velvet/Oases): De novo transcriptome assembler for very short reads.
- rna_spades_assembly (rnaSPADES): de novo transcriptome assembler. It was mainly tested on Illumina RNA-Seq data including strand-specific one, but supports IonTorrent RNA reads as well. Since SPAdes 3.14 it also support hybrid assembly from short and long reads, e.g. PacBio Iso-seq or Oxford Nanopore RNA reads.
- transabyss_assembly (TransABySS):
- evigene (Evidential Gene):
- rna_quast (rnaQUAST):
- mapping_evigene
- busco4
- mapping_trinity
- summary_evigene_individual
- busco4_tri
- skip_busco_dist
- summary_busco4_individual
- get_busco4_comparison
- transdecoder_longorf
- transdecoder_diamond
- transdecoder_hmmer
- transdecoder_predict
- swiss_diamond_trinotate
- custom_diamond_trinotate
- hmmer_trinotate
- skip_signalP
- skip_tmhmm
- skip_rnammer
- trinotate
- get_GO_comparison:
- summary_custom_uniprot:
- skip_kegg
- get_transcript_dist
- summary_transdecoder_individual
- summary_trinotate_individual
- get_report:
- get_run_info:



#### 4th day

We had a problem with the normalization because the reverse reads of Pc_72h_L_20_hybrid wasn't on the server and it copied the same as the forward, so we had to copy the file again (Christoph did that so there's no code).

Also we checked if the other reads were okey with the next comand:

```{bash}
zcat Pc_72h_L_20_hybrid_2.fastq.gz | head -2

@HWI-ST539:264:C8HPDACXX:6:1101:8492:1984 1:N:0:ATTCCTTT
NGCAGCATCAATTGGACCTTCTATACCCCATACATCCTTTATGCGTTTTGGGTACCCTTCTAATGCTTTAGAATCATTCAGCTCATAAAAGTATTTGCCTC
````
It shows the first two lines of the fastq file, that had the information of the forward or revers read.
The 1 before the :N has the information of forward and if it is a 2 is reverse.

The other reads were okey.

Then we run TransPi again with resume.

```{bash}
../TransPi/nextflow run ../TransPi/TransPi.nf --all --reads './raw_reads/*_[1,2].fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda -resume
```

#### 5th day

Error, search the transpi.report.html inside the folder results/pipeline_info.

Search on github the error.
https://github.com/PalMuc/TransPi/issues/34

It results that it takes a long time to create the environment so the program stops, we can solve this by installing it with this command:

```{bash}
conda create --mkdir --yes --quiet --prefix /home/igmestre/TFM_Paula/pelobates/condaEnv/env-475622de9368222cf2e999f59ba55d9f -c conda-forge bioconda::rnaquast=2.2.1=h9ee0642_0
```
Then we run the TransPi again with resume and it should take this step as done.

```{bash}
../TransPi/nextflow run ../TransPi/TransPi.nf --all --reads './raw_reads/*_[1,2].fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda -resume
```

*Info extra: I can see in which folder the files that are being created are located in the beginning of each process as we can see in this image.

![Running](/Users/Usuario/Desktop/master_omicas/TFM/Running.png)


#### Christoph work (25/02)

As TransPi do the transcriptome ensemble for each sample and we wanted it to did in all the samples together we had to merged all the samples manually with this command and then run the program again. There were no options to do that automatically.

```{bash}
cat *_1.fastq.gz > path/to/directory/pelobates_merged_reads_R1.fastq.gz &
cat *_2.fastq.gz > path/to/directory/pelobates_merged_reads_R2.fastq.gz &
../TransPi/nextflow run ../TransPi/TransPi.nf --all --reads './merged_reads/*.fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda -resume (??)
```
The old transpi results are in a directory called “transpi_individual_reads”.

The scaphiopus files were merged as well and are running at the same time as Pelobates, results will be in a new “transcriptomes_transi” directory.

### 11/03
#### Counting genes

```{bash}
(base) [igmestre@genomics_a evigene]$ cat pelobates_merged_reads.combined.fa | grep -c ">"
14727012
(base) [igmestre@genomics_a evigene]$ cat pelobates_merged_reads.combined.okay.fa | grep -c ">"
435724

(base) [igmestre@genomics_a evigene]$ cat scaphiopus_merged_reads.combined.fa | grep -c ">"
12899026
(base) [igmestre@genomics_a evigene]$ cat scaphiopus_merged_reads.combined.okay.fa | grep -c ">"
386155
```
The results are the number of total genes we see on the report. We have to use **RepeatMasker** to screens DNA sequences for interspersed repeats and low complexity DNA sequences.The output of the program is a detailed annotation of the repeats that are present in the query sequence as well as a modified version of the query sequence in which all the annotated repeats have been masked (default: replaced by Ns).
So first we have to install RepeatMasker in our conda environment.

