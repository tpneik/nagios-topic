#!/bin/bash

while getopts "n:d:a:r:s:t:o:e:" opt; do
    case $opt in
        n) NOTIFICATIONTYPE=$OPTARG ;;  # Notification Type
        d) SERVICEDESC=$OPTARG ;;       # Service Description
        a) HOSTALIAS=$OPTARG ;;         # Host Alias
        r) HOSTADDRESS=$OPTARG ;;       # Host Address
        s) SERVICESTATE=$OPTARG ;;      # Service State
        t) LONGDATETIME=$OPTARG ;;      # Long Date/Time
        o) SERVICEOUTPUT=$OPTARG ;;     # Service Output
        e) CONTACTEMAIL=$OPTARG ;;      # Contact Email
        *) 
           echo "Usage: $0 -n <notificationtype> -d <servicedesc> -a <hostalias> -r <hostaddress> -s <servicestate> -t <longdatetime> -o <serviceoutput> -e <contactemail>"
           exit 3 ;;
    esac
done

# Validate that all required arguments are provided
if [ -z "$NOTIFICATIONTYPE" ] || [ -z "$SERVICEDESC" ] || [ -z "$HOSTALIAS" ] || [ -z "$HOSTADDRESS" ] || [ -z "$SERVICESTATE" ] || [ -z "$LONGDATETIME" ] || [ -z "$SERVICEOUTPUT" ] || [ -z "$CONTACTEMAIL" ]; then
    echo "Usage: $0 -n <notificationtype> -d <servicedesc> -a <hostalias> -r <hostaddress> -s <servicestate> -t <longdatetime> -o <serviceoutput> -e <contactemail>"
    exit 1
fi

echo "Notification Type: $NOTIFICATIONTYPE"
echo "Hostname: $HOSTNAME"
echo "Host State: $HOSTSTATE"
echo "Host Address: $HOSTADDRESS"
echo "Host Output: $HOSTOUTPUT"
echo "Long Date Time: $LONGDATETIME"
echo "Contact Email: $CONTACTEMAIL"
echo "ALIAS: $HOSTALIAS"


# Set the table color based on the host state
RIBON_TABLE_COLOR="#BEBB1C"  
TABLE_COLOR="#FFFDD0"  


# Customize the subject
SUBJECT="$NOTIFICATIONTYPE - Service Alert: $HOSTALIAS"

# Define the HTML email content with a color-coded table
HTML_CONTENT=$(cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification Table</title>
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: auto; /* Center the table */
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: $RIBON_TABLE_COLOR;
        }
        td {
            background-color: $TABLE_COLOR;
        }
    </style>
</head>
<body>

<table border="1">
  <tr>
    <th colspan="2">Notification Details</th>
  </tr>
  <tr>
    <td><b>Notification Type</b></td>
    <td>$NOTIFICATIONTYPE</td>
  </tr>
  <tr>
    <td><b>Service</b></td>
    <td>$SERVICEDESC</td>
  </tr>
  <tr>
    <td><b>Host</b></td>
    <td>$HOSTALIAS</td>
  </tr>
  <tr>
    <td><b>Address</b></td>
    <td>$HOSTADDRESS</td>
  </tr>
  <tr>
    <td><b>State</b></td>
    <td>$SERVICESTATE</td>
  </tr>
  <tr>
    <td><b>Date/Time</b></td>
    <td>$LONGDATETIME</td>
  </tr>
  <tr>
    <td><b>Additional Info</b></td>
    <td>$SERVICEOUTPUT</td>
  </tr>
</table>

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
