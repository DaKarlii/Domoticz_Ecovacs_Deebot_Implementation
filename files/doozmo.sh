#!/bin/bash

# Script to grep Ecovacs Deebot Ozmo Status
# It is needed that Deebotozmo Plugin from And3rsl is installed and configured. https://github.com/And3rsL/Deebotozmo
# Tested with Domoticz 2021.1

# V1.0: 20210624 - Basic Initial Script
# V1.1: 20210625 - Moved Domoticz Server and IDX Settings to a seperate file

# Load Domoticz config:
source /scripts/domoticz.config                             # Please Change path to your config file. (See sample in files)

# Programpart (Dont Change if you dont know what you do)

#echo "Load Status from cloud"                              # for Debug only
deebotlibcache='./doozmolib.cache'
$deebotlib statuses > $deebotlibcache
vac_stat=`cat $deebotlibcache | awk '/Vacuum / {print $3}'`
vac_batt=`cat $deebotlibcache | awk '/Battery/ {print $2}'`
#echo $vac_stat                                             # for Debug only
#echo $vac_batt                                             # for Debug only

# Ozmo Mode Status

if  [ "$vac_stat" == "STATE_DOCKED" ] ; then
#    echo "Ozmo is in resting in Dock"                      # for Debug only
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Laden"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
    hostcmd1="http://${SERVER}${SERVER_CMD}idx=${VACMODIDX}&nvalue=20&svalue=20"     # Reset Drop-Down Switch to "Charge" in Domoticz. To be Ready for the next cleaning ;-)
    wget -q --delete-after "$hostcmd1" >/dev/null 2>&1

elif  [ "$vac_stat" == "STATE_CLEANING" ] ; then
#    echo "Ozmo is Cleaning your Room"                      # for Debug only
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Reinigen"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1

elif  [ "$vac_stat" == "STATE_PAUSED" ] ; then
#    echo "Ozmo takes a manual break"                       # for Debug only
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Pausiert"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1

elif  [ "$vac_stat" == "STATE_ERROR" ] ; then
#    echo "Ozmo has an Error, please check App"             # for Debug only
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Fehler"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1

else
    echo "New Status"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=${vac_stat}"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1

fi

# Ozmo Battery Status

hostcmd2="http://${SERVER}${SERVER_CMD}idx=${VACBATTIDX}&nvalue=0&svalue=${vac_batt}"
wget -q --delete-after "$hostcmd2" >/dev/null 2>&1

exit 0
