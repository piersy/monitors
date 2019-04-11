#!/bin/bash
set -eu

[ -z "${DISPLAY}" ] && echo 'X: server not started.' && exit 1

# Note, we need to quote this variable when expanding it otherwise the newlines
# will be converted into spaces.
CONNECTED=$(xrandr |  grep " connected" | awk '{print $1}')

LAPTOP=$(echo "$CONNECTED" | grep "^e")

if [[ -z $LAPTOP ]]; then
	echo "Failed to detect laptop display, expecting display beginning with 'e'"
	echo "Connected displays found"
	echo "$CONNECTED"
	exit 1
fi

REMAINING=$(echo "$CONNECTED" | grep -v "^e" | sort)
LINE_COUNT=$(echo -n "$REMAINING" | grep -c "^")

MONITOR_1=$(echo "$REMAINING" | sed -n 1p)
MONITOR_2=$(echo "$REMAINING" | sed -n 2p)

case ${LINE_COUNT} in
	0)
		xrandr --output $LAPTOP --auto
		;;
	1)
		xrandr --output $MONITOR_1 --auto --output $LAPTOP --off
		;;
	2)
		xrandr --output $MONITOR_2 --rotate left --left-of $MONITOR_1 --auto  --output $MONITOR_1 --primary --auto --output $LAPTOP --below $MONITOR_1 --auto
		;;
esac
