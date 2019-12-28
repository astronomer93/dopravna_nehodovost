declare -a nameDir=("AE_index" "AL_index" "Ap_index" "AU_index" "Dst_index" "Kp_index" "Lyman_alpha_index" "R_sunspot_number" "Solar_index_F10.7" "Proton_flux_over_10_MeV" "Proton_flux_over_30_MeV" "Proton_flux_over_60_MeV" "Solar_wind_temperature" "Solar_wind_density" "Solar_wind_speed" "Polar_cap_north" "Polar_cap_south")
declare -a firstColumnName=("AE" "AL" "Ap" "AU" "Dst" "Kp" "Lyman" "Sunspot" "Solar" "Proton10" "Proton30" "Proton60" "Temperature" "Density" "Speed" "PCN" "PCS")
declare -a twoColumnName=("AE" "AL" "Ap" "AU" "Dst" "Kp" "Lyman" "Sunspot" "Solar" "Proton10" "Proton30" "Proton60" "Temperature" "Density" "Speed" "PCN" "PCS")

declare -a typeTraffic=("celkova_nehodovost" "zraneni" "usmrteni")
declare -a valueTraffic=("Nehodovost" "Zraneni" "Usmrteni")


for countParameter in {0..16} 
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
		
		for rok in {2014..2016}
		do
												
			sed -n "2,53p" /home/astronomer93/dopravna_nehodovost/zdrojove_data/dopravna_nehodovost/${rok}/${typeTraffic[$trafficCount]}${rok}.csv >> traffic.txt

			sed -n "2,53p" /home/astronomer93/dopravna_nehodovost/zdrojove_data/parametre_kozmickeho_pocasia/${nameDir[$countParameter]}/${rok}${firstColumnName[$countParameter]}.csv >> parameter.txt
	
		done
		
		awk -F ';' '{print $2}' parameter.txt > docasny_subor.txt && rm parameter.txt && mv docasny_subor.txt parameter.txt 

		awk -F ';' '{print $1}' traffic.txt > week.txt

		awk -F ';' '{print $2}' traffic.txt > docasny_subor.txt && rm traffic.txt && mv docasny_subor.txt traffic.txt

		echo "Week;${valueTraffic[$trafficCount]};${twoColumnName[$countParameter]};" >> statistika.csv
		paste -d ';' week.txt traffic.txt parameter.txt >> statistika.csv && rm week.txt && rm traffic.txt && rm parameter.txt  

   		cd ..	
	done
	cd ..	
done

