
open <- read.csv('dataPolar.csv', sep=';')
table <- data.frame(Date=open$Date,Time=open$Time,PCN=open$PCN,PCS=open$PCS)

valueColumn <- c(3,4)
valueReplace <- c(999.00,999.00)

for(i in 1:length(valueColumn))
{

	table[,valueColumn[i]][table[,valueColumn[i]] == valueReplace[i]] <- NA
}

for(col in 3:4)
{
	for(i in 1:length(table[,col]))
	{
		if(is.na(table[i,col]))
		{
			table[i,col] <- table[i-1,col]
		}
	}
}

open <- "hello world"  #aby nedoslo ku konfliktu read/write
write.table(table,file='dataPolar.csv',sep=';',row.names=F,col.names=T,append=F)





