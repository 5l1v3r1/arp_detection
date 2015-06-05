#!/bin/sh --
color=$1
if [ ${color} = "red" ]; then
	echo 0 > /sys/class/leds/qihoo:green:status/brightness
	echo 1 > /sys/class/leds/qihoo:red:status/brightness
elif [ ${color} = "yellow" ]; then
	echo 1 > /sys/class/leds/qihoo:green:status/brightness
	echo 1 > /sys/class/leds/qihoo:red:status/brightness
elif [ ${color} = "green" ]; then
	echo 0 > /sys/class/leds/qihoo:red:status/brightness
	echo 1 > /sys/class/leds/qihoo:green:status/brightness
else
	echo 0 > /sys/class/leds/qihoo:red:status/brightness
	echo 0 > /sys/class/leds/qihoo:green:status/brightness
fi
