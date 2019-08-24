declare -a nameDir=("AE_index" "AL_index" "Ap_index" "AU_index" "Dst_index" "Kp_index" "Lyman_alpha_index" "R_sunspot_number" "Solar_index_F10.7" "Proton_flux_over_10_MeV" "Proton_flux_over_30_MeV" "Proton_flux_over_60_MeV" "Solar_wind_temperature" "Solar_wind_density" "Solar_wind_speed")
declare -a columnName=("AE" "AL" "Ap" "AU" "Dst" "Kp" "Lyman" "Sunspot" "Solar" "Proton10" "Proton30" "Proton60" "Temperature" "Density" "Speed")
declare -a valueColumn=(4 5 6 7 8 9 10 11 12 13 14 15 16 17 18)

wget --post-data "activity=retrieve&res=hour&spacecraft=omni2&start_date=20100101&end_date=20181231&vars=41&vars=52&vars=49&vars=53&vars=40&vars=38&vars=55&vars=39&vars=50&vars=45&vars=46&vars=47&vars=22&vars=23&vars=24&scale=Linear&ymin=&ymax=&view=0&charsize=&xstyle=0&ystyle=0&symbol=0&symsize=&linestyle=solid&table=0&imagex=640&imagey=480&color=&back=" https://omniweb.sci.gsfc.nasa.gov/cgi/nx1.cgi -O data.txt
sed '1,22d' data.txt | sed '78889,90000d' >> nahradny_subor.txt && rm data.txt && mv nahradny_subor.txt data.txt 
 
awk '{print $16}' data.txt | grep -oE '[0-9]{1,15}' >> nahradny_subor1.txt &&
gawk '
FNR==NR { array[NR]=$0; next } 
{ 
	split(array[FNR],fields,FS,separator)
	fields[16]=$1
	for(i=1; i in fields; i++)
		printf "%s%s",fields[i], separator[i]
	print ""
}
' data.txt nahradny_subor1.txt >> nahradny_subor2.txt && rm data.txt && rm nahradny_subor1.txt && mv nahradny_subor2.txt data.txt

awk '{print $18}' data.txt | grep -oE '[0-9]{1,15}' >> nahradny_subor1.txt &&
gawk '
FNR==NR { array[NR]=$0; next } 
{ 
	split(array[FNR],fields,FS,separator)
	fields[18]=$1
	for(i=1; i in fields; i++)
		printf "%s%s",fields[i], separator[i]
	print ""
}
' data.txt nahradny_subor1.txt >> nahradny_subor2.txt && rm data.txt && rm nahradny_subor1.txt && mv nahradny_subor2.txt data.txt


awk '{print $1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9";"$10";"$11";"$12";"$13";"$14";"$15";"$16";"$17";"$18";"}' data.txt >> nahradny_subor.txt && rm data.txt && echo "Year;Day;Hour;AE;AL;Ap;AU;Dst;Kp;Lyman;Sunspot;Solar;Proton10;Proton30;Proton60;Temperature;Density;Speed;" >> data.csv && cat nahradny_subor.txt >> data.csv && rm nahradny_subor.txt
  
Rscript predikcia_dat.r

