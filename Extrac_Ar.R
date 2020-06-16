library(ncdf4)
library(raster)
Ch<-getData('GADM',country='CHN',level=0)
stcoord1<-read.csv("C:/Users/Hector/Desktop/PhD/Pengfei/China_AQ_Data/coord_stations.csv", h=T)
stcoord1<-na.omit(stcoord1)
stcoord<-stcoord1
coordinates(stcoord)<- ~ Longitude + Latitude

sdates<-read.table("C:/Users/Hector/Desktop/Newcrops/data/env/sdates.txt",h=T)
sdates<-sdates[-c(4,6,8,10,11,12,13)]
hdates<-read.table("C:/Users/Hector/Desktop/Newcrops/data/env/hdates.txt",h=T)
hdates<-hdates[-c(4,6,8,10,11,12,13)]
cropNa<-colnames(sdates)[c(-1,-2)]
hdat<-list()
sdat<-list()
dates<-list()
for (i in 1:length(cropNa)){
  hdat[[i]]<-hdates[c("Lon","Lat",cropNa[i])]
  coordinates(hdat[[i]])<- ~Lon+Lat
  gridded(hdat[[i]])<- TRUE
  hdat[[i]]<-raster(hdat[[i]])
  hdat[[i]]<-extract(hdat[[i]],stcoord,df=TRUE);colnames(hdat[[i]])<-paste0("hd",colnames(hdat[[i]]))
  sdat[[i]]<-sdates[c("Lon","Lat",cropNa[i])]
  coordinates(sdat[[i]])<- ~Lon+Lat
  gridded(sdat[[i]])<- TRUE
  sdat[[i]]<-raster(sdat[[i]])
  sdat[[i]]<-extract(sdat[[i]],stcoord,df=TRUE);colnames(sdat[[i]])<-paste0("sd",colnames(sdat[[i]]))
  dates[[i]]<-cbind(sdat[[i]],hdat[[i]])
  for (i in 1:length(cropNa)){
  dates[[i]]<-dates[[i]][c(-1,-3)]
  }

setwd("C:/Users/Hector/Documents/Pughtam-cropozone/Global_evaluation_outputs")
crops<-c("SPAMest_Wheat_","SPAMest_Maize_","SPAMest_Rice_")
ArNew<-list()
ChinaAr<-list()
ArStatdf<-list()
for (j in 1:length(crops)){
  ArNew[[j]]<-list.files(pattern=crops[j])
  ArNew[[j]]<-brick(ArNew[[j]])
  ChinaAr[[j]]<-mask(ArNew[[j]],Ch)
  ChinaAr[[j]]<-crop(ChinaAr[[j]],Ch)
  ChinaAr[[j]]<-subset(ChinaAr[[j]],46:50)
  ArStatdf[[j]]<-extract(ChinaAr[[j]],stcoord,df=TRUE)
  ArStatdf[[j]]<-cbind(stcoord1,ArStatdf[[j]][-1])
  colnames(ArStatdf[[j]])[c(4:8)]<-c("2006","2007","2008","2009","2010")
  }
  ArStatdf[[1]]<-cbind(ArStatdf[[1]],dates[[1]],dates[[2]])
  ArStatdf[[2]]<-cbind(ArStatdf[[2]],dates[[3]])                    
  ArStatdf[[3]]<-cbind(ArStatdf[[3]],dates[[4]])
  name<-c("Wheat","Maize","Rice") 
  for (j in 1:3){
    write.csv(ArStatdf[[j]],paste0("C:/Users/Hector/Desktop/PhD/Pengfei/China_AQ_Data/",name[j],"_Area_h-sdates.csv"),row.names=FALSE)
  }
