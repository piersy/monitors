#!/bin/bash
set -eu

[ -z "${DISPLAY}" ] && echo 'X: server not started.' && exit 1

TEMP_FILE=$(mktemp)
trap "rm ${TEMP_FILE}" EXIT
set +e # grep returns 1 if the output is empty which can happend if only eDP1 is connected 
xrandr |  grep " connected" | grep -v "eDP1" > ${TEMP_FILE}
set -e
LINES=$(wc -l ${TEMP_FILE})
cat ${TEMP_FILE}
LINES=${LINES%% *}
case ${LINES} in
	0)
		xrandr --output HDMI1 --off --output VGA1 --off --output eDP1 --auto
		;;
	1)
		CONTENT=$(cat ${TEMP_FILE})
		OUTPUT=${CONTENT%% *}
		case ${OUTPUT} in
			HDMI1)
				xrandr --output VGA1 --off --output HDMI1 --auto --above eDP1 --output eDP1 --auto
				#/usr/bin/xrandr --display :0.0 --output HDMI1 --auto
				;;
			VGA1)
				xrandr --output HDMI1 --off --output VGA1 --auto --above eDP1 --output eDP1 --auto
				;;
		esac
		;;
	2)
		xrandr --output VGA1 --above eDP1 --rotate left --auto  --output HDMI1 --right-of VGA1  --primary --auto --output eDP1 --auto
		;;
esac
