library(ggplot2)
library(gridExtra)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

traffic2Name <- c('Celková dopravná nehodovosť','Zranení','Usmrtení')

trafficColumnName <- c('Nehodovost','Zraneni','Usmrteni')

cosmicColumnName <- c("Ap", "Dst", "Kp", "Lyman", "Sunspot", "Solar", "Proton10", "Proton30", "Proton60", "Temperature", "Density", "Speed", "PCN", "PCS")

nameDirs <- c("Ap_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed", "Polar_cap_north", "Polar_cap_south")

cosmicName <- c("Ap index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed", "Polar cap north (Thule)", "Polar cap south (Vostok)")

cosmicCount <- 0

for(nameDir in nameDirs)
{
	setwd(nameDir)	

	trafficCount <- 0
	cosmicCount <- cosmicCount + 1	

	for(traffic in trafficName)
	{
		setwd(traffic)

		unlink('korelacia',recursive=T)
		
		dir.create('korelacia')

		trafficCount <- trafficCount + 1


		# vypocet korelacie
		columnNames <- data.frame('Week','Correlation')
		write.table(columnNames,file="Correlation.csv",sep=';',append=FALSE,row.names=FALSE,col.names=FALSE)

		nameFile <- c('statistika.csv')
		table <- read.csv(nameFile,sep=';')

		for(i in 1:417)
		{	
			j <- i + 51		
			data <- table[i:j,]
			x <- data[,trafficColumnName[trafficCount]]
			y <- data[,cosmicColumnName[cosmicCount]]
			correlation <- cor(x,y)
			corData <- data.frame(i,correlation)	
			write.table(corData,file="Correlation.csv",sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)	

		}

		# vizualizacia korelacie
		nameTitle <- paste(c(traffic2Name[trafficCount], '\n', cosmicName[cosmicCount]),collapse='')
		dt <- read.csv("Correlation.csv",sep=';')
		ggplot(data=dt) + 	
		geom_point(aes(x=Week,y=Correlation,group=1,colour="pointColor")) + 
		xlab("1-52, 2-53, 3-54... weeks") + 
		ylab("Correlation") + 
		geom_vline(aes(xintercept=1,linetype="2010"),color="red",show.legend=T) +
		geom_vline(aes(xintercept=53,linetype="2011"),color="orange",show.legend=T) +
		geom_vline(aes(xintercept=105,linetype="2012"),color="yellow",show.legend=T) +
		geom_vline(aes(xintercept=157,linetype="2013"),color="green",show.legend=T) +
		geom_vline(aes(xintercept=209,linetype="2014"),color="violet",show.legend=T) +
		geom_vline(aes(xintercept=261,linetype="2015"),color="grey",show.legend=T) +
		geom_vline(aes(xintercept=313,linetype="2016"),color="black",show.legend=T) +
		geom_vline(aes(xintercept=365,linetype="2017"),color="cyan",show.legend=T) +
		geom_vline(aes(xintercept=417,linetype="2018"),color="pink",show.legend=T) +
		scale_color_manual(values=c("pointColor"="blue")) +						scale_linetype_manual("",values=c("2010"="dashed","2011"="dashed","2012"="dashed","2013"="dashed","2014"="dashed", "2015"="dashed", "2016"="dashed", "2017"="dashed", "2018"="dashed") ,guide=guide_legend(override.aes = list(colour=c("red","orange","yellow","green","violet","grey","black","cyan","pink")))) +
		guides(color=F) +
		labs(title=nameTitle) +		
		ggsave('correlation_plot_chart.jpg',quality=50)

		nameFile <- 'Correlation.csv'
		nameFilePath <- c('korelacia/',nameFile)
		nameFilePath <- paste(nameFilePath, collapse="")
		file.rename(from=nameFile,to=nameFilePath)

		nameFile <- 'correlation_plot_chart.jpg'
		nameFilePath <- c('korelacia/',nameFile)
		nameFilePath <- paste(nameFilePath, collapse="")
		file.rename(from=nameFile,to=nameFilePath)

		if(file.exists('Rplots.pdf'))
			file.remove('Rplots.pdf')			

		setwd('..')
	} 

	setwd('..')
}







































