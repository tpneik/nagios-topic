#!/bin/bash

while getopts "H:p:w:c:" opt; do
    case $opt in
        H) HOST=$OPTARG ;;
        p) PARTITION=$OPTARG ;;
        w) WARNING=$OPTARG ;;
        c) CRITICAL=$OPTARG ;;
        *) echo "Lack of param" | exit 3 ;;
    esac
done

if [ -z "$HOST" ] || [ -z "$PARTITION" ]; then
    echo "Usage: $0 -H <host> -C <partition>"
    exit 3
fi

OID="1.3.6.1.2.1.25.2.3.1"
SNMP_OUTPUT=$(snmpwalk -v 2c -c Str0ngC0mmunity $HOST $OID)

# Take number of partitions
num_partitions=$(echo "$SNMP_OUTPUT" | awk -v target="$PARTITION" '$NF == target' | awk '{print $1}' | tr '.' '\n' | tail -n 1)
# OID_num_partitions=$(echo "$SNMP_OUTPUT" | awk -F. '{print $NF}')
# echo "$num_partitions"

data=$(echo "$SNMP_OUTPUT" | grep ".$num_partitions")
# echo "$data"

USED=$(echo "$SNMP_OUTPUT" | grep "hrStorageUsed.$num_partitions" | awk '{print $NF}')
SIZE=$(echo "$SNMP_OUTPUT" | grep "hrStorageSize.$num_partitions" | awk '{print $NF}')

# echo "$USED"
# echo "$SIZE"

FREE=$(($SIZE - $USED))
percentage=$(awk -v used="$USED" -v size="$SIZE" 'BEGIN {print (used/size)*100}')

# echo "$percentage"
FREE=$(echo "scale=2; $FREE * 4096 / 1073741824" | bc)
SIZE=$(echo "scale=2; $SIZE * 4096 / 1073741824" | bc)
# WARNING=$(echo "$WARNING.0" | bc)
# CRITICAL=$(echo "$CRITICAL.0" | bc)

if [ $(echo "$percentage >= $CRITICAL" | bc) -eq 1 ]; then
    echo "CRITICAL - $percentage% used - Free $FREE/$SIZE GB total"
    exit 2
elif [ $(echo "$percentage >= $WARNING" | bc) -eq 1 ]; then
    echo "WARNING - $percentage% used - Free $FREE/$SIZE GB total"
    exit 1
else
    echo "OK - $percentage% used - Free $FREE/$SIZE GB total"
    exit 0
fi