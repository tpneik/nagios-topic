#!/bin/bash

while getopts "H:p:P:" opt; do
    case $opt in
        H) HOST=$OPTARG ;;
        p) PORT=$OPTARG ;;
        P) PROTOCOL=$OPTARG ;;
        *) echo "Lack of param" | exit 3 ;;
    esac
done

if [ -z "$HOST" ] || [ -z "$PORT" ]; then
    echo "Usage: $0 -H <host> -p <port>"
    exit 3
fi

data=$(nc -zv -$PROTOCOL $HOST $PORT 2>&1 | awk '{print $NF}')
# echo "nc -zv -$PROTOCOL $HOST $PORT 2>&1"
if [ "$data" == "succeeded!" ]; then

    if [ "$PROTOCOL" == "u" ]; then
        echo "OK - UDP Connection to $HOST:$PORT $data"
    elif [ "$PROTOCOL" == "t" ]; then
        echo "OK - TCP Connection to $HOST:$PORT $data"
    fi
    # echo "OK - Connection to $HOST:$PORT $data"
    exit 0
else
    echo "CRITICAL - Connection to $HOST:$PORT $data"
    exit 2
fi
# echo "$data"