#!/bin/bash

process=$1
pid=`ps | grep wifixi | awk "/$process/"'{print $1}'`

if [[ ! -z "$pid" ]]; then
	for i in "${pid[@]}"
	do
		kill $i
	done
fi
