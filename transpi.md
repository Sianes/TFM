# Running the TransPi workflow

[TransPi](https://github.com/PalMuc/TransPi) is a [Nextflow](https://www.nextflow.io/) pipeline for de Novo transcriptome assembly.

TransPi tries to perform the best assembly using diverses assamblers as Trinity, TransABySS, SOAP, Velvet/Oases and rnaSPAdes and joining them with [EviGene](http://arthropods.eugenes.org/EvidentialGene/evigene/). It uses different parameters to then get a non-redundant consensus assembly. It also performs other valuable analyses such as pre quality check and filtering, quality assessment of the assembly, BUSCO scores, Transdecoder (ORFs), and gene ontologies (Trinotate), etc. When finished it returns a report with information about the assembly and files with the different results.

TransPi is developed in Nextflow, which is  a workflow framework that can be used by a bioinformatician to integrate all of their bash, python, perl or other scripts into a one cohesive pipeline that are portable, reproducible, scalable and checkpointed. Therefore, the analyses are performed with minimal user input but without losing the potential of a comprehensive analysis.

We use this pipeline here to assemble transcriptomes for two amphibians species [Pelobates cultripes](https://en.wikipedia.org/wiki/Pelobates_cultripes) and [Scaphiopus couchii](https://en.wikipedia.org/wiki/Couch%27s_spadefoot_toad) as our [study system](https://sianes.github.io/TFM/Study_system.html). 

The pipeline was run with the following commands:


## 1. Merging all fastq files

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


## 2. Install Nextflow and Transpi

We followed the [manual](https://palmuc.github.io/TransPi/) provided by the developers on their GitHub page.

First we had to clone the repository and move to the directory:

```{bash}
git clone  https://github.com/palmuc/TransPi.git
cd TransPi
```


## 3. Run pre-check

TransPi requires various databases to run. The precheck script will installed the databases and software, if necessary, to run the tool. The precheck run needs a PATH as an argument for installing (locally) all the databases the pipeline needs. Once the precheck run is done it will create a file named nextflow.config that contains the various PATH for the databases. If selected, it will also have the local conda environment PATH.

```{bash}
bash precheck_TransPi.sh /YOUR/PATH/HERE/
````

While installing we were asked for some parameters and we chose the following ones:

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


-- UNIPROT database directory found at: /TransPi/DBs/uniprot_db --


-- Here is the list of UNIPROT files found at: /TransPi/DBs/uniprot_db --

1) uniprot_metazoa_33208.fasta

Please select UNIPROT database to use:1



         -- Databases (PFAM,SwissProt,EggNOG,GO) last update: Wed Jan 26 08:17:57 UTC 2022 --


         -- Directory for the HMMER database is present --


         -- Pfam file is present and ready to be used --


         -- Pfam last update: Wed Jan 26 08:18:14 UTC 2022 --


         -- If no "ERROR" was found and all the neccesary databases are installed proceed to run TransPi --


         -- INFO to use in TransPi --

         Installation PATH:      /TransPi
         BUSCO V4 database:      /TransPi/DBs/busco_db/vertebrata_odb10
         UNIPROT database:       /TransPi/DBs/uniprot_db/uniprot_metazoa_33208.fasta
         UNIPROT last update:    Mon Jan 24 21:50:08 UTC 2022
         PFAM files:             /TransPi/DBs/hmmerdb/Pfam-A.hmm
         PFAM last update:       Wed Jan 26 08:18:14 UTC 2022
         SQL DB last update:     Wed Jan 26 08:17:57 UTC 2022
         NEXTFLOW:               /TransPi/nextflow

```
 
 
## 4. Run Transpi on Pelobates and Scaphiopus simultaneously

Before running we changed the memory used by netxflow in netxflow.config, proceses, big_mem memory='150GB'.

Then we launched with our previous merged reads.

```{bash}
nextflow run TransPi.nf --all --reads '/YOUR/READS/PATH/HERE/'merged_reads/*.fastq.gz' --k 25,41,53 --maxReadLen 75 -profile conda
```
We used the recommended parametres:

```
--all                Run full TransPi analysis
--reads              PATH to the paired-end reads
--k                  kmers list to use for the assemblies
--maxReadLen         Max read length in the library
-profile             Use conda to run the analyses
```

If there is any error report you can search on their [GitHub issues page](https://github.com/PalMuc/TransPi/issues) and when solved you can keep running from the last step with the command --resume in the launch command above.
