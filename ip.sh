#!/bin/bash

octet=`echo $1 | cut -d "." -f4`
range=`echo $1 | cut -d "." -f1,2,3`

check_range(){
if [ -z $1 ]; then
        echo "No ip entered....exiting"
        exit 0
fi
if [ $octet -le 61 ]; then
        echo "GATEWAY="$range".62"
        elif [[ $octet -ge 63 && $octet -le 125 ]]; then
                echo "GATEWAY="$range".126"
                elif [[ $octet -ge 127 && $octet -le 189 ]]; then
                        echo "GATEWAY="$range".190"
                        else
                                echo "GATEWAY="$range".254"
                                fi


                                }
echo "IPADDR=$1"
check_range $1
echo "NETMASK=255.255.255.192"
