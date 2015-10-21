#!/bin/bash

while true
do
	files=`ls /tmp/*.pcap 2>/dev/null | sort -r`
	i=0
	for entry in $files
	do
		# Don't transmit and delete the latest pcap file since it can be incomplete
		if [ "$i" -gt 0 ]; then
			# Remove duplicate files in the pcap file
			pcapunique $entry
			rm $entry 2>/dev/null
			
			# Split the unique file if it is too large
			unique="$entry.unique"
			pcapfilesize=`wc -c $unique | awk {'print $1'}`
			pcapsplit $unique 2048
			rm $unique 2>/dev/null
		fi
		
		let "i += 1"
	done
	sleep 1
done
