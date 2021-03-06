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


awk '{print $1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9";"$10";"$11";"$12";"$13";"$14";"$15";"$16";"$17";"$18";"}' data.txt >> nahradny_subor.txt && rm data.txt && echo "Year;Day;Hour;AE;AL;Ap;AU;Dst;Kp;Lyman;Sunspot;Solar;Proton10;Proton30;Proton60;Temperature;Density;Speed;" >> dataOMNiWeb.csv && cat nahradny_subor.txt >> dataOMNiWeb.csv && rm nahradny_subor.txt
  
Rscript predikcia_datOMNiWeb.r
