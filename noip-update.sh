#!/bin/bash

# NoIP updater script.  No real error handling yet; don't use this.

# Prerequisites (by Debian package name):
#   bash
#   dnsutils (for dig)
#   curl
#   python

# Configuration
user_agent='noip-update/1.0 jwilliams@codingforsoup.com'
basedir="."
log_file="$basedir/update.log"
last_ip_file="$basedir/last_ip"
last_error_file="$basedir/last_error"

urlencode() {
    python -c "import urllib; print urllib.quote(\"$1\", \"\")"
}

queryencode() {
    python -c "import urllib; print urllib.quote_plus(\"$1\", \"\")"
}

log() {
    echo "[`date --rfc-3339=seconds`] $1" >> $log_file
}

if [ $# -ne 3 ]; then
    echo "Usage: $0 HOSTNAME USERNAME PASSWORD"
    echo "Updates HOSTNAME on no-ip.com, using the specified"
    echo "USERNAME and PASSWORD to authenticate."

    log "Update failed:  invalid arguments"
    exit 1
fi

# Arguments (by position):
hostname_to_update="$1"
username=`urlencode "$2"`
password=`urlencode "$3"`

my_ip=`dig +short myip.opendns.com @resolver1.opendns.com`

urlencode "some stuff test/thingy@moo"
queryencode "some more stuff test/thingy@moo"
