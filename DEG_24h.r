# Differential gene expression between 24h High level of water and 24h low level

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library(DESeq2)

#cargamos datos de conteo
counts_pelobates<-readRDS(file = "salmon/results/salmon_pelobates_counts.rds")
head(counts_pelobates$abundance)
counts_scaphiopus<-readRDS(file= "salmon/results/salmon_scaphiopus_counts.rds")
head(counts_scaphiopus$abundance)

#cargo la matriz del diseño
samples_treatment<-read.csv("salmon/results/samples_separate_treatment.csv", sep = ";")
colnames(samples_treatment)[1]<-"species"
colnames(samples_treatment)[4]<-"sample_id"
table(samples_treatment[,c("species","treatment")])
table(samples_treatment[,c("time","water_level")])
table(samples_treatment[,c("species","time","water_level")])

#remove abundance 0
pelob_no0<-counts_pelobates$abundance %>%
  as.data.frame() %>%
  filter_all(any_vars(. != 0))
scaph_no0<-counts_scaphiopus$abundance %>%
  as.data.frame() %>%
  filter_all(any_vars(. != 0))

# perfomr PCA on TRANSPOSED scaled, centred TPMs
pca_pelob<- prcomp(t(pelob_no0),scale.=T, center=T)
pca_scaph<- prcomp(t(scaph_no0),scale.=T, center=T)

## add metadata and plot
pca_pelob$x %>%
  as_tibble(rownames = "sample_id") %>%
  left_join(samples_treatment) %>% # add the experimental design information
  ggplot(aes(x=PC1, y=PC2, color=water_level, shape=time)) + #ahora mismo shape no tiene sentido, cuando una dos data sets si
  geom_point(size=3, )

pca_scaph$x %>%
  as_tibble(rownames = "sample_id") %>%
  left_join(samples_treatment) %>% # add the experimental design information
  ggplot(aes(x=PC1, y=PC2, color=water_level, shape=time)) + #ahora mismo shape no tiene sentido, cuando una dos data sets si
  geom_point(size=3)
# parece que se separan en la PC1 por High or low level of water y en la PC2 por time, pero aqui se ve mucho menos


# PHEATMAP

# get sample-to-sample distance
sample_dist_pelob <- dist(t(pelob_no0))
sample_dist_scaph<-dist(t(scaph_no0))
# convert to matrix
sample_dist_matrix_pelob <- as.matrix(sample_dist_pelob)
sample_dist_matrix_scaph <- as.matrix(sample_dist_scaph)

# plot
pheatmap(sample_dist_matrix_pelob,
         scale = "row",
         annotation_col=data.frame(samples_treatment[,c("sample_id", "water_level", "time")], row.names = "sample_id"),
         annotation_row=data.frame(samples_treatment[,c("sample_id", "water_level", "time")], row.names = "sample_id"))


pheatmap(sample_dist_matrix_scaph,
         scale = "row",
         annotation_col=data.frame(samples_treatment[,c("sample_id", "water_level", "time")], row.names = "sample_id"),
         annotation_row=data.frame(samples_treatment[,c( "sample_id", "water_level", "time")], row.names = "sample_id"))



      ## PELOBATES ####

#creamos la matriz de comparación, elegimos especie y vamos a comparar en 24h low y high
samples_pel_24h <- samples_treatment %>%
  filter(time=="24h") %>%
  filter(species=="Pelobates cultripes")

## filter counts_pelobates matrices
counts_pelobates_24h<-counts_pelobates
counts_pelobates_24h$abundance<-counts_pelobates$abundance[,samples_pel_24h$sample_id]
counts_pelobates_24h$counts<-counts_pelobates$counts[,samples_pel_24h$sample_id]
counts_pelobates_24h$length<-counts_pelobates$length[,samples_pel_24h$sample_id]

#aplicar deseq2
library(DESeq2)
dds_pel_24h <- DESeqDataSetFromTximport(counts_pelobates_24h,
                                colData = samples_pel_24h,
                                design = ~ water_level)

#ver el archivo
dds_pel_24h
assays(dds_pel_24h) #cuantas assays hay
counts(dds_pel_24h) %>% head()

#comparamos counts con dds
head(counts(dds_pel_24h)) #redondeados
head(counts_pelobates_24h$counts)

#transformacion vst
vst_counts_pel <- vst(dds_pel_24h, blind=F)

plotPCA(vst_counts_pel,
        intgroup=c("water_level"), # indicate how to label the points
        returnData=F, # plot only
        ntop=1000)

## Differential Expression Analysis
#añadir info al dds
dds_pel_24h <- DESeq(dds_pel_24h)
dds_pel_24h
resultsNames(dds_pel_24h)

## Examining differential expression analysis results
res_pel<-results(dds_pel_24h)
res_pel #saca los pvalores de los genes diferencialmente expresados

#genes with NA in padj have this value bc their low counts
counts(dds_pel_24h)[rownames(dds_pel_24h)[is.na(dds_pel_24h$padj)],] %>% head(15) #NO SALEN LOS GENES

#extract the results of comparisons, two ways:
# 1. using the result names:
results(dds_pel_24h, name="water_level_H_vs_L") # no sale
# 2. using contrasts:
results(dds_pel_24h, contrast=c("water_level","H","L")) # si sale

