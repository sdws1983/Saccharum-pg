library("pcadapt")

filename <- read.pcadapt("so.pcadapt", type = "pcadapt")
x <- pcadapt(input = filename, K = 20, LD.clumping = list(size = 200, thr = 0.1)) 

pdf("screen_plot.pdf", width = 5, height = 4)
plot(x, option = "screeplot")
dev.off()

x <- pcadapt(filename, K = 3)
summary(x)


library(ggplot2)
p <- plot(x , option = "manhattan")
ggsave("x.tiff", p , width = 7, height = 4, dpi = 600)

pdf("pvalue_pcadpat.pdf", width = 5, height = 4)
hist(x$pvalues, xlab = "p-values", main = NULL, breaks = 50, col = "orange")
dev.off()

pdf("stat_pcadpat.pdf", width = 5, height = 4)
plot(x, option = "stat.distribution")
dev.off()

library(qvalue)

padj <- p.adjust(x$pvalues,method="bonferroni")
alpha <- 0.1
outliers <- which(padj < alpha)
length(outliers)

d <- read.table("so.pcadapt.raw", header = F)

write.table(d[outliers,], file = "outliers.txt2", sep=" ", quote = F)


loading <- as.data.frame(x$loadings)
colnames(loading) <- c("PC1","PC2","PC3","PC4")
head(loading)

pcs <- cbind(d, loading)
write.table(pcs, file = "PCs.so.txt", sep="\t", quote = F, row.names = F)