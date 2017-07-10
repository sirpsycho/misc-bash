#!/bin/bash

## Pulls phone extensions from Cisco IP Phone 7000 series
## 
## This script attemps to get phone extensions from a list of IPv4 addresses.
##   This only works with Cisco IP Phones (7000 series) that have unauthenticated
##   web interfaces accessible via IP address. The -a option attempts to correlate
##   the data found to see "who is talking to who" at a given time.


if [ -z "$1" ] || [ $1 == "-h" ]; then

	# Display the help options
        echo 'Cisco IP Phone Network Scanner - 2016'
        echo 'usage: ./getPhoneExtFromIP ip-address-list [option] (ext file)'
        echo ''
        echo 'options:'
        echo '(none)            if no options are specified, the program will output only phone extensions'
        echo '-h                display help content'
        echo '-a                scan for IP phone info using the extensions found during the scan - recommend for full scans'
        echo '-A [file]         scan for IP phone info using an existing file in [ip-address extension] format'
	exit
fi

# List of IPs to scan
ipList=$1

# are options specified? (-h, -a, -A)
option=$2


extFile=$3


if [[ $option == '-h' ]]; then

	# Display the help options
	echo 'Cisco IP Phone Network Scanner - 2016'
	echo 'usage: ./getPhoneExtFromIP ip-address-list [option] (ext file)'
	echo ''
	echo 'options:'
	echo '(none)		if no options are specified, the program will output only phone extensions'
	echo '-h		display help content'
	echo '-a		scan for IP phone info using the extensions found during the scan - recommend for full scans'
	echo '-A [file]		scan for IP phone info using an existing file in [ip-address extension] format'

elif [ $option == '-A' ] || [ $option == '-a' ] ; then

	echo "Running full scan on $ipList"
	echo $(date)

	# create temporary files and folders in /tmp directory
	printf "" > /tmp/ipPhoneTmp
	if [[ -a /tmp/sites ]]; then
		echo 'Deleting old files and creating new /tmp/sites'
		rm -rf /tmp/sites
		mkdir /tmp/sites
	else
		echo 'Creating initial /tmp/sites...'
		mkdir /tmp/sites
	fi

	echo "Starting scan for phone extensions..."
	for LINE in `cat $ipList | tr -d '\r'`
	do
		echo -n "${LINE} " >> "/tmp/ipPhoneTmp";
		ext="$(wget -q -O - -T 5 "\""$@"\"" $LINE | tr '[:upper:]' '[:lower:]' | grep -A 2 'phone dn' | egrep -o '[ ,>]{1}[0-9]{4}<')"
#		ext="$(wget -q -O - -T 5 "\""$@"\"" "\""${LINE} "\"" | tr '[:upper:]' '[:lower:]' | grep -A 2 'phone dn' | egrep -o '[ ,>]{1}[0-9]{4}<')"
		echo $ext | tr -d '>< ' >> /tmp/ipPhoneTmp
#		ext=$LINE
#		echo $ext >> /tmp/ipPhoneTmp
		echo -n "-"
	done
	echo ""

	# Show the phone extensions file that was just created
	cat /tmp/ipPhoneTmp
	echo ""

	# Pull full info from ipList and displaying the newly found extensions
	echo "Starting scan for calls..."
	echo ""

	for LINE in `cat $ipList | tr -d '\r'`
        do
		# Local IP Address
                echo "IP address : ${LINE} -------"

		# Local Phone Extension
		echo -n "Phone Ext : "
		cat /tmp/ipPhoneTmp | grep "${LINE} " | sed "s/^${LINE} //"
#		cat /tmp/ipPhoneTmp | grep -o -P "${LINE}.{0,1}"

		# Pull down Streaming Statistics page
                site="$(wget -q -O - -T 5 "\""$@"\"" $LINE'/CGI/Java/Serviceability?adapter=device.statistics.streaming.0' | tr '[:upper:]' '[:lower:]')"
		if [[ "$(echo $site | grep -c 'remote address')" == 0 ]]; then
			site="$(wget -q -O - -T 5 "\""$@"\"" $LINE'/StreamingStatistics?1' | tr '[:upper:]' '[:lower:]')"
		fi
#                echo $site | grep -A 2 'remote address' | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1 > /tmp/sites/$LINE
		echo $site > /tmp/sites/$LINE

		# Remote IP Address
		echo -n "Remote IP: "
		remIp="$(cat /tmp/sites/$LINE | grep -A 2 'remote address' | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n1)"
		echo $remIp

		# Remote Extension
		echo -n "Remote Ext: "
		if [[ $option == '-A' ]]; then
			remExt=$(cat $extFile | grep "${remIp} ")
		elif [[ $option == '-a' ]]; then
			remExt=$(cat /tmp/ipPhoneTmp | grep "${remIp} ")
		else
			echo "ERROR"
		fi
		remExt=${remExt#$remIp}
		echo $remExt
#		cat ipToExt.txt | grep $remIp | sed "s/^${remIp} //"

		# Start Time
		echo -n "Start time: "
		startTime="$(cat /tmp/sites/$LINE | grep -A 2 'start time' | egrep -o '[0-9]{1,2}\:[0-9]{1,2}\:[0-9]{1,2}' | head -n1)"
		echo $startTime
		echo ""

        done

else
	echo "-A option NOT recognized"
	echo "Starting scan for phone extensions..."
	for LINE in `cat $ipList | tr -d '\r'`
	do
		echo -n "${LINE} "
		ext=$(wget -q -O - -T 5 "$@" $LINE | tr '[:upper:]' '[:lower:]' | grep -A 2 'phone dn' | egrep -o '[ ,>]{1}[0-9]{4}<')
		echo $ext | tr -d '>< '
	done
fi
