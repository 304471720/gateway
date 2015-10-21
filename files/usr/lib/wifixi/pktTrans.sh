#!/bin/bash

exec 9>/tmp/msglock

headersize=0

# Get routerId Hex
routerId=`cat /etc/routerId`
routerIdHex=`printf "%.16x" $routerId`
routerIdBin=`echo $routerIdHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\8\7\6\5\4\3\2\1#'| sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
headersize=$(($headersize+8))

# Get version
version=`cat /etc/version`
versionLen=${#version}
versionLenHex=`printf "%.2x" $versionLen | sed 's/^/\\\x/'`
headersize=$(($headersize+1+$versionLen))

# Command (data or beacon)                                                                                                               
command=`printf "%.2x" 1 | sed 's/^/\\\x/'`                                                                                              
headersize=$(($headersize+1))       

# Captured data packets
while true
do

	files=`ls /tmp/*.pcap.unique.part* 2>/dev/null | sort -r`
	for entry in $files
	do
		# Don't transmit and delete the latest pcap file since it can be incomplete
		filesize=$headersize
	    	
		# Packet length
		pcapfilesize=`wc -c $entry | awk {'print $1'}`
		filesize=$(($filesize+$pcapfilesize))

		filesizeHex=`printf "%.8x" $filesize`
		filesizeBin=`echo $filesizeHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
        
		printf "$filesizeBin$routerIdBin$versionLenHex$version$command" > /tmp/tmpHeader

		# Packets
		cat /tmp/tmpHeader $entry >/tmp/tmpPacket
			
		if flock -x 9; then
			cat /tmp/tmpPacket >/dev/udp/up2.lbsdata.org/11234
			flock -u 9
		fi
                
		# Remove file
		rm $entry 2>/dev/null
	done
 
	sleep 1
done
