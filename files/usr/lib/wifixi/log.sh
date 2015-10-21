#!/bin/bash

routerId=$(cat /etc/routerId)
version=$(cat /etc/version)

logread -f | 
{
    while read line; do
        curl -o /dev/null -d "message=$line&routerId=$routerId&version=$version" http://router.lbsdata.org/logshipper.ashx 1>>/tmp/1.log 2>>/tmp/2.log
    done
}
