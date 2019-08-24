library(ggplot2)
library(gridExtra)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

traffic2Name <- c('Celková dopravná nehodovosť','Zranení','Usmrtení')

trafficColumnName <- c('Nehodovost','Zraneni','Usmrteni')

cosmicColumnName <- c("AE", "AL", "Ap", "AU", "Dst", "Kp", "Lyman", "Sunspot", "Solar", "Proton10", "Proton30", "Proton60", "Temperature", "Density", "Speed")

nameDirs <- c("AE_index", "AL_index", "Ap_index", "AU_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed")

cosmicName <- c("AE index", "AL index", "Ap index", "AU index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed")

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
		unlink('vizualizaciaDat',recursive=T)
		
		dir.create('korelacia')
		dir.create('vizualizaciaDat')

		trafficCount <- trafficCount + 1

		# vizualizacia ciaroveho grafu

		Week <- c()

		for(i in 1:52)
		{
			Week[i] <- i
		}


		for(rok in 2010:2016)
		{
			nameFile <- c('statistika',rok,'.csv')
			nameFile <- paste(nameFile,collapse='')
			nameChart <- c(rok,'_multiple_line_chart.jpg')
			nameChart <- paste(nameChart,collapse='')
			table <- read.csv(nameFile,sep=';')
			traffic <- table[,trafficColumnName[trafficCount]]
			cosmicParameter <- table[,cosmicColumnName[cosmicCount]]
			dt <- data.frame(Week,traffic,cosmicParameter)
		
			graph1 <- ggplot(data=dt) + 
			geom_line(aes(x=Week,y=traffic, group=1, color="blue")) + 
			geom_point(aes(x=Week, y=traffic, group=1, color="blue")) + 	
			xlab("Days") + 
			ylab("Values") + 
			scale_color_manual(labels=c(traffic2Name[trafficCount]),values=c("blue"),name="") + 
			theme(legend.position="top")

			graph2 <- ggplot(data=dt) + 
			geom_line(aes(x=Week, y=cosmicParameter, group=1,color="red")) + 
			geom_point(aes(x=Week, y=cosmicParameter, group=1,color="red")) + 
			xlab("Days") + 
			ylab("Values") + 
			scale_color_manual(labels=c(cosmicName[cosmicCount]),values=c("red"),name="") + 
			theme(legend.position="top")
	 
			graph <- grid.arrange(graph1,graph2,nrow=1,ncol=2)
			ggsave(nameChart,graph,width=14,quality=50)
		}


		# vizualizacia bodoveho grafu

		for(i in 1:52)
		{
			Week[i] <- i
		}

		for(rok in 2010:2016)
		{
			
			nameFile <- c('statistika',rok,'.csv')
			nameFile <- paste(nameFile,collapse='')
			nameChart <- c(rok,'_scatter_plot_chart.jpg')
			nameChart <- paste(nameChart,collapse='')
			table <- read.csv(nameFile,sep=';')
			traffic <- table[,trafficColumnName[trafficCount]]
			cosmicParameter <- table[,cosmicColumnName[cosmicCount]]
			dt <- data.frame(Week,traffic,cosmicParameter)
			
			graph <- ggplot(data=dt) + 
			geom_point(aes(x=cosmicParameter, y=traffic, group=1,color=as.factor(Week))) + 	
			xlab(cosmicName[cosmicCount]) + 
			ylab(traffic2Name[trafficCount]) + 
			scale_color_discrete(name="Week") +
			geom_smooth(aes(x=cosmicParameter,y=traffic),method='lm') +
			ggsave(nameChart,graph,width=14,quality=50)
	
		}

		# vypocet korelacie
		columnNames <- data.frame('Year','Correlation')
		write.table(columnNames,file="Correlation.csv",sep=';',append=FALSE,row.names=FALSE,col.names=FALSE)
		for (rok in 2010:2016)
		{
			nameFile <- c('statistika',rok,'.csv')
			nameFile <- paste(nameFile,collapse="")
			data <- read.csv(nameFile,sep=';')
			x <- data[,trafficColumnName[trafficCount]]
			y <- data[,cosmicColumnName[cosmicCount]]
			correlation <- cor(x,y)
			corData <- data.frame(rok,correlation)
			write.table(corData,file="Correlation.csv",sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)
		}



		# vizualizacia korelacie
		dt <- read.csv("Correlation.csv",sep=';')
		ggplot(data=dt) + 	
		geom_point(aes(x=Year,y=Correlation,group=1,color="farba"),show.legend=FALSE) + 
		xlab("Years") + 
		ylab("Correlation") + 
		scale_color_manual(values=c("blue"))
		ggsave('correlation_plot_chart.jpg',quality=50)
	
		#zaverecne operacie so subormi

		for(rok in 2010:2016)
		{
			nameFile <- c(rok, '_multiple_line_chart.jpg')
			nameFile <- paste(nameFile,collapse="")
			nameFilePath <- c('vizualizaciaDat/',nameFile)
			nameFilePath <- paste(nameFilePath, collapse="")
			file.rename(from=nameFile,to=nameFilePath)
			nameFile <- c(rok,'_scatter_plot_chart.jpg')
			nameFile <- paste(nameFile,collapse="")
			nameFilePath <- c('vizualizaciaDat/',nameFile)
			nameFilePath <- paste(nameFilePath, collapse="")
			file.rename(from=nameFile,to=nameFilePath)
		}

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







































