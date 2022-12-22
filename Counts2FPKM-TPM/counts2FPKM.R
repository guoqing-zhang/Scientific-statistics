
# set work path -----------------------------------------------------------
setwd("D:\\Script\\Scientific-statistics\\Counts2FPKM-TPM")

mycounts <- read.table("all_counts.txt",header = T,row.names = 1)
head(mycounts)
mycounts <- mycounts[,-c(1,2,3,4)] #去除不必要的列

colnames(mycounts) <- c("length","CK_1","CK_2","CK_3","mut_1","mut_2","mut_3",
                        "CK4_1","CK4_2","CK4_3")
mycounts <- round(mycounts,digits = 0)


# calculate TPM -----------------------------------------------------------

kb <- mycounts$length / 1000
countdata <- mycounts[,2:10]
rpk <- countdata / kb
tpm <- t(t(rpk)/colSums(rpk) * 1000000)
write.table(tpm,file="TPM_result.txt",sep="\t",quote = F)


# calculate FPKM ----------------------------------------------------------

fpkm <- t(t(rpk)/colSums(countdata) * 10^9)
write.table(fpkm,file="FPKM_result.txt",sep="\t",quote = F)
