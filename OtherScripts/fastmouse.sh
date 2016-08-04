#!/bin/bash
imwheel -f 
#not sure if the while loop interferes with the rest of the load guess the cairodock will tell
#while [ 1 ]; do sleep 10;xset m 5 1;echo ha; done; &

xset m 5 1

current=$(xmodmap -pp | head -5 | tail -1 | awk '{print $2}');

if [ "$current" -eq "1" ]
then 
        xmodmap -e "pointer = 3 2 1";
else
        xmodmap -e "pointer = 1 2 3";
fi
