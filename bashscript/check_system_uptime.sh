#!/bin/bash

while getopts "H:C:w:c:" opts; do
    case $opts in
        H) HOSTNAME=$OPTARG ;;
        C) COMMUNITY=$OPTARG ;;
        w) WARNING=$OPTARG ;;
        c) CRITICAL=$OPTARG ;;
        *) echo "Usage: $0 -H <hostname> -C <community> -w <warning> -c <critical>"
           exit 3 ;;
    esac
done

if [ -z "$HOSTNAME" ] || [ -z "$COMMUNITY" ] || [ -z "$WARNING" ] || [ -z "$CRITICAL" ]; then
    echo "Usage: $0 -H <hostname> -C <community> -w <warning> -c <critical>"
fi

OID=".1.3.6.1.2.1.1.3.0"
SNMP_OUTPUT=$(snmpwalk -v 2c -c $COMMUNITY $HOSTNAME $OID)
# echo $SNMP_OUTPUT
UPTIME=$(echo $SNMP_OUTPUT | awk '{print $5}')
echo "$UPTIME"