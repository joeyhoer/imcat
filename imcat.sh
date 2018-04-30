#!/usr/bin/env bash

# Default direction: Vertical
dir="-append"

# Output file
outfile="$HOME/Pictures/screen$(date '+%Y%m%d%H%M%S').png"

# Get Options
while getopts ":VHg:b:o:p:" OPTION; do
  case $OPTION in
    o) outfile=$OPTARG;;
    :) exit 1;;
    \?) exit 1;;
    *)
      [[ "$OPTARG" == "" ]] && OPTARG='"-'$OPTION' 1"'
      OPTION="OPT_$OPTION"
      eval ${OPTION}=$OPTARG
      ;;
  esac
done

# Shift options out
shift $(( OPTIND - 1 ))

# Set background color
bg_color="$OPT_b"
if [[ "$OPT_b" == "" ]]; then
  bg_color=$(identify -format "%[pixel:p{0,0}]" "$1")
fi
background="-background ${bg_color}"

# Set default to vertial append
if [[ -z "$OPT_V" && -z "$OPT_H" ]]; then
  OPT_V=0
fi

# Vertical append
if [[ ! "$OPT_V" == "" ]]; then
  dir="-append"

  # Set gravity
  if [[ ! "$OPT_g" == "" ]]; then
    max_width=0
    for img in "$@"; do
      width=$(identify -format '%w' "$img")
      if [ $width -gt $max_width ]; then
        max_width=$width
      fi
    done
    gravity="-gravity ${OPT_g} -extent ${max_width}x"
  fi

  # Set padding
  if [[ -n "$OPT_p" ]]; then
    splice="-splice 0x${OPT_p}+0+0"
    chop="-chop 0x${OPT_p}+0+0"
  fi
fi

# Horizontal append
if [[ ! "$OPT_H" == "" ]]; then
  dir="+append"

  # Set gravity
  if [[ ! "$OPT_g" == "" ]]; then
    max_height=0
    for img in "$@"; do
      height=$(identify -format '%h' "$img")
      if [ $height -gt $max_height ]; then
        max_height=$height
      fi
    done
    gravity="-gravity ${OPT_g} -extent x${max_height}"
  fi

  # Set padding
  if [[ -n "$OPT_p" ]]; then
    splice="-splice ${OPT_p}x0+0+0"
    chop="-chop ${OPT_p}x0+0+0"
  fi
fi

# Concatenate images
convert "$@" $background $splice $gravity $dir $chop "$outfile"
