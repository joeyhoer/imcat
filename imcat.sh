#!/usr/bin/env bash

# Default direction: Vertical
dir="-append"

# Output file
outfile="$HOME/Pictures/screen$(date '+%Y%m%d%H%M%S').png"

# Get Options
while getopts ":VHg:b:o:" OPTION; do
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

bg_color="$OPT_b"
if [[ "$OPT_b" == "" ]]; then
  bg_color=$(identify -format "%[pixel:p{0,0}]" "$1")
fi
background="-background ${bg_color}"

# Set default to vertial append
if [[ -z "$OPT_V" && -z "$OPT_H" ]]; then
  OPT_V=1
fi

# Vertical append
if [[ ! "$OPT_V" == "" ]]; then
  dir="-append"

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
fi

# Horizontal append
if [[ ! "$OPT_H" == "" ]]; then
  dir="+append"

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
fi

# Concatenate images
convert "$@" $background $gravity $dir "$outfile"
