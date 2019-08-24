declare -a nameDir=("AE_index" "AL_index" "Ap_index" "AU_index" "Dst_index" "Kp_index" "Lyman_alpha_index" "R_sunspot_number" "Solar_index_F10.7" "Proton_flux_over_10_MeV" "Proton_flux_over_30_MeV" "Proton_flux_over_60_MeV" "Solar_wind_temperature" "Solar_wind_density" "Solar_wind_speed")
declare -a columnName=("AE" "AL" "Ap" "AU" "Dst" "Kp" "Lyman" "Sunspot" "Solar" "Proton10" "Proton30" "Proton60" "Temperature" "Density" "Speed")

declare -a typeTraffic=("celkova_nehodovost" "zraneni" "usmrteni")
declare -a valueTraffic=("Nehodovost" "Zraneni" "Usmrteni")


for countParameter in {0..14} 
do
	if [ -d ${nameDir[$countParameter]} ]; then
		rm -r ${nameDir[$countParameter]}
	fi
	
	mkdir ${nameDir[$countParameter]}
	cd ${nameDir[$countParameter]}

	for trafficCount in {0..2}
	do
		mkdir ${typeTraffic[$trafficCount]}
		cd ${typeTraffic[$trafficCount]}
		
		for rok in {2010..2016}
		do
			awk -F ';' '{print $2}' /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/parametre_kozmickeho_pocasia/${nameDir[$countParameter]}/${rok}${columnName[$countParameter]}.csv > parameter.txt

			awk -F ';' '{print $1}' /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/dopravna_nehodovost/${rok}/${typeTraffic[$trafficCount]}${rok}.csv > week.txt

			awk -F ';' '{print $2}' /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/dopravna_nehodovost/${rok}/${typeTraffic[$trafficCount]}${rok}.csv > traffic.txt

			paste -d ';' week.txt traffic.txt parameter.txt > statistika${rok}.csv && rm week.txt && rm traffic.txt && rm parameter.txt  	
		done
   		cd ..	
	done
	cd ..	
done

