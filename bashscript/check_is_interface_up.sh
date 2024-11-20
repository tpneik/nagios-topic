#!/bin/bash

while getopts "H:C:I:" opt; do
  case $opt in
    H) HOSTNAME=$OPTARG ;;
    C) COMMUNITY=$OPTARG ;;
    I) INTERFACE=$OPTARG ;;
    *) echo "Usage: $0 -H <hostname> -C <community> -I <interface>"
       exit 3 ;;
  esac
done

if [ -z "$HOSTNAME" ] || [ -z "$COMMUNITY" ] || [ -z "$INTERFACE" ]; then
    echo "Usage: $0 <hostname> <community> <interface>"
    exit 3
fi

OID=".1.3.6.1.2.1.2.2.1.8.$INTERFACE"


SNMP_OUTPUT=$(snmpget -v 2c -c $COMMUNITY $HOSTNAME $OID)
STATUS=$(echo $SNMP_OUTPUT | awk '{print $NF}')

if [ "$STATUS" == "up(1)" ]; then
    echo "OK - Interface $INTERFACE is up Heheeh"
    exit 0
elif [ "$STATUS" == "down(2)" ]; then
    echo "CRITICAL - Interface $INTERFACE is down"
    exit 1
fi