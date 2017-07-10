#!/bin/bash

## Example script for testing the use of options in a BASH script
##
## This script is a simple example demonstrating the ability to apply multiple
##   options to a BASH script. These options can be used in any order and in
##   conjunction with each other.


while [[ $# > 0 ]]
do
key="$1"

case $key in
	-a|--aOPTION)
	a=true
	;;
	-b|--bOPTION)
	b=true
	;;
	-c|--cOPTION)
	if [[ "$2" == '-a' ]] ; then
		c="invalid"
	else
		c="$2"
	fi
	shift
	;;
	-h|--hOPTION)
	h=true
	;;
	--default)
	DEFAULT=yes
	;;
	*)
		echo "STAR OPTION"
	;;
esac
shift
done

echo a = "$a"
echo b = "$b"
echo c = "$c"
echo h = "$h"
echo DEFAULT = "$DEFAULT"
echo 1 = "$1"

