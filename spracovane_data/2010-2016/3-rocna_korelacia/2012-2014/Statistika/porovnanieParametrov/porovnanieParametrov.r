library(filesstrings)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

nameDirs <- c("AE_index", "AL_index", "Ap_index", "AU_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed", "Polar_cap_north", "Polar_cap_south")

cosmicName <- c("AE index", "AL index", "Ap index", "AU index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed", "Polar cap north (Thule)", "Polar cap south (Vostok)")

for(traffic in trafficName)
{
	dir.create(traffic,showWarnings=FALSE)
	setwd(traffic)
	
	nameFile <- c('porovnanie.csv')
	nameFile <- paste(nameFile,collapse='')
	if(file.exists(nameFile))
		file.remove(nameFile)
	setwd('..')
}

setwd('..')
setwd('..')
setwd('Data')

for(traffic in trafficName)
{
	cosmicCount <- 1		
	nameFile <- c('porovnanie.csv')
	nameFile <- paste(nameFile,collapse='')
	nameColumn <- data.frame('Year','Correlation','parameter')
	write.table(nameColumn,file=nameFile,sep=';',append=FALSE,row.names=FALSE,col.names=FALSE)
	for(parameter in nameDirs)
	{	
		nameFilePath <- c(parameter,'/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)			
		setwd(parameter)

		nameFilePath <- c(traffic,'/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd(traffic)

		nameFilePath <- c('korelacia','/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd('korelacia')

		openTable <- read.csv(file='Correlation.csv',sep=';')
		regexp <- c('^2012-2014')
		regexp <- paste(regexp,collapse='')
		data <- subset(openTable,grepl(regexp, openTable$Year))
		df <- data.frame(data$Year,data$Correlation, cosmicName[cosmicCount])
		
		write.table(df,file=nameFile,sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)

		cosmicCount <- cosmicCount + 1 

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',parameter,'/',traffic,'/korelacia/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',parameter,'/',traffic)	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',parameter,'/',traffic,'/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',parameter)	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',parameter,'/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/')	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')
	}

		nameFilePath <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/Data/',nameFile)	
		nameFilePath <- paste(nameFilePath,collapse="")
		nameFilePath1 <- c('/home/astronomer93/dopravna_nehodovost/spracovane_data/2010-2016/','3-rocna_korelacia/2012-2014/')	
		nameFilePath1 <- paste(nameFilePath1,collapse="")	
		file.move(nameFilePath,nameFilePath1)
		setwd('..')

		nameFilePath <- c('Statistika/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd('Statistika')


		nameFilePath <- c('porovnanieParametrov/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd('porovnanieParametrov')

		nameFilePath <- c(traffic,'/',nameFile)
		nameFilePath <- paste(nameFilePath,collapse='')
		file.rename(from=nameFile,to=nameFilePath)
		setwd(traffic)	

		setwd('..')
		setwd('..')
		setwd('..')	
		setwd('Data')		
}






