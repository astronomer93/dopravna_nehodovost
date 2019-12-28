
declare -a nameDir=("Polar_cap_north" "Polar_cap_south")
declare -a columnName=("PCN" "PCS")
declare -a valueColumn=(3 4)


for count in {0..1}
do
	if [ -d ${nameDir[$count]} ]; then
		rm -r ${nameDir[$count]}
	fi
	
	mkdir ${nameDir[$count]}
	mv dataPolar.csv ${nameDir[$count]}
	cd ${nameDir[$count]}

	maxYear=2018
	
	for((rok=2010; rok <= $maxYear; rok++));
	do
		echo "Date;${columnName[$count]};" >> "${rok}${columnName[$count]}.csv"
		declare -a my_array	
		index=0	
		limit=7

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

					my_array[index]="${den}.${mesiac}."

					if [ \( $den -le 9 \) ]; then
						denChange="0$den"
					
					else 
						denChange="$den"										
					fi

					if [ \( $mesiac -le 9 \) ]; then
						mesiacChange="0$mesiac"
					else
						mesiacChange="$mesiac"
					fi

					grep $rok-$mesiacChange-$denChange dataPolar.csv | awk -F ';' -v column=${valueColumn[$count]} '{print $column}' | awk '{sum += $1} END {if(NR > 0) printf "%f\n", sum/NR}' >> "docasna_tabulka.txt"

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
	mv dataPolar.csv ..
	cd ..
done




