#!/bin/bash

## Very simple script that tries to mount unauthenticated share drives from a
##   list of IPv4 addresses
## 
## This script runs through a list of IP addresses and tries to log into an SMB
##   share for each one.
## 
## NOTE: This script is currently very basic/quick-and-dirty. Use discretion.

if [ -z "$1" ] || [ $1 == "-h" ] ; then

        # Display the help options
        echo 'Try share login from list of IPs - edit Jan 2016'
        echo 'usage: ./shareLogin.sh ip-list'
        echo ''
        echo 'options:'
        echo '(none) or -h              display help content'
        exit
fi

for LINE in `cat $1 | tr -d '\r'`
do
	echo $LINE
	shareOutput=$(smbclient -L $LINE -U administrator -N)
	echo $shareOutput
	echo "-----------------------------"
done