for count in {0..14}
do
	if [ -d ${nameDir[$count]} ]; then
		rm -r ${nameDir[$count]}
	fi
	
	mkdir ${nameDir[$count]}
	mv data.csv ${nameDir[$count]}
	cd ${nameDir[$count]}

	if [ $count -eq 0 -o $count -eq 1 -o $count -eq 3 ]; then
		maxYear=2016
	else
		maxYear=2018
	fi

	for((rok=2010; rok <= $maxYear; rok++));
	do
		echo "Date;${columnName[$count]};" >> "${rok}${columnName[$count]}.csv"
		declare -a my_array	
		index=0	
		limit=7
		doy=0

		for mesiac in {1..12}
		do
			for den in {1..31}
			do
				if [ \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2007 \) -o \( $den -gt 29 -a $mesiac -eq 2 -a $rok -eq 2008 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2009 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2010 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2011 \) -o \( $den -gt 29 -a $mesiac -eq 2 -a $rok -eq 2012 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2013 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2014 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2015 \) -o \( $den -gt 29 -a $mesiac -eq 2 -a $rok -eq 2016 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2017 \) -o \( $den -gt 28 -a $mesiac -eq 2 -a $rok -eq 2018 \) -o \( $den -gt 30 -a $mesiac -eq 4 \) -o \( $den -gt 30 -a $mesiac -eq 6 \) -o \( $den -gt 30 -a $mesiac -eq 9 \) -o \( $den -gt 30 -a $mesiac -eq 11 \) ] ; then 
					continue		
		
				else	
					
					if [ $den -eq 31 -a $mesiac -eq 12 -a $rok -eq 2018 ]; then 
						continue
					fi
					doy=$((doy+1))
					my_array[index]="${den}.${mesiac}."

					awk -F ';' -v year=$rok '$1 == year' data.csv | awk -F ';' -v day=$doy '$2 == day' | awk -F ';' -v column=${valueColumn[$count]} '{print $column}' | awk '{sum += $1} END {if(NR > 0) printf "%f\n", sum/NR}' >> "docasna_tabulka.txt"


					if [ \( $den -eq 27 -a $mesiac -eq 12 -a $rok -eq 2015 \) ]; then
						limit=11					
					
					elif [ \( $den -eq 28 -a $mesiac -eq 12 -a $rok -eq 2014 \) -o \( $den -eq 7 -a $mesiac -eq 1 -a $rok -eq 2016 \) ]; then
						limit=10	

					elif [ \( $den -eq 7 -a $mesiac -eq 1 -a $rok -eq 2010 \) -o \( $den -eq 7 -a $mesiac -eq 1 -a $rok -eq 2011 \) -o \( $den -eq 29 -a $mesiac -eq 12 -a $rok -eq 2013 \) ]; then
						limit=9 
				
					elif [ \( $den -eq 7 -a $mesiac -eq 1 -a $rok -eq 2012 \) -o \( $den -eq 30 -a $mesiac -eq 12 -a $rok -eq 2012 \) -o \( $den -eq 7 -a $mesiac -eq 1 -a $rok -eq 2017 \) ]; then
						limit=8

					fi

					index=$((index+1))

					if [ $index -eq $limit ]; then 
						awk -v zaciatok=${my_array[0]} -v koniec=${my_array[$index-1]} -v rok=$rok '{sum += $1} END {if(NR > 0) printf "%s-%s%d;%f;\n", zaciatok, koniec, rok, sum/NR}' docasna_tabulka.txt >> ${rok}${columnName[$count]}.csv && rm docasna_tabulka.txt
						index=0
						limit=7
						declare -a my_array
					fi

					if [ \( $den -eq 31 -a $mesiac -eq 12 -a $rok -eq 2010 \) -o \( $den -eq 31 -a $mesiac -eq 12 -a $rok -eq 2011 \) -o \( $den -eq 6 -a $mesiac -eq 1 -a $rok -eq 2013 \) -o \( $den -eq 5 -a $mesiac -eq 1 -a $rok -eq 2014 \) -o \( $den -eq 4 -a $mesiac -eq 1 -a $rok -eq 2015 \) -o \( $den -eq 31 -a $mesiac -eq 12 -a $rok -eq 2016 \) ]; then
						awk -v zaciatok=${my_array[0]} -v koniec=${my_array[$index-1]} -v rok=$rok '{sum += $1} END {if(NR > 0) printf "%s-%s%d;%f;\n", zaciatok, koniec, rok, sum/NR}' docasna_tabulka.txt >> ${rok}${columnName[$count]}.csv && rm docasna_tabulka.txt
						index=0
						limit=7
						declare -a my_array					
					fi

				fi
			done

		done
	done
	mv data.csv ..
	cd ..
done

rm data.csv
