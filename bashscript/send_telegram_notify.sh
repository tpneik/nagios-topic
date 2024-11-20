#!/bin/bash

# Telegram Bot API Token
BOT_TOKEN="7791409634:AAHsEUrHYkLa_QIZRKYV6WC7irK62q4qzDA"

# Chat ID (destination)
CHAT_ID="6344477473"

# Message to send
MESSAGE="<b>This is a test alert from the Bash Heelelelel Phan Trung Kien neee!</b>"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="HTML" > /dev/null