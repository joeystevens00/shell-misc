#!/bin/bash
# AUTHOR: Joey Stevens
# Description: Prints a pyramid

function randomChar() {
	cat /dev/urandom | tr -dc 'A-za-z0-9' | fold -w$1 | head -1
}

function toCenter() {
	term_width=$(tput cols)
	if [ "$1" ]; then
		text="$1"
	else
		while read pipe; do
			text="$pipe"
		done
	fi
	printf "%*s\n" $(( (${#text} + term_width) / 2)) "$text"
}


function makePyramid() {
	for i in $(seq 1 $1); do                                                                                          
		x=$(randomChar "$i")
		y=$(randomChar "$i")
		z=$(randomChar "$i")
		toCenter "$x$y$z"
	done
}

pyramidHeight="$1"
if [ -z "$pyramidHeight" ]; then
	term_height=$(tput lines)
	pyramidHeight=$((term_height-2))
fi
makePyramid "$pyramidHeight"
