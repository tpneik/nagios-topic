#!/bin/bash

# Define Nagios variables
NOTIFICATIONTYPE=$1
HOSTNAME=$2
HOSTSTATE=$3
HOSTADDRESS=$4
HOSTOUTPUT=$5
LONGDATETIME=$6
CONTACTEMAIL=$7


if [ "$HOSTSTATE" == "DOWN" ]; then
    SUBJECT="🔥 Critical Alert: $HOSTNAME is $HOSTSTATE **"
else
    SUBJECT="🔔 Alert: $HOSTNAME is $HOSTSTATE **"
fi


# Set the table color based on the host state
if [ "$HOSTSTATE" == "WARNING" ]; then
    TABLE_COLOR="#FFAA1D"  # Yellow background
elif [ "$HOSTSTATE" == "CRITICAL" ]; then
    TABLE_COLOR="#E32227"  # Red background
else
    TABLE_COLOR="#3EB489"  # Green background (for OK or other states)
fi

# Customize the subject
SUBJECT="** $NOTIFICATIONTYPE Host Alert: $HOSTNAME is $HOSTSTATE **"

# Define the HTML email content with a color-coded table
HTML_CONTENT=$(cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nagios Notification</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .email-container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border: 1px solid #dddddd;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .header {
            background-color: $TABLE_COLOR;
            color: #ffffff;
            text-align: center;
            padding: 20px;
            font-size: 20px;
        }
        .content {
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #dddddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: $TABLE_COLOR;
            color: white;
        }
        .footer {
            text-align: center;
            padding: 10px;
            font-size: 14px;
            color: #666666;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
            🌟 Nagios Alert Notification 🌟
        </div>
        <div class="content">
            <table>
                <tr>
                    <th>Field</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Notification Type</td>
                    <td>$NOTIFICATIONTYPE</td>
                </tr>
                <tr>
                    <td>Host</td>
                    <td>$HOSTNAME</td>
                </tr>
                <tr>
                    <td>State</td>
                    <td>$HOSTSTATE</td>
                </tr>
                <tr>
                    <td>Address</td>
                    <td>$HOSTADDRESS</td>
                </tr>
                <tr>
                    <td>Info</td>
                    <td>$HOSTOUTPUT</td>
                </tr>
                <tr>
                    <td>Date/Time</td>
                    <td>$LONGDATETIME</td>
                </tr>
            </table>
        </div>
        <div class="footer">
            &copy; 2024 Nagios Monitoring | <a href="http://192.168.18.150/nagios" style="color: #007bff; text-decoration: none;">Nagios Dashboard</a>
        </div>
    </div>
</body>
</html>
EOF
)

# Use sendmail to send the email
{
    echo "To: $CONTACTEMAIL"
    echo "Subject: $SUBJECT"
    echo "Content-Type: text/html"
    echo
    echo "$HTML_CONTENT"
} | /usr/sbin/sendmail -t
