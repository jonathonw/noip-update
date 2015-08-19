# Noip.com Update Script

Update script for [noip.com](http://noip.com/); ideal for home server use on something like a Raspberry Pi, if you don't want to or can't use the [official client](https://www.noip.com/download).

## Usage

This script is most useful if added to your user's crontab.  To do so, run `crontab -e` as the desired user, then add a line like:

    */15 * * * * cd /home/username/path/to/noip-update && ./noip-update.sh HOSTNAME USERNAME PASSWORD

replacing `HOSTNAME` with the hostname to be updated, `USERNAME` with the email address associated with your noip.com account, and `PASSWORD` with your noip.com password.

The script can be also run manually like so:

    ./noip-update.sh HOSTNAME USERNAME PASSWORD

where `HOSTNAME` is the hostname to be updated, `USERNAME` is the email address associated with your noip.com account, and `PASSWORD` is your noip.com password.

For example:

    ./noip-update.sh "some-fake-domain.hopto.org" "fakeuser@example.com" "correct-horse-battery-staple"
    
## Loggging

This script logs its output both to the terminal (if applicable) and to the file `update.log`.  Result and error codes returned by noip.com's update service are used in this log file--  [these are documented in noip.com's API documentation](https://www.noip.com/integrate/response)

## Caveats

Per noip's API usage policy, this script won't attempt to update your IP address on noip.com if it detects that your IP hasn't changed since its last run.  This means that, if your IP on noip.com is changed through some other means (e.g. another DDNS update client, or a manual change on the noip.com website), the script won't attempt to update your IP address even if it's different from the one on file.  To force an update, delete the `last_ip` file in noip-update's working directory.

Also, in the event that an error occurs and an update is rejected by noip.com, this script will stop attempting to update your IP until manual intervention.  To attempt to update again, delete the `last_error` file and rerun `noip-update.sh` (or wait until the next scheduled cron task).
