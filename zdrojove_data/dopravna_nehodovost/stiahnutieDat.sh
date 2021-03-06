# odstranenie priecinov
for rok in {2010..2018}
do	
	if [ -d $rok ]; then 
		rm -r $rok
	fi 
done

# stiahnutie dat dopravnej nehodovosti 
mkdir 2010and2011
cd 2010and2011
wget -r -A pdf -l 1 "https://www.minv.sk/?tyzdenna_nehodovost_2011" 
cd ..

mkdir 2012
cd 2012
wget -r -A pdf -l 1 "https://www.minv.sk/?nehodovost_v_tyzdni_2012" 
cd ..

mkdir 2013
cd 2013 
wget -r -A pdf -l 1 "https://www.minv.sk/?dopravna-nehodovost-podla-tyzdnov" 
cd ..

mkdir 2014
cd 2014
wget -r -A pdf -l 1 "https://www.minv.sk/?tyzden-2014" 
cd ..

mkdir 2015
cd 2015
wget -r -A pdf -l 1 "https://www.minv.sk/?tyzden_2015" 
cd ..

mkdir 2016
cd 2016
wget -r -l 1 "https://www.minv.sk/?tyzden-2016" 
cd ..

mkdir 2017
cd 2017
wget -r -l 1 "https://www.minv.sk/?2017-2" 
cd ..

mkdir 2018 
cd 2018
wget -r -l 1 "https://www.minv.sk/?tyzden-2018" 
cd ..

# manipulacia so subormi a ich premenovanie
for rok in {2011..2015}
do
	if [ $rok -eq 2011 ]; then

		cd 2010and$rok/www.minv.sk/swift_data/source/policia/dopravna_policia/tyzdenne_nehody/ 
		mv *.pdf ..

		for num in {1..5}
		do
			cd ..
			mv *.pdf ..
		done
		cd ..
		rm -r www.minv.sk
	
	else	
		cd $rok/www.minv.sk/swift_data/source/policia/dopravna_policia/tyzdenne_nehody/$rok
		mv *.pdf ..

		for num in {1..6}
		do
			cd ..
			mv *.pdf ..
		done
		cd ..
		rm -r www.minv.sk 	
	fi 
	rename 's/^\d+\K\.? *tyzd?en.*\.pdf/\.tyzden\.'$rok'\.pdf/' *.pdf
	cd ..
done

# manipulacia so subormi pre priecinky 2016, 2017 a 2018
shopt -s extglob #zapneme extglob, aby fungovalo vymazanie vsetkych suborov, ktore su mimo match regex

for rok in {2016..2018}
do
	cd $rok/www.minv.sk
	rm -r swift_data

	if [ $rok -eq 2017 ]; then
		rm !(*$rok-2&subor*)
	else
		rm !(*tyzden-$rok&subor*)
	fi

	mv * ..
	cd ..
	rm -r www.minv.sk
	cd ..
done

#zmenime nazvy suborov pre priecinky 2016, 2017 a 2018 
for rok in {2016..2018} 
do 
	cd $rok
	for file in /home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/dopravna_nehodovost/$rok/*; do
		tyzdenValue=$(pdftotext -raw $file - | grep 'roka' | head -1 | egrep -o '^[0-9]{1,2}\.')
		newName="/home/astronomer93/dopravna_nehodovost/SR/zdrojove_data/dopravna_nehodovost/$rok/${tyzdenValue}tyzden.${rok}.pdf"
		oldName="$file"
		mv $oldName $newName
	done
	cd ..
done

#vymazanie a premenovanie suborov pre priecinky 2010and2011, 2012 a 2013
for rok in {2011..2013} 
do 
	if [ $rok -eq 2011 ]; then
		cd 2010and$rok
		rm !(*tyzden*)	
	
	elif [ $rok -eq 2012 ]; then
		cd $rok		
		rm 52.tyzden.2012.pdf
		rename 's/^UN52.*/52.tyzden.2012.pdf/' UN52*
	
	elif [ $rok -eq 2013 ]; then
		cd $rok
		rename 's/^n16.*/16.tyzden.2013.pdf/' n16*
	fi		
	cd ..
done

#rozdelenie priecinku 2010and2011 na 2010 a 2011 a premenovanie suborov v priecinku 2010
cp -r 2010and2011 2010
mv 2010and2011 2011

#ziskanie statistiky 
cd 2010
rename 's/^\d+\K\.tyzden\.2011\.pdf/\.tyzden\.2010\.pdf/' *.pdf
cd ..

for rok in {2010..2018}
do
	cd $rok

	nameColumn="Week;Nehodovost;"	
	echo $nameColumn >> celkova_nehodovost${rok}.csv

	nameColumn="Week;Zraneni;"	
	echo $nameColumn >> zraneni${rok}.csv

	nameColumn="Week;Usmrteni;"	
	echo $nameColumn >> usmrteni${rok}.csv

	for week in {1..52} 
	do
		
		tyzdenValue=$(pdftotext -raw ${week}.tyzden.${rok}.pdf - | grep 'roka' | head -1 | egrep -o '^[0-9]{1,2}')
		weekly="${tyzdenValue}.tyzden.${rok}"

		trafficValue=$(pdftotext -raw ${week}.tyzden.${rok}.pdf - | grep -A2 nehody | head -3 | grep "$rok" | egrep -o '[0-9]{1,4}$')
		rowTraffic="${weekly};${trafficValue};"
		echo $rowTraffic >> celkova_nehodovost${rok}.csv

		zraneniValue=$(pdftotext -raw ${week}.tyzden.${rok}.pdf - | grep -A2 zranení | head -3 | grep "$rok" | egrep -o '[0-9]{1,4}$')
		rowZraneni="${weekly};${zraneniValue};"
		echo $rowZraneni >> zraneni${rok}.csv

		if [ $rok -eq 2010 ]; then
			usmrteniValue=$(pdftotext -raw ${week}.tyzden.${rok}.pdf - | grep -A2 Usmrtení | head -3 | grep "$rok" | egrep -o '[0-9]{1,4}$')
				
		else 
			usmrteniValue=$(pdftotext -raw ${week}.tyzden.${rok}.pdf - | grep -A2 Usmrtení | head -3 | grep "$rok" | egrep -o '[0-9]{1,3}\/[0-9]{1,3}\/[0-9]{1,3}\/[0-9]{1,3}$' | egrep -o '[0-9]{1,3}' | awk 'BEGIN {num=0;}{num+=$1;} END {print num}')			
		fi
		rowUsmrteni="${weekly};${usmrteniValue};"
		echo $rowUsmrteni >> usmrteni${rok}.csv
	done

	mkdir povodne_tabulky
	mv *.pdf povodne_tabulky
	cd ..
done