# single comparison, here using a padj cutoff of 0.05, el alpha
summary(res_pel, alpha=0.05)


# DEseq2 quality check

# P-value distributions
hist(res_pel$pvalue, breaks=50, col="grey", main="") # no sale como deberia, no sale pico al principio

# Dispersion plot
plotDispEsts(dds_pel_24h)

#plot MA
DESeq2::plotMA(dds_pel_24h)


res_pel %>%
  as.data.frame() %>%
  ggplot(aes(baseMean, log2FoldChange, colour=padj)) +
  geom_point(size=1) + 
  scale_y_continuous(limits=c(-3, 3), oob=squish) + # oob from the scales package is needed to "squish" points falling outside the axis limits
  scale_x_log10() +
  geom_hline(yintercept = 0, colour="red", size=1, linetype="longdash") +
  labs(x="mean of normalized counts", y="log fold change") +
  scale_colour_viridis(direction=-1, trans='sqrt') +
  geom_density_2d(colour="blue", size=0.5) +
  theme_bw()

## Exporting data
# make a results folder if it does not yet exist
dir.create("results_deseq2", showWarnings = FALSE)

# export individual results tables
for(i in names(res_pel)){
  write.csv(as.data.frame(res_pel[[i]]), paste0("./results_deseq2/deseq2_pel_", i,".csv"))
}
# export .rds files
saveRDS(res_pel, "./results_deseq2/deseq2_results_pel.rds")
saveRDS(dds_pel_24h, "./results_deseq2/deseq2_dds_pel.rds")


      ## SCAPHIOPUS ####


#creamos la matriz de comparación, elegimos especie y vamos a comparar en 24h low y high
samples_scaph_24h <- samples_treatment %>%
  filter(time=="24h") %>%
  filter(species=="Scaphiopus couchii")

## filter counts_pelobates matrices
counts_scaphiopus_24h<-counts_scaphiopus
counts_scaphiopus_24h$abundance<-counts_scaphiopus$abundance[,samples_scaph_24h$sample_id]
counts_scaphiopus_24h$counts<-counts_scaphiopus$counts[,samples_scaph_24h$sample_id]
counts_scaphiopus_24h$length<-counts_scaphiopus$length[,samples_scaph_24h$sample_id]


#aplicar deseq2
dds_scaph_24h <- DESeqDataSetFromTximport(counts_scaphiopus_24h,
                                        colData = samples_scaph_24h,
                                        design = ~ water_level)

#ver el archivo
dds_scaph_24h
assays(dds_scaph_24h) #cuantas assays hay
counts(dds_scaph_24h) %>% head()


#transformacion vst
vst_counts_scaph <- vst(dds_scaph_24h, blind=F)

plotPCA(vst_counts_scaph,
        intgroup=c("water_level"), # indicate how to label the points
        returnData=F, # plot only
        ntop=1000)


## Differential Expression Analysis
#añadir info al dds
dds_scaph_24h <- DESeq(dds_scaph_24h)
dds_scaph_24h
resultsNames(dds_scaph_24h)

## Examining differential expression analysis results
res_scaph<-results(dds_scaph_24h)
res_scaph #saca los pvalores de los genes diferencialmente expresados

#genes with NA in padj have this value bc their low counts
counts(dds_scaph_24h)[rownames(dds_scaph_24h)[is.na(dds_scaph_24h$padj)],] %>% head(15) #NO SALEN LOS GENES

#extract the results of comparisons, two ways:
# 1. using the result names:
results(dds_scaph_24h, name="water_level_H_vs_L") # no sale
# 2. using contrasts:
results(dds_scaph_24h, contrast=c("water_level","H","L")) # si sale

# single comparison, here using a padj cutoff of 0.05, el alpha
summary(res_scaph, alpha=0.05)


# DEseq2 quality check

# P-value distributions
hist(res_scaph$pvalue, breaks=50, col="grey", main="") # no sale como deberia, no sale pico al principio

# Dispersion plot
plotDispEsts(dds_scaph_24h)

#plot MA
DESeq2::plotMA(dds_scaph_24h)


res_scaph %>%
  as.data.frame() %>%
  ggplot(aes(baseMean, log2FoldChange, colour=padj)) +
  geom_point(size=1) + 
  scale_y_continuous(limits=c(-3, 3), oob=squish) + # oob from the scales package is needed to "squish" points falling outside the axis limits
  scale_x_log10() +
  geom_hline(yintercept = 0, colour="red", size=1, linetype="longdash") +
  labs(x="mean of normalized counts", y="log fold change") +
  scale_colour_viridis(direction=-1, trans='sqrt') +
  geom_density_2d(colour="blue", size=0.5) +
  theme_bw()

## Exporting data

# export individual results tables
for(i in names(res_scaph)){
  write.csv(as.data.frame(res_scaph[[i]]), paste0("./results_deseq2/deseq2_scaph_", i,".csv"))
}
# export .rds files
saveRDS(res_scaph, "./results_deseq2/deseq2_results_scaph.rds")
saveRDS(dds_scaph_24h, "./results_deseq2/deseq2_dds_scaph.rds")

