#!/bin/bash

filesize=0

# Get routerId Hex
routerId=`cat /etc/routerId`
routerIdHex=`printf "%.16x" $routerId`
routerIdBin=`echo $routerIdHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\8\7\6\5\4\3\2\1#'| sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`
filesize=$(($filesize+8))

# Get version
version=`cat /etc/version`
versionLen=${#version}
versionLenHex=`printf "%.2x" $versionLen | sed 's/^/\\\x/'`
filesize=$(($filesize+1+$versionLen))

# Command                                  
command=`printf "%.2x" 2 | sed 's/^/\\\x/'` 
filesize=$(($filesize+1))

# File size
filesizeHex=`printf "%.8x" $filesize`
filesizeBin=`echo $filesizeHex | sed -r 's#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})#\4\3\2\1#' | sed 's/\(.\{2\}\)/&\\\\x/g;s/\\\\x$//;s/^/\\\\x/'`

{ printf "$filesizeBin$routerIdBin$versionLenHex$version$command"; } >/tmp/tmpHeartBeat

while true;
do
	cat /tmp/tmpHeartBeat >/dev/udp/up2.lbsdata.org/11234
	sleep 10
done;

