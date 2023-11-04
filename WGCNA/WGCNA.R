library(readxl)
library(WGCNA)
library(tidyverse)
library(magrittr)

transcriptome <- read_tsv("ginseng.xls")
transcriptome %<>% filter(!str_starts(gene_id, "novel"))
trans<-as.data.frame(t(transcriptome[-1]))
names(trans)=transcriptome$gene_id

enableWGCNAThreads(nThreads = 10)
NetworkType = "signed"
cor_method  = "pearson"
corFun_tmp  = "bicor"
corOptions_str = "use = 'pairwise.complete.obs'"
BH_pval_asso_cutoff = 0.05
softpower = 10
mergingThresh = 0.20
minModuleSize = 30
nSamples=33

gsg=goodSamplesGenes(trans, verbose = 3)
trans = trans[gsg$goodSamples, gsg$goodGenes]

A = adjacency (trans, power = softpower, type = NetworkType, corFnc = corFun_tmp, corOptions = corOptions_str)
TOM = TOMsimilarity(A, TOMType = NetworkType)
dissTOM = 1-TOM
rm(TOM)
colnames (dissTOM) = rownames (dissTOM) = colnames (trans)
save(dissTOM, file = "ginseng_dissTOM.RData")
