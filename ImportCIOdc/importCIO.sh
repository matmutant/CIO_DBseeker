#!/bin/bash

#This script imports files from the CIO_SP distribution into a SQLite db for easy search and joins


db="CIO.db" #Name of the output database for the script
pathNameRAW="./CIO_SP" #relative or absolute path of the source files as extracted from latest CIO_SP distribution
pathName="./CIO_SP_UTF8" #relative or absolute path of the source files encoded to UTF-8
dbTables="dbTablesCols.txt"

#Array that contains the TABLENAME (same as the CIO filename) and the colNames
#Syntax: "TABLENAME|colname1 [sql types and attributes (integer, text, .... primary key], colname2 [...], colname3 [...]"

####WARNING: file extracted from CIO_SP/Lisez_moi_v5.3.0 using regex.
####WARNING: for some colnames, e.g.: C/M/S/I, "/" are removed for compatibility, same goes for "-"
mapfile tableCreate < ./$dbTables

if [ ! -d "$pathNameRAW" ]; then
	##Check for source folder
	echo "no $pathNameRAW folder found"
else
	##Prepare workdir and files to be processed
	if [ ! -d "$pathName" ]; then
		echo "making $pathName"
		mkdir "$pathName"
	else
		echo "cleaning up txt files from $pathName"
		rm "$pathName"/*.txt
		rm "$pathName"/*.swp #clean also potential Vim swapfiles
	fi
	##Make it all UTF-8.
	echo "copying txt source files from $pathNameRAW to $pathName"
	cp "$pathNameRAW"/*.txt "$pathName"
	echo "reencoding txt files to UTF-8"
	#find all txt files, launch vim with "--More--" button deactivated, set BOM boolean, reencode to utf_8, write file, quit all.
	find $pathName -type f -name "*.txt" | xargs vim +"set nomore" +"argdo se bomb | se fileencoding=utf-8 | w" +"qa"
	stty sane #reset terminal that might get messed up by Vim full screen mode
	
	
	##cleanup db before importing new data
	if [ -f "./$db" ]; then
		mv ./$db ./old$db
	fi
	##Import some tables to the db
	#loop through tables to create and import content from files
	for i in "${tableCreate[@]}" 
	do
		echo "###################"
		##Parse TABLENAME and column names
		IFS='|' read -ra sqTl <<<"$i" #workaround to nest array in array
		#makes var humanreadable
		tableName=${sqTl[0]} 
		colsName=${sqTl[1]}
		#checking for $tableName.txt exist
		if [ ! -f $pathName/$tableName.txt ]; then
			echo "$tableName.txt is not a valide file."
			echo "aborting import of $tableName table "
		else
		#create table using extracted TABLENAME and columns
			tableNameSQL=${tableName//-/_} #dirty hack to prevent syntax error on import by removing the dash
			colsNameSQL=${colsName//-/_}; colsNameSQL=${colsNameSQL//\//} #yet another dirty hack to prevent syntax error on import by removing the dash and slash
			sqlite3 $db "create table $tableNameSQL ($colsNameSQL)"
			echo "importing $tableName into $db ..."
			#Import file into table
			sqlite3 $db ".import $pathName/$tableName.txt $tableNameSQL"
			echo "done."
		fi
	done
	
	
	##Display some possible use
	echo "example of use: "
	echo '
	sqlite3 CIO.db 
	sqlite> .headers ON
	sqlite> .mode column
	sqlite> select s.Code_UCD, s.nom_commercial Nom, dc_cmpt.libelle_Composant Composant, cmpt.Qte_composant Qté_Comp, uc.libelle_Unite Unité_Comp
		from SPECIALITE s 
  		join COMPOSITION cmpn on (s.Code_UCD = cmpn.Code_UCD) 
		join COMPOSANT cmpt on (cmpn.Code_Composant = cmpt.Code_Composant and cmpn.Code_UCD = cmpt.Code_UCD) 
		join DICO_COMPOSANT dc_cmpt on (cmpt.Code_Composant = dc_cmpt.Code_Composant) 
  		join DICO_UNITE uc on (uc.Code_Unite = cmpt.Code_Unite)
		where s.nom_commercial like '%actrapid%'
'


	sqlite3 $db <<EOF
.headers ON
.mode column
select s.Code_UCD, s.nom_commercial Nom, dc_cmpt.libelle_Composant Composant, cmpt.Qte_composant Qté_Comp, uc.libelle_Unite Unité_Comp
from SPECIALITE s 
join COMPOSITION cmpn on (s.Code_UCD = cmpn.Code_UCD) 
join COMPOSANT cmpt on (cmpn.Code_Composant = cmpt.Code_Composant and cmpn.Code_UCD = cmpt.Code_UCD) 
join DICO_COMPOSANT dc_cmpt on (cmpt.Code_Composant = dc_cmpt.Code_Composant) 
join DICO_UNITE uc on (uc.Code_Unite = cmpt.Code_Unite)
where s.nom_commercial like '%actrapid%'
EOF

####### END OF IF 
fi
####### END OF FILE
