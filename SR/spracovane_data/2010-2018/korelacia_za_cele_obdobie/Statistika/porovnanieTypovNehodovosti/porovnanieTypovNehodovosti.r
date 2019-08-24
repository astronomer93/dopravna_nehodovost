library(filesstrings)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

traffic2Name <- c('Celková dopravná nehodovosť','Zranení','Usmrtení')

cosmicColumnName <- c("Ap", "Dst", "Kp", "Lyman", "Sunspot", "Solar", "Proton10", "Proton30", "Proton60", "Temperature", "Density", "Speed")

nameDirs <- c("Ap_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed")

cosmicName <- c("Ap index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed")

cosmicCount <- 1

for(nameDir in nameDirs)
{
	
	dir.create(nameDir,showWarnings=F)
	setwd(nameDir)
	
	
	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile,collapse='')
	if(file.exists(nameFile))
		file.remove(nameFile)


	setwd('..')
	setwd('..')
	setwd('..')
	
	setwd('Data')
	setwd(nameDir)

	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile,collapse='')
	nameColumn <- data.frame('Year','Correlation','Traffic')
	write.table(nameColumn,file=nameFile,sep=';',append=FALSE,row.names=FALSE,col.names=FALSE)

	trafficCount <- 0

	for(traffic in trafficName)
	{
		trafficCount <- trafficCount + 1

		nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
		nameFile <- paste(nameFile,collapse='')
		nameFilePath <- c(traffic,'/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd(traffic)

		nameFilePath <- c('korelacia/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd('korelacia')
		
		table <- read.csv(file='Correlation.csv',sep=';')
		openTable <- read.csv(file=nameFile,sep=';')
		regexp <- c('^all')
		regexp <- paste(regexp,collapse='')
		data <- subset(table,grepl(regexp,table$Year))
		df <- data.frame(data$Year,data$Correlation, traffic2Name[trafficCount])
		write.table(df,file=nameFile,sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameDir,'/',traffic,'/korelacia/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameDir,'/',traffic)	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameDir,'/',traffic,'/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")	
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameDir,'/')	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')	
	}
		
	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile,collapse='')
	nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameDir,'/',nameFile)	
	nameFilePath <- paste(nameFilePath,collapse="")
	nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/')	
	nameFilePath1 <- paste(nameFilePath1,collapse="")	
	file.move(nameFilePath,nameFilePath1)
	setwd('..')

	nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/Data/',nameFile)	
	nameFilePath <- paste(nameFilePath,collapse="")
	nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/SR/spracovane_data/2010-2018/','korelacia_za_cele_obdobie/')	
	nameFilePath1 <- paste(nameFilePath1,collapse="")	
	file.move(nameFilePath,nameFilePath1)
	setwd('..')
	
	nameFilePath <- c('Statistika/',nameFile)
	nameFilePath <- paste(nameFilePath,collapse='')
	file.rename(from=nameFile,to=nameFilePath)
	setwd('Statistika')
	
	nameFilePath <- c('porovnanieTypovNehodovosti/',nameFile)
	nameFilePath <- paste(nameFilePath,collapse='')
	file.rename(from=nameFile,to=nameFilePath)
	setwd('porovnanieTypovNehodovosti')
	
	nameFilePath <- c(nameDir,'/',nameFile)
	nameFilePath <- paste(nameFilePath,collapse='')
	file.rename(from=nameFile,to=nameFilePath)

	cosmicCount <- cosmicCount + 1
}


