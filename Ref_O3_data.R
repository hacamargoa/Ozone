library(plyr)
library(data.table)
stcoord<-read.csv("C:/Users/Hector/Desktop/PhD/Pengfei/China_AQ_Data/coord_stations.csv", h=T)
O3vars<-c("O3","O3_24h","O3_8h","O3_8h_24h")
Data<-list()
China<-list()
for (j in 1:7){ 
setwd(paste0("C:/Users/Hector/Desktop/PhD/Pengfei/China_AQ_Data/",as.character(2013+j)))
Data[[j]]<-list.files(pattern ="*.csv")
Chi<-list()
for (i in 1:length(Data[[j]])){
Chi[[i]]<-read.csv(Data[[j]][[i]],h=T,check.names = FALSE)
Chi[[i]]<-setDT(Chi[[i]])
}
China[[j]]<-do.call("rbind",c(Chi,fill=TRUE))
ChiO3<-list()
ChiO3_<-list()
for (i in 1:length(O3vars)){
ChiO3[[i]]<-subset(China[[j]], type==O3vars[i])
columns<-ChiO3[[i]][,c(1,2,3)]
temp1<-data.frame(columns, i=rep(1:(ncol(ChiO3[[i]])-3),ea=nrow(columns)))
stations<-rep(colnames(ChiO3[[i]])[c(-1,-2,-3)],each=nrow(columns))
Sta<-cbind(stations,temp1)
Sta<-join(Sta,stcoord)
ChiO3[[i]]<-cbind(Sta,unlist(ChiO3[[i]][,4:ncol(ChiO3[[i]])]));colnames(ChiO3[[i]])[8]<-paste(O3vars[i])
ChiO3_[[i]]<-ChiO3[[i]][-c(4,5)]
}
China[[j]]<-Reduce(function(x,y) join(x,y),ChiO3_)
}
ChinaO3<-do.call("rbind",China)
write.csv(ChinaO3,"C:/Users/Hector/Desktop/Pengfei/China_O3.csv",row.names=FALSE)
