# Script and Installguide to implement Ecovacs Deebot Vacuum cleaners to Domoticz


## Requirements

* Domoticz (https://github.com/domoticz/domoticz)
* Ecovacs Deebot (Script tested and in use with an Ozmo 950)
* Python Plugin Deebotozmo (https://github.com/And3rsL/Deebotozmo)

## Usage

In Domoticz:
Create new Devices 
* Status (Type: Virtual, General, Text)
* Battery (Type: Virtual, General, Percentage)
* Modus (Type: Virual, General, Switch) 

Install Python Plugin Deebotozmo (Next Step or use the original from Repository)

sudo apt-get install python3-venv libatlas-base-dev 
sudo ./deebot && cd ./deebot
python3 -m venv venv
source venv/bin/activate
pip install deebotozmo

Create the Config for Deebotozmo with the same user, which is running the Domoticz Service!

~/deebot/venv/bin $ ./deebotozmo createconfig

copy the files/doozmo.sh - template to your directory (rename it to doozmo.sh)

Create a crontab entry to run the script every 5 minutes


Here the possible Settings for the Cleaning mode Switch:

[logo]: https://github.com/DaKarlii/Domoticz_Ecovacs_Deebot_Implementation/raw/master/pictures/Domoticz_Switch_Settings.jpg "Domoticz Switch Settings"


## Features

* Start Cleaning, Send to Dock, Pause/Resume Cleaning from Domoticz
* Get Status of Cleaning and Batterylevel in Domoticz

## ToDO
Nothing Planned for the moment

## used Repositorys (Thanks to the people who are developing that):

* https://github.com/And3rsL/Deebotozmo
* https://github.com/domoticz/domoticz


