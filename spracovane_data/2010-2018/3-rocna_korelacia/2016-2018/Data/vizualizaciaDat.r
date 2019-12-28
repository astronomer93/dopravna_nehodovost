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
		unlink('vizualizaciaDat',recursive=T)
		
		dir.create('korelacia')
		dir.create('vizualizaciaDat')

		trafficCount <- trafficCount + 1

		# vizualizacia ciaroveho grafu

		Week <- c()
		count <- 1
		for(i in 1:156)
		{	
			Week[i] <- i
		}

		nameFile <- c('statistika.csv')
		nameFile <- paste(nameFile,collapse='')
		nameChart <- c('multiple_line_chart.jpg')
		nameChart <- paste(nameChart,collapse='')
		table <- read.csv(nameFile,sep=';')
		traffic <- table[,trafficColumnName[trafficCount]]
		cosmicParameter <- table[,cosmicColumnName[cosmicCount]]
		dt <- data.frame(Week,traffic,cosmicParameter)
		
		graph1 <- ggplot(data=dt) + 
		geom_line(aes(x=Week,y=traffic, group=1, color="blue")) + 
		geom_point(aes(x=Week, y=traffic, group=1, color="blue")) + 	
		xlab("Week") + 
		ylab("Value") + 
		scale_color_manual(labels=c(traffic2Name[trafficCount]),values=c("blue"),name="") + 
		theme(legend.position="top")

		graph2 <- ggplot(data=dt) + 
		geom_line(aes(x=Week, y=cosmicParameter, group=1,color="red")) + 
		geom_point(aes(x=Week, y=cosmicParameter, group=1,color="red")) + 
		xlab("Week") + 
		ylab("Value") + 
		scale_color_manual(labels=c(cosmicName[cosmicCount]),values=c("red"),name="") + 
		theme(legend.position="top")
	 
		graph <- grid.arrange(graph1,graph2,nrow=1,ncol=2)
		ggsave(nameChart,graph,width=14,quality=50)
		


		# vizualizacia bodoveho grafu
		Year <- c()
		count <- 2016
		for(i in 1:156)
		{
			if(i == 53 || i == 105 )
				count <- count + 1
			
			Year[i] <- count
		}

			
		nameFile <- c('statistika.csv')
		nameFile <- paste(nameFile,collapse='')
		nameChart <- c('scatter_plot_chart.jpg')
		nameChart <- paste(nameChart,collapse='')
		table <- read.csv(nameFile,sep=';')
		traffic <- table[,trafficColumnName[trafficCount]]
		cosmicParameter <- table[,cosmicColumnName[cosmicCount]]
		dt <- data.frame(Year,traffic,cosmicParameter)
			
		graph <- ggplot(data=dt) + 
		geom_point(aes(x=cosmicParameter, y=traffic, group=1,color=as.factor(Year))) + 	
		xlab(cosmicName[cosmicCount]) + 
		ylab(traffic2Name[trafficCount]) + 
		scale_color_discrete(name="Year") +
		geom_smooth(aes(x=cosmicParameter,y=traffic),method='lm') 
		ggsave(nameChart,graph,width=14,quality=50)

		# vypocet korelacie
		columnNames <- data.frame('Year','Correlation')
		write.table(columnNames,file="Correlation.csv",sep=';',append=FALSE,row.names=FALSE,col.names=FALSE)

		nameFile <- c('statistika.csv')
		nameFile <- paste(nameFile,collapse="")
		data <- read.csv(nameFile,sep=';')
		x <- data[,trafficColumnName[trafficCount]]
		y <- data[,cosmicColumnName[cosmicCount]]
		correlation <- cor(x,y)
		corData <- data.frame('2016-2018',correlation)
		write.table(corData,file="Correlation.csv",sep=';',append=TRUE,row.names=FALSE,col.names=FALSE)

		# vizualizacia korelacie
		dt <- read.csv("Correlation.csv",sep=';')
		ggplot(data=dt) + 	
		geom_point(aes(x=Year,y=Correlation,group=1,color="farba"),show.legend=FALSE) + 
		xlab("Year") + 
		ylab("Correlation") + 
		scale_color_manual(values=c("blue"))
		ggsave('correlation_plot_chart.jpg',quality=50)
	
		#zaverecne operacie so subormi

		nameFile <- c('multiple_line_chart.jpg')
		nameFile <- paste(nameFile,collapse="")
		nameFilePath <- c('vizualizaciaDat/',nameFile)
		nameFilePath <- paste(nameFilePath, collapse="")
		file.rename(from=nameFile,to=nameFilePath)
		nameFile <- c('scatter_plot_chart.jpg')
		nameFile <- paste(nameFile,collapse="")
		nameFilePath <- c('vizualizaciaDat/',nameFile)
		nameFilePath <- paste(nameFilePath, collapse="")
		file.rename(from=nameFile,to=nameFilePath)
		
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







































