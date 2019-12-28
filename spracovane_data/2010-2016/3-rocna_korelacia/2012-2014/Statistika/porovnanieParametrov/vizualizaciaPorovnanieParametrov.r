library(ggplot2)

trafficName <- c('celkova_nehodovost','zraneni','usmrteni')

traffic2Name <- c('Celková dopravná nehodovosť','Zranení','Usmrtení')

trafficCount <- 0

for(traffic in trafficName)
{
		trafficCount <- trafficCount + 1 	
		setwd(traffic)	
		nameFile <- c('porovnanie.csv')
		nameFile <- paste(nameFile,collapse='')
		namePics <- c('porovnanieParametrov.jpg')
		namePics <- paste(namePics,collapse='')
		nameTitle <- c(traffic2Name[trafficCount],', 2012-2014')
		nameTitle <- paste(nameTitle,collapse='')
		table <- read.csv(nameFile,sep=';')
		changeTable <- table[order(abs(table$Correlation),decreasing=TRUE),]
		write.table(changeTable,file=nameFile,sep=';',append=FALSE,row.names=FALSE,col.names=TRUE)	

		Parameter <- table$parameter
		Correlation <- table$Correlation

		table <- data.frame(Correlation,Parameter)
		ggplot(data=table,aes(x=reorder(Parameter,abs(-Correlation)),y=Correlation, fill=Parameter)) + 
		geom_bar(stat='identity',position='dodge') + 
		geom_text(aes(label=sprintf("%.2f",Correlation),y=Correlation),position = position_dodge(width=1),size=3) +
		coord_flip() + 
		xlab('Parameter of cosmic weather') +
		labs(title=nameTitle) +
		theme(legend.position="none") 
		ggsave(namePics,width=14,quality=50)
		setwd('..')

	if(file.exists('Rplots.pdf'))
		file.remove('Rplots.pdf')
}
