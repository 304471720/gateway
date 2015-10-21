#!/bin/bash

while true;
do
	pid_tcpdump=`ps | awk '/ [t]cpdump/{print $1}'`
	if [[ -z "$pid_tcpdump" ]]; then 
#		tcpdump -s0 -i mon0 'type mgt subtype probe-req' -G5 -w /tmp/data%s.pcap || true
		 screen -dmS aaaa tcpdump -s0 -i mon0 'type mgt subtype probe-req' -G5 -w /tmp/data%s.pcap || true
	fi
	sleep 10
done
