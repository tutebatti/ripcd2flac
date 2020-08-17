#!/bin/bash

########################################
#                                       
#	Script to facilitate ripping multiple CDs to flac files
# based on cdparanoia (https://en.wikipedia.org/wiki/Cdparanoia)                                                                
# 
# A numbered directory in ~/Downloads is created for each CD                   
#                                                                            
########################################

echo "Hello! The CD just inserted is ripped to flac."

echo "----------------------------------------------"

# change to working directory ~/Downloads

cd ~/Downloads

# if CDs have been ripped before, check for highest numbered directory disc-n

if [ ! $(find ./ -maxdepth 0 -type d -regextype posix-extended -regex ".*disc-[1-9]\+[0-9]*") ]

	then

		highestdisc=$(ls | grep ".*disc-[1-9]\+[0-9]*" | sort --version-sort | tail -n 1)

		curdiscnr=$((${highestdisc#disc-}+1))

		echo "Creating folder >>disc-${curdiscnr}<<."

		mkdir ./disc-${curdiscnr}

		n="${curdiscnr}"

# if first CD is ripped, create folder disc-1

	else

		echo "Creating folder >>disc-1<<."

		mkdir ./disc-1

		n="1"

fi

echo "Copying tracks in new folder disc-$n..."

(cd ./disc-${n}; cdparanoia -B)

echo "Converting wav-files to flac..."

find ./disc-${n}/ -iname "*.wav" -execdir flac {} \;

echo "Deleting wav-files..."

find ./disc-${n}/ -iname "*.wav" -delete

echo "CD is ejected..."

eject

echo "Done!"

exit 0
