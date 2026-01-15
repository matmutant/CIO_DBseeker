#!/bin/bash
dir="./CIO_DC"
dirOld="./CIO_DC_OLD"
url=''
#username
us=""
#password
pw=""
#date
NOW=$( date '+%F_%H-%M-%S' )
#logdir
logd="./logs"
#logfile
W=$( date '+%F_%H:%M:%S' )
logf="${logd}/log_CIOdc_Get_${NOW}.txt"

if [ ! -d "$logd" ]; then
	echo "making $logd"
	mkdir "$logd"
fi

if (( $SHLVL < 3 )) 
then 
	    /usr/bin/script -c "/bin/bash -c '$0 $*'" $logf
	        exit 0
fi

if [ ! -d "$dir" ]; then
	echo "making $dir"
	mkdir "$dir"
fi
if [ ! -d "$dirOld" ]; then
	echo "making $dirOld"
	mkdir "$dirOld"
fi
	for i in '.zip' '.txt'
	do
		echo "mv *.$i to $dirOLD"
		mv $dir/*$i "$dirOld"
	done

cd $dir
wget --user=$us --password=$pw --secure-protocol='auto' $url -O Latest.zip 
unzip ./Latest.zip

#adding date of distrib and date of download
touch DATE.txt
line=$(head -n 1 DISTRIB.txt)
timestamp=$(echo "$line" | cut -d '|' -f 6)
echo $line
echo $timestamp
echo "$timestamp|$NOW" > DATE.txt
