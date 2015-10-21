#!/bin/bash

pid_tail=`ps | awk '/ [t]ail/{print $1}'`
#echo $pid_tail
if [[ ! -z "$pid_tail" ]]; then
	kill $pid_tail
fi

pid_tee=`ps | awk '/ [t]ee/{print $1}'`
#echo $pid_tee
if [[ ! -z "$pid_tee" ]]; then 
	kill $pid_tee
fi

process=`ps | awk '/[h]eartBeat/{print $1}'`                                                  
if [[ ! -z "$process" ]]; then
	for i in "${process[@]}"                                                                       
	do
        	kill $i                                                                                
	done
fi

process=`ps | awk '/[p]ktTrans/{print $1}'`                                                  
if [[ ! -z "$process" ]]; then
	for i in "${process[@]}"                                                                       
	do 
        	kill $i                                                                                
	done
fi

process=`ps | awk '/[s]tation/{print $1}'`                                                   
if [[ ! -z "$process" ]]; then
	for i in "${process[@]}"                                                                       
	do
        	kill $i                                                                                
	done
fi

process=`ps | awk '/[t]cpClient/{print $1}'`                                                                                                             
if [[ ! -z "$process" ]]; then                                                                                                                           
        for i in "${process[@]}"                                                                                                                         
        do                                                                                                                                               
        	kill $i                                                                                                                                  
        done                                                                                                                                             
fi   

pid_nc=`ps | awk '/ [n]c/{print $1}'`
#echo $pid_nc
if [[ ! -z "$pid_nc" ]]; then
        kill $pid_nc
fi

rm /tmp/fifo    2>/dev/null
rm /tmp/*.pcap  2>/dev/null
rm /tmp/msglock 2>/dev/null
