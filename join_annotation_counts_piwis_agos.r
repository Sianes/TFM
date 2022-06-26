library(tidyverse)
library(biomaRt)
setwd("C:/Users/Usuario/Desktop/master_omicas/TFM/diamond")
diamondx_pelobates<-read_tsv("pelobates_blastx_matches.tsv", col_names = F)
diamondx_scaphiopus<-read_tsv("scaphiopus_blastx_matches.tsv", col_names = F)

diamondx_pelobates<-diamondx_pelobates %>%
  dplyr::group_by(X1) %>%
  dplyr::filter(X11 == max(X11)) %>%
  dplyr::select(X1, X2) %>%
  dplyr::rename(transcript_id=X1,
                ensembl_peptide_id=X2) %>%
  mutate(ensembl_peptide_id=str_remove(ensembl_peptide_id, pattern="\\.\\d+"))

diamondx_scaphiopus<-diamondx_scaphiopus %>%
  dplyr::group_by(X1) %>%
  dplyr::filter(X11 == max(X11)) %>%
  dplyr::select(X1, X2) %>%
  dplyr::rename(transcript_id=X1,
                ensembl_peptide_id=X2) %>%
  mutate(ensembl_peptide_id=str_remove(ensembl_peptide_id, pattern="\\.\\d+"))

# gconvert is also useful for converting coding 
library(gprofiler2)
set_base_url("https://biit.cs.ut.ee/gprofiler_archive3/e105_eg52_p16")

#prueba
gprofiler2::gconvert(c("ENSXETP00000016821"), organism = "xtropicalis", target="UNIPROT_GN", mthreshold = 1)

# mthreshold=1 saca una anotación por gen
anotaciones_pelobates_blastx<-gprofiler2::gconvert(diamondx_pelobates$ensembl_peptide_id, organism = "xtropicalis", target="UNIPROT_GN", mthreshold = 1)
anotaciones_scaphiopus_blastx<-gprofiler2::gconvert(diamondx_scaphiopus$ensembl_peptide_id, organism = "xtropicalis", target="UNIPROT_GN", mthreshold = 1)



#añadir la columna de la info al diamond_pelobates y scaphiopus
colnames(anotaciones_pelobates_blastx)[2]<-"ensembl_peptide_id"
colnames(anotaciones_scaphiopus_blastx)[2]<-"ensembl_peptide_id"

#######################################################################-
###### mejor extraer primero piwis y agos y luego hacer left join #####-
#######################################################################-

blastx_agpw_pelobates <- anotaciones_pelobates_blastx[grep(pattern = "piwi|ago", anotaciones_pelobates_blastx$name), ]
#quito los magoh
blastx_agpw_pelobates <- blastx_agpw_pelobates[grep(pattern = "magoh", invert = TRUE, blastx_agpw_pelobates$name), ]

blastx_agpw_scaphiopus <- anotaciones_scaphiopus_blastx[grep(pattern = "piwi|ago", anotaciones_scaphiopus_blastx$name), ]
blastx_agpw_scaphiopus <- blastx_agpw_scaphiopus[grep(pattern = "magoh", invert = TRUE, blastx_agpw_scaphiopus$name), ]

#me quedo con las columnas de ensambl_peptide_id, name y anotaciones
agpw_pel_anno_short<-blastx_agpw_pelobates[,c(2,5,6)]
agpw_scaph_anno_short<-blastx_agpw_scaphiopus[,c(2,5,6)]

#eliminar duplicados
no_duplicado_agpw_pel_anno_shor<-agpw_pel_anno_short[!duplicated(agpw_pel_anno_short), ]
no_duplicado_agpw_scaph_anno_shor<-agpw_scaph_anno_short[!duplicated(agpw_scaph_anno_short), ]


#left join - transcritos_id con anotaciones
agpw_pelobates_anotaciones<-left_join(no_duplicado_agpw_pel_anno_shor, diamondx_pelobates, by= "ensembl_peptide_id")
agpw_scaphiopus_anotaciones<-left_join(no_duplicado_agpw_scaph_anno_shor, diamondx_scaphiopus, by= "ensembl_peptide_id")
#LAS GUARDO
agpw_pelobates_anotaciones%>%
  write_excel_csv("transcritos_anotaciones_agpw_pel.csv", delim= ";")
agpw_scaphiopus_anotaciones%>%
  write_excel_csv("transcritos_anotaciones_agpw_scaph.csv", delim=";")


#falta unirlo con el salmon, cargamos salmon
counts_pelobates<-readRDS(file = "../salmon/results/salmon_pelobates_counts.rds")
head(counts_pelobates$abundance)
counts_scaphiopus<-readRDS(file= "../salmon/results/salmon_scaphiopus_counts.rds")
head(counts_scaphiopus$abundance)

abundance_pelobates<- as.data.frame(counts_pelobates$abundance)
colnames(abundance_pelobates) #el id de los transcritos no aparece como columna, son los rownames
head(rownames(abundance_pelobates))

#paso los id de rownames a columna para hacer el left_join
abundance_pelobates<-rownames_to_column(abundance_pelobates, var = "transcript_id")
head(abundance_pelobates)

abundance_scaphiopus<-as.data.frame(counts_scaphiopus$abundance)
abundance_scaphiopus<-rownames_to_column(abundance_scaphiopus, var = "transcript_id")
head(abundance_scaphiopus)

# left-join de los piwis/agos con sus transcrip_id y anotaciones con la abundancia de esos transcritos
pel.agpw.notes.transcript.abundance<- left_join(agpw_pelobates_anotaciones,abundance_pelobates, by="transcript_id")
scaph.agpw.notes.transcript.abundance<- left_join(agpw_scaphiopus_anotaciones,abundance_scaphiopus, by="transcript_id")

#GUARDAR
pel.agpw.notes.transcript.abundance%>%
  write_excel_csv("final_agpw_pel.csv", delim = ";")
scaph.agpw.notes.transcript.abundance%>%
  write_excel_csv("final_agpw_scaph.csv", delim=";")
