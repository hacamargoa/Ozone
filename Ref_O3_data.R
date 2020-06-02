library(plyr)

stcoord<-read.csv("C:/Users/Hector/Desktop/Pengfei/China_AQ_Data/coord_stations.csv", h=T)

setwd("../China_AQ_Data/2014/")
Data2014<-list.files(pattern ="*.csv")
Chi14<-list()
for (i in 1:length(Data2014)){
Chi14[[i]]<-read.csv(Data2014[[i]],h=T,check.names = FALSE)
}
China14<-do.call("rbind",Chi14)
O3vars<-c("O3","O3_24h","O3_8h","O3_8h_24h")
ChiO314<-list()
for (i in 1:length(O3vars)){
ChiO314[[i]]<-subset(China14, type==O3vars[i])
columns<-ChiO314[[i]][,c(1,2,3)]
temp1<-data.frame(columns, i=rep(1:(ncol(ChiO314[[i]])-3),ea=nrow(columns)))
stations<-rep(colnames(ChiO314[[i]][c(-1,-2,-3)]),each=nrow(columns))
Sta<-cbind(stations,temp1)
Sta<-join(Sta,stcoord)
ChiO314[[i]]<-cbind(Sta,unlist(ChiO314[[i]][,4:ncol(ChiO314[[i]])]));colnames(ChiO314[[i]])[8]<-paste(O3vars[i])
write.csv(ChiO314[[i]],paste("C:/Users/Hector/Desktop/Pengfei/China_2014_",O3vars[i],".csv"),row.names=FALSE)
}

head(temp1)
colnames(temp1)[1]<-"date"
colnames(temp1[c("type","i")])
head(a)
