#!/bin/bash

# NoIP updater script.  No real error handling yet; don't use this.

# Prerequisites (by Debian package name):
#   bash
#   dnsutils (for dig)
#   curl
#   python

# Configuration
noip_url="https://dynupdate.no-ip.com/nic/update"
#noip_url="http://localhost:8080/update"
user_agent='noip-update/1.0 jwilliams@codingforsoup.com'
basedir="."
log_file="$basedir/update.log"
last_ip_file="$basedir/last_ip"
last_error_file="$basedir/last_error"

queryencode() {
    python -c "import urllib; print urllib.quote_plus(\"$1\", \"\")"
}

log() {
    echo "[`date --rfc-3339=seconds`] $1" | tee -a "$log_file"
}

if [ $# -ne 3 ]; then
    echo "Usage: $0 HOSTNAME USERNAME PASSWORD"
    echo "Updates HOSTNAME on no-ip.com, using the specified"
    echo "USERNAME and PASSWORD to authenticate."
    echo ""

    log "Update failed:  invalid arguments"
    exit 1
fi

# Arguments (by position):
hostname_to_update=`queryencode "$1"`
username="$2"
password="$3"

my_ip=`dig +short myip.opendns.com @resolver1.opendns.com`

# Check for previous failure and bail out if true
if [ -f "$last_error_file" ]; then
    last_error=`cat "$last_error_file"`
    log "Update failed: resolve previous error ($last_error) and remove $last_error_file to resume updates."
    exit 2
fi

# Check to see if IP has changed and bail out if true
if [ -f "$last_ip_file" ]; then
    last_ip=`cat "$last_ip_file"`
    
    if [ "$my_ip" == "$last_ip" ]; then
        log "IP hasn't changed since last update; nothing to do"
        exit 0
    fi
fi

# If we've gotten down here, we should be good to perform the update

# Update our stored IP address
echo "$my_ip" > "$last_ip_file"

result=`curl -A "$user_agent" -u "$username:$password" "$noip_url?hostname=$hostname_to_update&myip=$my_ip"`

if [[ "$result" == *"good"* || "$result" == *"nochg"* ]]; then
    log "Update succeeded ($result)"
else
    log "Update failed ($result)--  please resolve and remove $last_error_file to resume updates"
    echo "$result" > $last_error_file
    exit 3
fi
