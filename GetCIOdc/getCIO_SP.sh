#!/bin/bash
dir="./CIO_SP"
dirOld="./CIO_SP_OLD"
url=''
us=""
pw=""


if [ ! -d "$dir" ]; then
	echo "making $dir"
	mkdir "$dir"
else
	if [ ! -d "$dirOld" ]; then
		echo "making $dirOld"
		mkdir "$dirOld"
	fi
	for i in '.txt' '.zip'
	do
		echo "mv *.$i to $dirOLD"
		mv $dir/*$i "$dirOld"
	done
fi

cd $dir
wget --user=$us --password=$pw --secure-protocol='auto' $url -O Latest.zip 
unzip ./Latest.zip
