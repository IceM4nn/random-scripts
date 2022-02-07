#!/bin/bash

function usage () {
	echo "Usage: $0 [-i interface] <ip-range>"
	echo ""
	echo "Example: $0 -i eth0 192.168.1.1-12"
	echo "         $0 -i eth0 192.168.1.14"
	exit 0
}

if [ -z "$1" ]; then
	usage
fi

while getopts ":i:" opt; do
	case $opt in
		i)
			interface=$OPTARG
			;;
		:) 
			echo "[!] Option -$OPTARG requires an argument interface." >&2
			exit 1
			;;
		*)
			usage
			;;
	esac
done

address=${@:$OPTIND:1}

if [ -z "$address" ] ; then
	echo  "[!] Address is required" >&2
	exit 1
fi

if [ -z "$interface" ] ; then
	interface=""
elif [[ -f /sys/class/net/$interface/operstate ]]; then
	interface="-I $interface"
else 
	echo "[!] $interface does not exist." >&2
	exit 1
fi

# check for address
if [[ "$address" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)-(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
	read start end <<< $( echo $address | awk -F '.' '{print $4}' | awk -F '-' '{print $1" "$2}' )
	newaddress=$(echo $address | cut -d '.' -f -3)
	echo "[+] showing up hosts"
	for i in $(seq $start $end); do
		ping -c 1 -W 1 "$newaddress.$i" | grep "from" | cut -d " " -f 4 | cut -d ":" -f 1 &
		sleep .03
	done;
elif [[ $address =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$  ]]; then
	ping=$(ping -c 1 -W 1 $interface "$address" | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f 1)
	if [[ -z $ping ]]; then
		echo "Host is down"
	else
		echo "Host is up"
	fi
else
	echo "[!] invalid ip format" >&2
	exit 1
fi
