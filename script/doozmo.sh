#!/bin/bash

# Script to grep Ecovacs Deebot Ozmo Status
# It is needed that Deebotozmo Plugin from And3rsl is installed and configured. https://github.com/And3rsL/Deebotozmo
# Tested with Domoticz 2021.1

# V1.0: 20210624 - Basic Initial Script

# User Settings
SERVER='smarthome.aiserfeld.ovh:8086/'                               # Domoticz Server Url
VACSTATIDX=275                                      # Domoticz IDX for Ozmo Status (Type: Virtual, General, Text)
VACBATTIDX=276                                     # Domoticz IDX for Ozmo Battery (Type: Virtual, General, Percentage)
VACMODIDX=272                                       # Domoticz IDX for Ozmo Modus (Type: Virual, General, Switch)              
deebotlib='/scripts/deebot/venv/bin/deebotozmo'     # Edit path if you installed the libary to another location

# Global Settings (Dont Change if you dont know what you do)
SERVER_CMD='json.htm?type=command&param=udevice&'           # changes only Value but dont triggers an action
SWITCH_CMD='json.htm?type=command&param=switchlight&'       # changes Value and triggers the action directly 

# Programpart (Dont Change if you dont know what you do)

echo "Load Status from cloud"
deebotlibcache='./doozmolib.cache'
$deebotlib statuses > $deebotlibcache
vac_stat=`cat $deebotlibcache | awk '/Vacuum / {print $3}'`
vac_batt=`cat $deebotlibcache | awk '/Battery/ {print $2}'`
echo $vac_stat
echo $vac_batt

if  [ "$vac_stat" == "STATE_DOCKED" ] ; then
    echo "Ozmo is in resting in Dock"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Laden"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
elif  [ "$vac_stat" == "STATE_CLEANING" ] ; then
    echo "Ozmo is Cleaning your Room"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Reinigen"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
elif  [ "$vac_stat" == "STATE_PAUSED" ] ; then
    echo "Ozmo is takes a manual break"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Pausiert"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
elif  [ "$vac_stat" == "STATE_ERROR" ] ; then
    echo "Ozmo is takes a manual break"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=Fehler"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
else
    echo "New Status"
    hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACSTATIDX}&nvalue=0&svalue=${vac_stat}"
    wget -q --delete-after "$hostcmd" >/dev/null 2>&1
fi

hostcmd="http://${SERVER}${SERVER_CMD}idx=${VACBATTIDX}&nvalue=0&svalue=${vac_batt}"
wget -q --delete-after "$hostcmd" >/dev/null 2>&1

exit 0
