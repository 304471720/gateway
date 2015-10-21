#!/bin/bash

#exec 9>/tmp/msglock

version=`cat /etc/version`
versionLen=${#version}
versionLenHex=`printf "%.2x" $versionLen | sed 's/^/\\\x/'`

filesize=$((1+1+$versionLen+8))
filesizeHex=`printf "%.8x" $filesize`
filesizeBin=`echo $filesizeHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
command=`printf "%.2x" 3 | sed 's/^/\\\x/'` 
routerId=`cat /etc/routerId`
routerIdHex=`printf "%.16x" $routerId`
routerIdBin=`echo $routerIdHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\8\7\6\5\4\3\2\1#'| sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`

#i=0

{
exec 9>/tmp/msglock
while true; do
	if flock -n -x 9; then
		# echo "tcpClient-2: enter critical region" >>/tmp/tcplog
		# echo $i >> /tmp/tcplog
		# i=$(($i+1))
		
		# cat will be blocked if the pipe is full in case that the connection
		# is inactive for long time
		cat /tmp/fifo 2>/dev/null
		rm /tmp/fifo  2>/dev/null
		# echo "tcpClient-2: leave critical region" >>/tmp/tcplog
		flock -u 9
		sleep 1
	fi
done } | {
	exec 9>/tmp/msglock
	while true; do
   		# Set the MAC for the initial connection
    		if flock -x 9; then
    			# echo "tcpClient: enter critical region" >>/tmp/tcplog
    			rm /tmp/fifo 2>/dev/null
    			/usr/bin/dd iflag=nonblock of=/dev/null 2>/dev/null
    			
    			# sleep 5
    			{ printf "$filesizeBin$command$versionLenHex$version$routerIdBin"; } >/tmp/fifo
			# cat /tmp/fifo >> /tmp/tcplog
    			# echo "tcpClient: leave critical region" >>/tmp/tcplog
    			flock -u 9
    		fi
    		
    		# By default, nc is going to quit 15 minutes after the connection is lost
		nc up2.lbsdata.org 11201
		
		# flush the stdin buffer if the connection is lost to avoid deadlock
		# because cat /tmp/fifo may get blocked
		/usr/bin/dd iflag=nonblock of=/dev/null 2>/dev/null 
		    
	done
	}
