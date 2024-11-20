#!/bin/bash

while getopts "H:C:w:c:" opt; do
    case $opt in 
        H) HOSTNAME=$OPTARG ;;
        C) COMMUNITY=$OPTARG ;;
        w) WARNING=$OPTARG ;;
        c) CRITICAL=$OPTARG ;;
        *) echo "Usage: $0 -H <hostname> -C <community>"
           exit 3 ;;
    esac
done

if [ -z "$HOSTNAME" ] || [ -z "$COMMUNITY" ]; then
    echo "Usage: $0 -H <hostname> -C <community>"
    exit 3
fi
OID="1.3.6.1.4.1.2021.4"
SNMP_OUTPUT=$(snmpwalk -v 2c -c $COMMUNITY $HOSTNAME $OID)
# echo "$SNMP_OUTPUT"

TOTAL_MEM_REAL=$(echo "$SNMP_OUTPUT" | grep "UCD-SNMP-MIB::memTotalRealX.0" | awk '{print $4}')
TOTAL_MEM_FREE=$(echo "$SNMP_OUTPUT" | grep "UCD-SNMP-MIB::memTotalFree.0" | awk '{print $4}')

percentage=$(echo "scale=4; $TOTAL_MEM_FREE/$TOTAL_MEM_REAL * 100" | bc | cut -d . -f 1)
# echo "$percentage"

if [ "$percentage" -eq "$CRITICAL" ] || [ "$percentage" -gt "$CRITICAL" ]; then
    echo "NOT OK - Disk is at Critical level - $percentage%"
    exit 2
elif [ "$percentage" -gt "$WARNING" ] || [ "$percentage" -eq "$WARNING" ]; then
    echo "NOT OK - Disk is at Warning level - $percentage%"
    exit 1
elif [ "$percentage" -lt "$WARNING" ]; then
    echo "OK - Disk is at OK level - $percentage%"
    exit 0
fi
