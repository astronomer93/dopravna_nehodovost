library(ggplot2)

cosmicColumnName <- c("AE", "AL", "Ap", "AU", "Dst", "Kp", "Lyman", "Sunspot", "Solar", "Proton10", "Proton30", "Proton60", "Temperature", "Density", "Speed", "PCN", "PCS")

nameDirs <- c("AE_index", "AL_index", "Ap_index", "AU_index", "Dst_index", "Kp_index", "Lyman_alpha_index", "R_sunspot_number", "Solar_index_F10.7", "Proton_flux_over_10_MeV", "Proton_flux_over_30_MeV", "Proton_flux_over_60_MeV", "Solar_wind_temperature", "Solar_wind_density", "Solar_wind_speed", "Polar_cap_north", "Polar_cap_south")

cosmicName <- c("AE index", "AL index", "Ap index", "AU index", "Dst index", "Kp index", "Lyman alpha solar index", "R sunspot number", "Solar index_F10.7", "Proton flux over 10 MeV", "Proton flux over 30 MeV", "Proton flux over 60 MeV", "Solar wind temperature", "Solar wind density", "Solar wind speed", "Polar cap north (Thule)", "Polar cap south (Vostok)")


cosmicCount <- 1

for(nameDir in nameDirs)
{
	
	setwd(nameDir)

	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile, collapse='')
	table <- read.csv(nameFile,sep=';')
	changeTable <- table[order(abs(table$Correlation),decreasing=TRUE),]
	write.table(changeTable,file=nameFile,sep=';',append=FALSE,row.names=FALSE,col.names=TRUE)	
	
	nameFile <- c('porovnanie',cosmicColumnName[cosmicCount],'.csv')
	nameFile <- paste(nameFile, collapse='')
	open <- read.csv(nameFile,sep=';')

	Traffic <- open$Traffic
	Correlation <- open$Correlation	
	
	table <- data.frame(Correlation,Traffic)
	ggplot(data=table,aes(x=reorder(Traffic,abs(-Correlation)),y=Correlation, fill=Traffic)) + 
	geom_bar(stat='identity',position='dodge') + 
	geom_text(aes(label=sprintf("%.2f",Correlation),y=Correlation),position = position_dodge(width=1),size=3) +
	coord_flip() + 
	xlab('Typ doprávnej nehodovostí') +
	labs(title=paste(c(cosmicName[cosmicCount],", 2011-2013"),collapse="")) +
	theme(legend.position="none") 
	ggsave(paste(c('porovnanieTypovNehodovosti.jpg'),collapse=""),width=14,quality=50)


	if(file.exists('Rplots.pdf'))
		file.remove('Rplots.pdf')

	setwd('..')

	cosmicCount <- cosmicCount + 1
}
