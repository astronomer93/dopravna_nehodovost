library(mice)

open <- read.csv('dataOMNiWeb.csv', sep=';')
table <-   data.frame(Year=open$Year,Day=open$Day,Hour=open$Hour,Ap=open$Ap,Dst=open$Dst,Kp=open$Kp,Lyman=open$Lyman,Sunspot=open$Sunspot,Solar=open$Solar,Proton10=open$Proton10,Proton30=open$Proton30,Proton60=open$Proton60,Temperature=open$Temperature,Density=open$Density,Speed=open$Speed)

valueColumn <- c(9,10,11,12,13,14,15)
valueReplace <- c(999.9,99999.99,99999.99,99999.99,9999999,999.9,9999)

for(i in 1:length(valueColumn))
{

	table[,valueColumn[i]][table[,valueColumn[i]] == valueReplace[i]] <- NA
}

predictTable <- mice(table, m=1, maxit=1, seed=33, method='pmm')
predictTable <- complete(predictTable)

finalTable <- data.frame(Year=open$Year,Day=open$Day,Hour=open$Hour,AE=open$AE,AL=open$AL,Ap=open$Ap,AU=open$AU,Dst=open$Dst,Kp=open$Kp,Lyman=open$Lyman,Sunspot=open$Sunspot,Solar=predictTable$Solar,Proton10=predictTable$Proton10,Proton30=predictTable$Proton30,Proton60=predictTable$Proton60,Temperature=predictTable$Temperature,Density=predictTable$Density,Speed=predictTable$Speed)
open <- "hello world"  #aby nedoslo ku konfliktu read/write
write.table(finalTable,file='dataOMNiWeb.csv',sep=';',row.names=F,col.names=T,append=F)





