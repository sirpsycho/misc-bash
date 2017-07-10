#!/bin/bash

## Simple script for pulling hostnames from a list of IP's
## 
## This script takes a list of IP's (one IP per line) and runs an nslookup
##   on each of them. This is meant to quickly resolve hostnames for a larger
##   number of IP addresses.


if [ -z "$1" ] || [ $1 == "-h" ] ; then

        # Display the help options
        echo 'Get Hostname from list of IPs - edit Jan 2016'
        echo 'usage: ./getHostname.sh ip-list'
        echo ''
        echo 'options:'
        echo '(none) or -h              display help content'
        exit
fi

for LINE in `cat $1 | tr -d '\r'`
do
	echo -n $LINE
	hostname=$(nslookup $LINE | grep name | sed -n -e 's/^.* = //p')
	echo " - "$hostname
done
