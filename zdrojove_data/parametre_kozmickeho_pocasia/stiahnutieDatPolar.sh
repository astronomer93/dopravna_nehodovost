
echo "Date;Time;PCN;PCS;" >> dataPolar.csv

for rok in {2010..2018}
do
	wget -r -A .zip --post-data "type=file&t1=$rok-01-01 00:00&t2=$((rok+1))-01-01 00:00" https://pcindex.org/archive

	cd pcindex.org
	cd tmp

	unzip \*.zip
	mv *.txt data.txt
	mv data.txt ..
	cd ..
	mv data.txt ..
	cd ..
	rm -r pcindex.org

	sed -n '2,$p' data.txt >> docasny_subor.txt && rm data.txt && awk '{print $1";"$2";"$3";"$4";"}' docasny_subor.txt >> dataPolar.csv
	
	rm docasny_subor.txt
done

Rscript predikcia_datPolar.r

wc -l dataPolar.csv




