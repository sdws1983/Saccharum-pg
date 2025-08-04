library("GenWin")
argv <- commandArgs(TRUE)
data<-read.table(argv[1],header=F)
#data
#na.omit(data)#
data[data$V6=="Inf",]
#data[c(198014),]
data <- data[which(data$V6!="Inf"),]

spline<-splineAnalyze(Y=data$V6,map=data$V4,smoothness=100,plotRaw=TRUE,plotWindows=TRUE,method=4)
out<-write.table(spline$windowData,sep="\t",row.names=F,col.names=T,file=paste(argv[1],".spline",sep=""),quote=F)
