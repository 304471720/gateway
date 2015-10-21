#!/bin/bash

. /usr/lib/wifixi/functions.sh

while true;
do
	sleep 600
	
	# RAM usage monitoring
	tmpfsUsage=$(df | grep " /tmp" | awk '/.+/{ print $5}' | sed -r 's/([0-9]+)(%)/\1/')
	if [ "$tmpfsUsage" -gt 80 ]; then
		logger -p user.warning -t "sysMonitor" "tmpfs usage is $tmpfsUsage percent"
	fi
	
	jffs2Usage=$(df | grep " /overlay" | awk '/.+/{ print $5}' | sed -r 's/([0-9]+)(%)/\1/')
	if [ "$jffs2Usage" -gt 80 ]; then
		logger -p user.warning -t "sysMonitor" "jffs2 usage is $jffs2Usage percent"
	fi
	
	# CPU usage monitoring
	
	# Process monitoring
	process=$(ps | awk '/[h]eartBeat/{print $1}')
	if [[ -z $process ]]; then
		logger -p user.error -t "sysMonitor" "heartBeat process doesn't exist"
	fi
	
	process=$(ps | awk '/[s]tation/{print $1}')
	if [[ -z $process ]]; then
		logger -p user.error -t "sysMonitor" "station process doesn't exist"
	fi
	        
	process=$(ps | awk '/[p]ktDump.sh/{print $1}')
	if [[ -z $process ]]; then
		logger -p user.error -t "sysMonitor" "pktDump process doesn't exist"
	fi
        
	process=$(ps | awk '/[p]ktTrans.sh/{print $1}')
	if [[ -z $process ]]; then
		logger -p user.error -t "sysMonitor" "pktTrans process doesn't exist"
	fi
	
	process=$(ps | awk '/[p]ktPostProcess/{print $1}')
	if [[ -z $process ]]; then
		logger -p user.error -t "sysMonitor" "pktPostProcess process doesn't exist" 
	fi
	
done

