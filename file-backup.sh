#!/bin/bash

## Simple script for creating backups
## 
## Example: ./file-backup.sh file-to-be-backed-up
## Result: Creates a copy of the file in the "backup" directory and appends a timestamp
##
## NOTE: Currently, you need to execute this commmand from within the directory "/root/Scripts/"
##   and a directory named "backups" needs to exist inside this directory. You can change
##   "/root/Scripts/" to whatever directory you want as long as 1) the file you are backing up
##   exists in that directory and 2) the "backups" directory exists inside that directory.


if [ -z "$1" ] || [ $1 == "-h" ] ; then

        # Display the help options
        echo 'File backup script - edit Jan 2016'
        echo 'usage: ./file-backup.sh (-d) filename'
        echo ''
        echo 'options:'
        echo '(none) or -h		display help content'
        echo '-d			delete original file after making backup'
	exit
fi

if [ $1 == "-d" ]; then
	filenameCurr=$2
else
	filenameCurr=$1
fi

directory="/root/Scripts/"

_now=$(date +"-%m_%d_%Y-%T")

if [ -z ${filenameCurr+x} ]; then

	echo "ERROR - enter a file name to backup"

else

	if [ -f "$directory$filenameCurr" ]; then

		cp $directory$filenameCurr "$directory"backups/"$filenameCurr$_now" && echo "created $directory"backups/"$filenameCurr$_now"
		if [ $1 == "-d" ]; then
			rm $directory$filenameCurr && echo "removed "$directory$filenameCurr
		fi
	else

		echo "ERROR - '$filenameCurr' not found in '$directory'"

	fi

fi
