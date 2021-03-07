#!/bin/bash

# time lapse

if [ -z $(which fswebcam) ] ; then
	sudo apt install fswebcam -y
fi

#NOTES
#DATE=$(date +%Y-%m-%d_%H%M)
#raspistill -vf -hf -o /home/pi/pics/$DATE.jpg
#fswebcam -S 5  -r 800x600 --title "TIMELAPSE" $DATE.jpg
#echo $(echo "scale=2; $BYTES/($k_ilo)" | bc)kb ;;

SEC=1000
MIN=60000
HOUR=3600000

do_take_picture(){
	TITLE1="$1"
	DATE=$(date +%Y-%m-%d_%H%M%S)
	#fswebcam -S 25 -r 1920x1080 --scale 1080x720 --crop 1280x720  --rotate 90 --title "$1" $DATE.jpg
	fswebcam -S 50 -r 1920x1080 --crop 1080x720 --rotate 90 --title "$DATE~$TITLE1" "$DATE~$TITLE1.jpg"
}


do_countdown(){  
    local MAX=${1:-10}
 
    echo "Pausing for $MAX seconds... Ctrl-C to abort"
	echo -n $MAX
    sleep 1
    for number in $(seq 1 $MAX) ; do
		echo -n ".$(($MAX-$number))"
		#sleep 1
		sleep .97
    done 
    echo ...
}


timelapse (){
	COUNT=${1:-"3"}
	DELAY_MIN=${2:-"1"}
	NAME=${3:-"THRESHOLD_TIMELAPSE"} 
	
	echo $COUNT
	echo $DELAY_MIN
	echo $NAME
	echo
	
	for PICTURE in $(seq 1 $COUNT); do
	echo
		#echo "taking picture $NAME_$PICTURE_of_$COUNT"
		TESTNAME="$NAME~$PICTURE-$COUNT"
		echo "$TESTNAME"
		do_take_picture "$TESTNAME"
		echo $PICTURE/$COUNT
		
		if [ $PICTURE = $COUNT ]; then return 0; fi
		
		do_countdown $(( DELAY_MIN * 60 ))
	done
}

#timelapse cycles interval_minutes name
#timelapse 12 1 "THRESHOLD_test1"

timelapse $1 $2 $3
