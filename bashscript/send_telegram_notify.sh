#!/bin/bash


while getopts "n:a:r:o:" opt; do
    case $opt in
        n) NOTIFICATIONTYPE=$OPTARG ;;  # -n for NOTIFICATIONTYPE
        a) HOSTALIAS=$OPTARG ;;         # -a for HOSTALIAS
        r) HOSTADDRESS=$OPTARG ;;       # -r for HOSTADDRESS
        o) SERVICEOUTPUT=$OPTARG ;;     # -o for SERVICEOUTPUT
        *)
           echo "Usage: $0 -n <notificationtype> -a <hostalias> -r <hostaddress> -o <serviceoutput>"
           exit 1 ;;
    esac
done

# Validate that all required arguments are provided
if [ -z "$NOTIFICATIONTYPE" ] || [ -z "$HOSTALIAS" ] || [ -z "$HOSTADDRESS" ] || [ -z "$SERVICEOUTPUT" ]; then
    echo "Usage: $0 -n <notificationtype> -a <hostalias> -r <hostaddress> -o <serviceoutput>"
    exit 1
fi

# Print variables to verify they are correctly parsed (for testing purposes)
echo "Notification Type: $NOTIFICATIONTYPE"
echo "Host Alias: $HOSTALIAS"
echo "Host Address: $HOSTADDRESS"
echo "Service Output: $SERVICEOUTPUT"

# Telegram Bot API Token
BOT_TOKEN="7791409634:AAHsEUrHYkLa_QIZRKYV6WC7irK62q4qzDA"

# Chat ID (destination)
CHAT_ID="6344477473"

# Message to send
MESSAGE="<b>$NOTIFICATIONTYPE : $HOSTALIAS - $HOSTADDRESS</b>
<i>$SERVICEOUTPUT</i>"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${CHAT_ID}" \
    --data-urlencode "text=${MESSAGE}" \
    --data-urlencode "parse_mode=HTML"