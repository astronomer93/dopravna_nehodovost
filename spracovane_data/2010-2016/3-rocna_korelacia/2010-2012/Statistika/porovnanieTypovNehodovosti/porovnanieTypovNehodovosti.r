library(filesstrings)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

traffic2Name <- c('Celková dopravná nehodovosť','Zranení','Usmrtení')

cosmicColumnName <- c("AE", "AL", "Ap", "AU", "Dst", "Kp", "Lyman", "Sunspot", "Solar", "Proton10", "Proton30", "Proton60", "Temperature", "Density", "Speed", "PCN", "PCS")

nameDirs <- c("AE_index", "AL_index", "Ap_index", "AU_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed", "Polar_cap_north", "Polar_cap_south")

cosmicName <- c("AE index", "AL index", "Ap index", "AU index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed", "Polar cap north (Thule)", "Polar cap south (Vostok)")

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
		regexp <- c('^2010-2012')
		regexp <- paste(regexp,collapse='')
		data <- subset(table,grepl(regexp,table$Year))
		df <- data.frame(data$Year,data$Correlation, traffic2Name[trafficCount])
		write.table(df,file=nameFile,sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameDir,'/',traffic,'/korelacia/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameDir,'/',traffic)	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameDir,'/',traffic,'/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")	
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameDir,'/')	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')	
	}
		
	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile,collapse='')
	nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameDir,'/',nameFile)	
	nameFilePath <- paste(nameFilePath,collapse="")
	nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/')	
	nameFilePath1 <- paste(nameFilePath1,collapse="")	
	file.move(nameFilePath,nameFilePath1)
	setwd('..')

	nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/Data/',nameFile)	
	nameFilePath <- paste(nameFilePath,collapse="")
	nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2010-2012/')	
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


