declare -a nameDir=("Ap_index" "Dst_index" "Kp_index" "Lyman_alpha_index" "R_sunspot_number" "Solar_index_F10.7" "Proton_flux_over_10_MeV" "Proton_flux_over_30_MeV" "Proton_flux_over_60_MeV" "Solar_wind_temperature" "Solar_wind_density" "Solar_wind_speed")
declare -a columnName=("Ap" "Dst" "Kp" "Lyman" "Sunspot" "Solar" "Proton10" "Proton30" "Proton60" "Temperature" "Density" "Speed")

declare -a typeTraffic=("celkova_nehodovost" "zraneni" "usmrteni")
declare -a valueTraffic=("Nehodovost" "Zraneni" "Usmrteni")


for countParameter in {0..11} 
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
		
		for rok in {2010..2018}
		do			
			if [ $rok -eq 2010 ]; then
				zaciatok=1
				koniec=53
			else
				zaciatok=2
				koniec=53
			fi

			sed -n "${zaciatok},${koniec}p" /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/dopravna_nehodovost/${rok}/${typeTraffic[$trafficCount]}${rok}.csv >> traffic.txt

			sed -n "${zaciatok},${koniec}p" /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/parametre_kozmickeho_pocasia/${nameDir[$countParameter]}/${rok}${columnName[$countParameter]}.csv >> parameter.txt
	
		done
		
		awk -F ';' '{print $2}' parameter.txt > docasny_subor.txt && rm parameter.txt && mv docasny_subor.txt parameter.txt 

		awk -F ';' '{print $1}' traffic.txt > week.txt

		awk -F ';' '{print $2}' traffic.txt > docasny_subor.txt && rm traffic.txt && mv docasny_subor.txt traffic.txt

		paste -d ';' week.txt traffic.txt parameter.txt > statistika.csv && rm week.txt && rm traffic.txt && rm parameter.txt  

   		cd ..	
	done
	cd ..	
done

