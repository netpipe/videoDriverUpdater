#!/bin/bash
#Tecan
#Description: for use with hdmi switch to hear the audio for different devices, output the hdmi to hdmi+audio extractor then put audio into linein


#arecord --list-devices
#pacmd list-sources | grep -e 'index:' -e device.string -e 'name:'
#pacmd list-sources | grep "name:"
#pacmd set-default-source alsa_card.usb-0d8c_USB_Sound_Device-00
#pacmd set-default-source "snd_usb_audio"


pacmd set-default-source alsa_input.usb-0d8c_USB_Sound_Device-00.analog-stereo
pactl set-source-volume alsa_input.usb-0d8c_USB_Sound_Device-00.analog-stereo 100%
pactl set-source-mute alsa_input.usb-0d8c_USB_Sound_Device-00.analog-stereo 0
pactl load-module module-loopback


read -p "Press enter to continue"
pactl set-source-mute alsa_input.usb-0d8c_USB_Sound_Device-00.analog-stereo 1
pactl unload-module module-loopback
