#!/bin/bash

routerId=$(cat /etc/routerId)
nonce=`date | md5sum | sed -r 's/([0-9a-zA-Z]+) (.+)/\1/'`
#echo $nonce
signature=`echo -n $(echo -n $nonce; echo -n "61F7B04E443C4F6FA08CD027DF5AC638") | md5sum | sed -r 's/([0-9a-zA-Z]+) (.+)/\1/'`
#echo $signature

while true;
do
	sleep 30
	
	chilli_query list | egrep " pass " | awk '/.+/ { print $1 }' >/tmp/chilli_sta_request
	curl --data-binary @/tmp/chilli_sta_request "http://router.lbsdata.org/chilli/check?nasid=$routerId&nonce=$nonce&signature=$signature" >/tmp/chilli_sta_response 2>/dev/null
	#cat /tmp/chilli_sta_response

	while read line           
	do           
    		sta=`echo $line | sed -r 's/([0-9a-zA-Z]+)=([0-9])/\1/'`
    		result=`echo $line | sed -r 's/([0-9a-zA-Z]+)=([0-9])/\2/'`
    		# echo $sta
    		# echo $result
    		if [[ $result -eq 0 ]]; then
    			chilli_query logout $sta
    		fi
	done </tmp/chilli_sta_response
done
