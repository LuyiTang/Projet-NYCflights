install.packages("rio")
library(rio)

library(tidyverse)
install.packages("rio")
library(rio)
rda_2_CSV=c("airports", "airlines", "planes", "airlines", "flights","weather")
for (i in rda_2_CSV) {
  
    path_rda  <- paste("C:/Users/yoyo/Documents/SQL/NYCflights/",i,".rda",sep="")
    filerename <- import(path_rda)
    path_csv <- paste("C:/Users/yoyo/Documents/SQL/NYCflights/",i,".csv",sep="")
    #print(path_csv)
    write.csv(filerename, file = path_csv)
}


airports <- import("C:/Users/yoyo/Documents/SQL/NYCflights/airports.rda")
write.csv(airports, file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airport.csv")

airlines <- import("C:/Users/yoyo/Documents/SQL/NYCflights/airlines.rda")
write.csv(airlines, file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airlines.csv")

planes <- import("C:/Users/yoyo/Documents/SQL/NYCflights/planes.rda")
write.csv(planes, file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/planes.csv")

airlines <- import("C:/Users/yoyo/Documents/SQL/NYCflights/airlines.rda")
write.csv(airlines, file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airlines.csv")





2013-01-01T21:00:00Z | NA       | N18120

