#!/bin/bash

while true;
do
	hour=`date | awk '{ print $4 }' | sed -r 's/([0-9]{2}):[0-9]{2}:[0-9]{2}/\1/'`
	
	if [[ "$hour" -ge 3 && "$hour" -lt 4 ]]; then 
		
		# kill chilli
		process=`ps | awk '/[c]hilli/{print $1}'`                                                                                                             
		if [[ ! -z "$process" ]]; then
		        for i in "${process[@]}"
			do
				kill $i
			done
		fi   
		
		# Restart wifi                        	        
		wifi
		
		# Restart chilli
		/etc/init.d/chilli restart
		
	fi
	
	sleep 3600
done
