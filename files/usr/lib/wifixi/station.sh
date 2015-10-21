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

while true;
do

	filesize=$headersize

	iw dev wlan0 station dump >/tmp/station
	iw dev wlan0-1 station dump >>/tmp/station
	mac=(`cat /tmp/station | grep Station | awk '/Station .+/ { print $2 }'`)
	numStation=${#mac[@]}
	
	inactiveTime=(`cat /tmp/station | grep 'inactive time' | awk '/.+/ { print $3 }'`)
	rxBytes=(`cat /tmp/station | grep 'rx bytes' | awk '/.+/ { print $3 }'`)          
	rxPkts=(`cat /tmp/station | grep 'rx packets' | awk '/.+/ { print $3 }'`)         
	txBytes=(`cat /tmp/station | grep 'tx bytes' | awk '/.+/ { print $3 }'`)          
	txPkts=(`cat /tmp/station | grep 'tx packets' | awk '/.+/ { print $3 }'`)         
	txRetries=(`cat /tmp/station | grep 'tx retries' | awk '/.+/ { print $3 }'`)      
	txFailed=(`cat /tmp/station | grep 'tx failed' | awk '/.+/ { print $3 }'`)        
	signal=(`cat /tmp/station | grep 'signal:' | awk '/.+/ { print $2 }'`)            
	signalAvg=(`cat /tmp/station | grep 'signal avg:' | awk '/.+/ { print $3 }'`)

	# send one station in one UDP packet
	# 46 is the length of contents for each station
	filesize=$(($filesize+46))
	
	command=`printf "%.2x" 4 | sed 's/^/\\\x/'`
	filesize=$(($filesize+1))
	
	numPkts=`printf "%.2x" 1 | sed 's/^/\\\x/'`
	filesize=$(($filesize+1))
	
	filesizeHex=`printf "%.8x" $filesize`
	filesizeBin=`echo $filesizeHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
	
	for (( i=0; i<$numStation; i++ ))
	do
		frame=$filesizeBin$routerIdBin$versionLenHex$version$command$numPkts

		pktLenHex=`printf "%.4x" 44 | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})#\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
		#echo $pktLenHex
		
		#echo ${mac[$i]}
		macHex=`echo ${mac[$i]} | sed -r 's#([0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2}):([0-9a-fA-F]{2})#\6\5\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
		#echo $macHex
		
		#echo $inactiveTime
		inactiveTimeHex=`printf "%.8x" ${inactiveTime[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
		#echo $inactiveTimeHex
		
		#echo $rxBytes
		rxBytesHex=`printf "%.16x" ${rxBytes[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\8\7\6\5\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
		#echo $rxBytesHex
		
		#echo $rxPkts                                                                                                                           
		rxPktsHex=`printf "%.8x" ${rxPkts[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'` 
		#echo $rxPktsHex 
		
		#echo $txBytes                                                                                                                            
		txBytesHex=`printf "%.16x" ${txBytes[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\8\7\6\5\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'` 
		#echo $txBytesHex                                                                                                                         
		
		#echo $txPkts                                                                                                                             
		txPktsHex=`printf "%.8x" ${txPkts[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
		#echo $txPktsHex
		
		#echo $txRetries
		txRetriesHex=`printf "%.8x" ${txRetries[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'` 
		#echo $txRetriesHex
		
		#echo $txFailed
		txFailedHex=`printf "%.8x" ${txFailed[$i]} | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'` 
		#echo $txFailedHex
		
		#echo $signal
		if [[ ${signal[$i]} -ge 0 ]]; then
			signalHex=`printf "%.2x" ${signal[$i]} | sed 's/^/\\\x/'`
		else
			signalHex=`printf "%.2x" $(( 256 + ${signal[$i]} )) | sed 's/^/\\\x/'`
		fi
		#echo $signalHex
		
		#echo $signalAvg
		if [[ ${signalAvg[$i]} -ge 0 ]]; then
			signalAvgHex=`printf "%.2x" ${signalAvg[$i]} | sed 's/^/\\\x/'`
		else
			signalAvgHex=`printf "%.2x" $(( 256 + ${signalAvg[$i]} )) | sed 's/^/\\\x/'`
		fi
		#echo $signalAvgHex
		
		frame=$frame$pktLenHex$macHex$inactiveTimeHex$rxBytesHex$rxPktsHex$txBytesHex$txPktsHex$txRetriesHex$txFailedHex$signalHex$signalAvgHex

		printf $frame >/tmp/tmpStation
		if flock -x 9; then
			cat /tmp/tmpStation >/dev/udp/up2.lbsdata.org/11234
			flock -u 9
        fi
	done
	
	sleep 15
done
