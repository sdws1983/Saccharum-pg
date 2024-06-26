library("ggplot2")

l <- read.table("../structure/lines", header = F)
rownames(l) <- l$V1
colnames(l) <- c("id", "Groups")
#l
d <- read.table("all.pairs.mat.max-missing0.6", skip = 1)
dt <- as.matrix(d[,2:ncol(d)])
rownames(dt) <- d$V1

p <- as.data.frame(cmdscale(dt, k = 2))

p$id <- rownames(p)
p <- merge(p, l)


options(repr.plot.width = 4, repr.plot.height = 3)
ggplot(p, aes(x=-V1, y=-V2, color=Groups)) + geom_point(alpha = .5, size = 4, aes(shape=Groups)) + theme_minimal() + xlab("PC1") + ylab("PC2")

pdf(file = "pca.pdf", width=4, height=3)
ggplot(p, aes(x=-V1, y=-V2, color=Groups)) + geom_point(alpha = .5, size = 4, aes(shape=Groups)) + theme_bw() + xlab("PC1") + ylab("PC2")
dev.off()