#!/bin/bash

## Example script for parsing and validating an IP address
##
## This script takes an IPv4 address and stores each octet in a separate variable.
##   It also does basic error checking to verify that the IP is valid.


ip=$1

## Checks if input is four 1-2-or-3-digit numbers separated by periods
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

	## Pulls each octet from the original string
	x=$ip
	oct1=${x%%.*}
	echo x"$oct1"x
	x=${x#*.*}
	oct2=${x%%.*}
	echo x"$oct2"x
	x=${x#*.*}
	oct3=${x%%.*}
	echo x"$oct3"x
	x=${x#*.*}
	oct4=${x%%.*}
	echo x"$oct4"x

	## Check to see if each octet is less than or equal to 255
	if [ $oct1 -le 255 ]; then
		if [ $oct2 -le 255 ]; then
        		if [ $oct3 -le 255 ]; then
        			if [ $oct4 -le 255 ]; then
        				## If all checks pass, the ip is valid.
                			echo "Valid IP Address"
				else
					echo "Invalid IP Address - 4th octet over 255"
				fi
			else
				echo "Invalid IP Address - 3rd octet over 255"
			fi
		else
			echo "Invalid IP Address - 2nd octet over 255"
		fi
        else
		echo "Invalid IP Address - 1st octet over 255"
        fi
else
	echo "invalid IP range (format - x.x.x.x)"
fi
