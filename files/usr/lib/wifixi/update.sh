#!/bin/bash

routerId=`cat /etc/routerId`

while true;
do
    wget http://router.lbsdata.org/upgrade/attitude_adjustment/12.09/ar71xx/$routerId/upgrade_script.sh -P /tmp 2>/dev/null
    # wget http://122.224.70.237/upgrade/upgrade_script.sh -P /tmp 2>/dev/null
    # wget http://192.168.21.220/upgrade/upgrade_script.sh -P /tmp 2>/dev/null
    if [ -e "/tmp/upgrade_script.sh" ]; then
 	   chmod 755 /tmp/upgrade_script.sh
    	   /tmp/upgrade_script.sh
    fi
    sleep 600
done

