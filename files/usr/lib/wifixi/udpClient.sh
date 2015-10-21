#!/bin/bash

exec 9>/tmp/msglock
while true; do
	if flock -n -x 9; then
		cat /tmp/fifo >/dev/udp/up2.lbsdata.org/11234 2>/dev/null
		#cat /tmp/fifo >/dev/udp/10.19.0.4/9999 2>/dev/null
		rm /tmp/fifo  2>/dev/null
		flock -u 9
		sleep 1
	fi
done
