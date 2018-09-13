#!/bin/bash
#HandBrake autoripper
#can rename shell script to have 2 instances running , change drive after making new script
#cd ./rip
# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------


PDIR=${0%`basename $0`}
LCK_FILE=`basename $0`.lck


tempFolder="/tmp"
drive="/dev/sr1"
output="./rips"
size=720 #920, 1080
threads=3

if [ -d $output ]; then
    echo "directory exists"
else
    mkdir $output
 #   mkdir $output/handbraketmp/
fi

# ------------------------------------------------------------
# Am I Running
# ------------------------------------------------------------
if [ -f "${LCK_FILE}" ]; then
  # The file exists so read the PID
  # to see if it is still running
  MYPID=`head -n 1 "${LCK_FILE}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`
  if [ -z "${TEST_RUNNING}" ]; then
    # The process is not running
    # Echo current PID into lock file
    echo "Start autoripper @" >> $output/autorip.log
   date >> $output/autorip.log
    echo $$ > "${LCK_FILE}"
  else
    echo "`basename $0` is already running [${MYPID}]" >> $output/autorip.log
   #date >> ./rip/autorip.log
    exit 0
  fi
else
  echo "Start autoripper @" >> ./rip/autorip.log
   date >> $output/autorip.log
  echo $$ > "${LCK_FILE}"
fi
# ------------------------------------------------------------
# Do Something
# ------------------------------------------------------------
#while true
#do
#ismediaincheck=$(hal-device | grep $drive)
#isi=${#ismediaincheck}
#if [ $isi -gt 85 ]
if [ 1 ]
then
    echo "GO! " >> $output/autorip.log
       date >> $output/autorip.log
    mintime=20
    lsdvd /dev/sr1 | grep -i Length > not.tmp
    titles=$(wc -l < not.tmp )
    TITLE=$(lsdvd $drive | grep -i Disc | sed 's/Disc Title: //g')
    echo "Disc title: " $TITLE
    echo There are $titles titles
    let counter=1
    let ttitles=$titles+1
    while [[ $counter <  $ttitles ]]; do
        echo "Title " $counter "",
        hour=$(sed -n ''$counter'p' not.tmp | awk -F'gth: ' '{print $2}' | cut -c1-2)
        min=$(sed -n ''$counter'p' not.tmp | awk -F'gth: ' '{print $2}' | cut -c4-5)
        totalmin=$(($hour * 60))
        let totalmin=$totalmin+$min
            if [[ $totalmin -gt $mintime ]]; then
                echo Title $counter of $titles length is $totalmin minutes !!!
                COPYTO=$"$tempFolder/$TITLE-T$counter.avi"
                OUTPUT=$"$output/$TITLE-T$counter.avi"
                #COPYTO=$"./rip/$TITLE.avi"
                #OUTPUT=$"./rip/handbraketmp/$TITLE.avi"
                


                  echo "Ripping title to " $COPYTO >> $output/autorip.log
                  date >> $output/autorip.log
                #cpulimit -l80
                #./HandBrakeCLI -C1 -i /dev/sr1 -o $OUTPUT -t $counter -e x264  -q 0.4 -a 1,1 -E faac,ac3 -B 160,160 -6 dpl2,auto -R 48,Auto -D 1.0,0.0 -f mp4 --cpu 4 --decomb -4 -X 960 --loose-anamorphic -m -x cabac=0:ref=2:me=umh:b-adapt=2:weightb=0:trellis=0

#ultrafast, superfast, veryfast, faster, fast, medium to slow, slower and veryslow
#cpulimit -c5 
                HandBrakeCLI -C1 -i $drive -o $COPYTO -t $counter -e x264  -q 20 --x264-preset ultrafast --x264-tune fastdecode -a 1,1 -E faac,ac3 -B 160,160 -6 dpl2,auto -R 48,Auto -D 1.0,0.0 -f mp4 --decomb 4 -X $size --loose-anamorphic -m -x cabac=0:ref=2:me=umh:b-adapt=2:weightb=0:trellis=0 --nlmeans=threads=$threads

                #cpulimit -l180 -- HandBrakeCLI -C1 -i $drive -o $OUTPUT -t $counter -e x264  -q 20 -a 1,1 -E faac,ac3 -B 160,160 -6 dpl2,auto -R 48,Auto -D 1.0,0.0 -f mp4 --decomb 4 -X 720 --loose-anamorphic -m -x cabac=0:ref=2:me=umh:b-adapt=2:weightb=0:trellis=0


                #cpulimit -l200 -- HandBrakeCLI -C1 -i $drive -o "$COPYTO" -t "$counter" -e x264 -q 20 -B 160 -a 1,1 -E faac,ac3  -R -D 1.0,0.0 --decomb 4 -X 720 --loose-anamorphic -m

               #cpulimit -l200 -- HandBrakeCLI -i $drive -C1 -o $COPYTO -m -E copy --audio-copy-mask ac3,dts --audio-fallback ffac3 -e x264 -q 20 -B 160


                #HandBrakeCLI -C1 -i $drive -o "$COPYTO" -t "$counter" -e x264 -q 0.4 -a 1,1 -E faac,ac3 -B 160,160 -6 dpl2,auto -R 48,Auto -D 1.0,0.0 -f mp4 --decomb 4 -X 960 --loose-anamorphic -m -x cabac=0:ref=2:me=umh:b-adapt=2:weightb=0:trellis=0


                echo "Done ripping, moving file, umounting disc and ejecting." >> $output/autorip.log
                   date >> $output/autorip.log
                mv $COPYTO $OUTPUT
            else
                echo Title $counter of $titles length is $totalmin minutes
            fi
            let counter=$counter+1
        done
        rm not.tmp

        #umount $drive
        #eject $drive


        else
        echo "Running @"
           date
    fi
#sleep 15
#done
# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------
rm -f "${LCK_FILE}"
# ------------------------------------------------------------
# Done
# ------------------------------------------------------------
exit 0
