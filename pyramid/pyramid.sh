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
	count=$(seq 1 $1) 
	if [ "$reversePyramid" ]; then count=$(echo -e "$count" | sort --numeric-sort --reverse); fi
	for i in $(echo -e "$count"); do  
		x=$(randomChar "$i")
		y=$(randomChar "$i")
		z=$(randomChar "$i")
		toCenter "$x$y$z"
	done
}
 
function displayHelp() {
	cat << helpcontent
$0 --size=[option] 
	-r |--reverse	prints an upside down pyramid
	-s |--size		sets the height of the pyramid (default is terminal height)
	-g | --hourglass prints an hourglass
	-h | --help     displays this page
helpcontent
exit 1
}

function argParse() {
	for i in "$@"; do
	case $i in
		-r|--reverse)
			reversePyramid=1
             ;;
		-g|--hourglass)
    		hourglass=1
    		;;
		-s=*|--size=*)
    		pyramidHeight="${i#*=}"
    		shift # past argument=value
    		;;
        -h|--help=*)
    		help=true
            shift # past argument=value
        	;;
    	*)
	       	help=true # unknown option
    		;;
	esac
	done
	term_height=$(tput lines)
	if [ "$help" == true ]; then displayHelp; fi
	if [ -z "$pyramidHeight" ] && [ -z "$hourglass" ]; then
		pyramidHeight=$((term_height-2))
	elif [ "$hourglass" ] && [ -z "$pyramidHeight" ]; then
		pyramidHeight=$((term_height/2-1))
	fi

	if [ "$hourglass" ]; then 
		reversePyramid=1
		makePyramid "$pyramidHeight"
		unset reversePyramid
		makePyramid "$pyramidHeight"
	else 
		makePyramid "$pyramidHeight"
	fi
}


argParse "$@"

