#!/bin/bash
export DISPLAY=:2.0
sleep 1
#zenity --warning
cd ~/abin
#./liquid.sh
#./launchConky.sh
sleep 7;
./fastmouse.sh &
~/Programs/GUI/WindowManagers/TilingManagers/pywo-0.2/pywo2.sh &
xhost + SI:localuser:clayton 
autokey-gtk &
# start-pulseaudio-x11
#pulseaudio -k
pacmd set-default-sink 3
./ajsnapshot
/usr/bin/pactl set-sink-volume 0 30%
xterm -e ./CairoDock $DISPLAY &


#export DISPLAY=:1.0
#DISPLAY=:0.0 xterm &
#xhost + SI:localuser:clayton 
#xhost + SI:localuser:weby
#xhost + localhost
#final sound :)
#/usr/bin/canberra-gtk-play --id="desktop-login" --description="GNOME Login" &
